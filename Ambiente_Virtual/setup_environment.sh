#!/bin/bash

# Verifica se o conda está instalado
if ! command -v conda &> /dev/null
then
    echo "Conda não está instalado. Por favor, instale o Anaconda ou Miniconda e tente novamente."
    exit 1
fi

# Cria o ambiente Conda plantseg_env
echo "Criando o ambiente Conda plantseg_env..."
conda create --name plantseg_env python=3.11 -y

# Ativa o ambiente Conda
echo "Ativando o ambiente Conda plantseg_env..."
# Detecta o shell atual e ativa o ambiente de acordo
SHELL_NAME=$(basename "$SHELL")
if [ "$SHELL_NAME" = "bash" ]; then
    source activate plantseg_env
elif [ "$SHELL_NAME" = "zsh" ]; then
    source activate plantseg_env
else
    echo "Shell não suportado para ativação automática. Por favor, ative o ambiente manualmente."
    exit 1
fi

# Instala os pacotes Conda
echo "Instalando pacotes com Conda..."
conda install -y pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia

# Atualiza o pip
echo "Atualizando o pip..."
pip install --upgrade pip

# Instala o openmim
echo "Instalando openmim..."
pip install -U openmim

# Instala mmengine e mmcv
echo "Instalando mmengine e mmcv..."
mim install mmengine
mim install "mmcv==2.1.0"

# Verifica se o arquivo requirements.txt existe
if [ ! -f requirements.txt ]; then
    echo "Arquivo requirements.txt não encontrado. Certifique-se de que ele está no diretório atual."
    exit 1
fi

# Instala os pacotes do requirements.txt
echo "Instalando pacotes do requirements.txt..."
pip install -r requirements.txt

# Clona o repositório PlantSeg
REPO_URL="https://github.com/tqwei05/PlantSeg.git"
TARGET_DIR="./PlantSeg"
if [ ! -d "$TARGET_DIR" ]; then
    echo "Clonando o repositório PlantSeg..."
    git clone $REPO_URL $TARGET_DIR
    echo "Repositório clonado em $TARGET_DIR."
else
    echo "Repositório já existente em $TARGET_DIR. Ignorando clonagem."
fi

echo "Ambiente plantseg_env configurado com sucesso!"