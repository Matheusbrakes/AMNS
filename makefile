# Nome da imagem Docker
IMAGE_NAME = plantseg_image

# Caminhos para salvar os resultados e logs
OUTPUT_PATH = $(CURDIR)/AMNS/output
LOG_DIR = $(CURDIR)/AMNS/logs
CHECKPOINT_DIR = $(LOG_DIR)/checkpoints

# Arquivo de configuração do modelo e checkpoint
CONFIG_FILE = configs/segnext/segnext_mscan-t_1xb16-adamw-40k_plantseg115-512x512.py
CHECKPOINT_FILE = $(CHECKPOINT_DIR)/latest.pth

# Constrói a imagem Docker
build:
	docker build -t $(IMAGE_NAME) .

# Inicia um contêiner Docker interativo
run:
	docker run -it --rm \
		-v $(OUTPUT_PATH):/app/output \
		-v $(LOG_DIR):/app/logs \
		$(IMAGE_NAME) \
		bash -c "source activate plantseg_env && exec bash"

# Executa o treinamento com o modelo configurado
train:
	docker run -it --rm \
        --shm-size=2g \
		--gpus all \
		-v $(OUTPUT_PATH):/app/output \
		-v $(LOG_DIR):/app/logs \
		-v $(LOG_DIR)/checkpoints:/app/checkpoints \
		$(IMAGE_NAME) \
		bash -c "source activate plantseg_env && export PYTHONPATH=\${PYTHONPATH}:/app && CUDA_VISIBLE_DEVICES=0 python tools/train.py $(CONFIG_FILE)"


# Avalia o modelo treinado
evaluate:
	docker run -it --rm \
		--gpus all \
		-v $(CURDIR)/plantseg/plantseg:/app/data/plantseg115 \
		-v $(OUTPUT_PATH):/app/output \
		-v $(LOG_DIR):/app/logs \
		-v $(LOG_DIR)/checkpoints:/app/checkpoints \
		$(IMAGE_NAME) \
		bash -c "source activate plantseg_env && CUDA_VISIBLE_DEVICES=0 python evaluation/evaluation_segmentation.py --config /app/eval_config.yaml"

# Limpa o contêiner criado
clean:
	@echo "Limpando contêiner Docker..."
	-docker stop $(CONTAINER_NAME) || true
	-docker rm $(CONTAINER_NAME) || true
	@echo "Removendo a imagem Docker..."
	-docker rmi $(IMAGE_NAME) || true