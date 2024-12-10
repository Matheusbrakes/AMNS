# Nome da imagem Docker
IMAGE_NAME = plantseg_image

# Caminho para os dados de treinamento
DATASET_PATH = /caminho/para/seu/dataset

# Caminho para salvar os resultados
OUTPUT_PATH = /caminho/para/salvar/resultados

# Caminho para os logs e checkpoints no host
LOG_DIR = /caminho/para/salvar/logs
CHECKPOINT_DIR = $(LOG_DIR)/checkpoints

# Caminho para o arquivo de configuração do modelo
CONFIG_FILE = configs/segnext/segnext_mscan-t_1xb16-adamw-40k_plantseg115-512x512.py

# Caminho para o checkpoint mais recente do modelo treinado
CHECKPOINT_FILE = $(CHECKPOINT_DIR)/latest.pth

# Constrói a imagem Docker
build:
	docker build -t $(IMAGE_NAME) .

# Inicia um contêiner Docker interativo
run:
	docker run -it --rm \
		-v $(DATASET_PATH):/app/data \
		-v $(OUTPUT_PATH):/app/output \
		-v $(LOG_DIR):/app/logs \
		$(IMAGE_NAME) \
		bash -c "conda run -n plantseg_env bash"

# Executa o treinamento com o modelo configurado
train:
	docker run -it --rm \
		-v $(DATASET_PATH):/app/data \
		-v $(OUTPUT_PATH):/app/output \
		-v $(LOG_DIR):/app/logs \
		$(IMAGE_NAME) \
		bash -c "conda run -n plantseg_env python tools/train.py $(CONFIG_FILE)"

# Avalia o modelo treinado e gera métricas
evaluate:
	docker run -it --rm \
		-v $(DATASET_PATH):/app/data \
		-v $(OUTPUT_PATH):/app/output \
		-v $(LOG_DIR):/app/logs \
		$(IMAGE_NAME) \
		bash -c "conda run -n plantseg_env python tools/test.py $(CONFIG_FILE) $(CHECKPOINT_FILE) --eval mIoU"

# Limpa o contêiner criado
clean:
	docker rm -f $(shell docker ps -aqf "ancestor=$(IMAGE_NAME)")
