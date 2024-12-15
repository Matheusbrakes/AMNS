# Caminhos para salvar os resultados e logs
OUTPUT_PATH = $(CURDIR)/AMNS/output
LOG_DIR = $(CURDIR)/AMNS/logs
CHECKPOINT_DIR = $(LOG_DIR)/checkpoints
METADATA_SOURCE = $(CURDIR)/data/Metadata.csv
METADATA_TARGET = /app/data/plantseg115/Metadata.csv

# Arquivo de configuração do modelo e checkpoint
CONFIG_FILE = configs/segnext/segnext_mscan-t_1xb16-adamw-40k_plantseg115-512x512.py

# Criação do ambiente
setup:
	bash setup_environment.sh

# Rodar o ambiente virtual interativo
run:
	@echo "Ativando o ambiente virtual Conda plantseg_env..."
	source ~/miniconda/bin/activate plantseg_env && bash

# Treinamento do modelo
train:
	source ~/miniconda/bin/activate plantseg_env && \
	sed -i 's/reduce_zero_label=False/reduce_zero_label=True/g' configs/_base_/datasets/plantseg115.py && \
	export PYTHONPATH=$$PYTHONPATH:/app && \
	CUDA_VISIBLE_DEVICES=0 TORCH_USE_CUDA_DSA=1 python tools/train.py $(CONFIG_FILE)

train_meta:
	source ~/miniconda/bin/activate plantseg_env && \
	echo 'Substituindo Metadata.csv com o arquivo local...' && \
	cp $(METADATA_SOURCE) $(METADATA_TARGET) && \
	export PYTHONPATH=$$PYTHONPATH:/app && \
	CUDA_VISIBLE_DEVICES=0 python tools/train.py $(CONFIG_FILE)

# Avaliação do modelo
evaluate:
	source ~/miniconda/bin/activate plantseg_env && \
	CUDA_VISIBLE_DEVICES=0 python evaluation/evaluation_segmentation.py --config /app/eval_config.yaml

# Limpeza de arquivos temporários
clean:
	@echo "Limpando arquivos temporários..."
	rm -rf $(OUTPUT_PATH) $(LOG_DIR)
