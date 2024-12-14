# Use uma imagem base oficial do Python 3.11 com Miniconda
FROM continuumio/miniconda3:latest

# Atualize pacotes do sistema e instale ferramentas necessárias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Crie e ative um ambiente Conda específico para o projeto
RUN conda create --name plantseg_env python=3.11 -y && \
    echo "source activate plantseg_env" >> ~/.bashrc

# Instale PyTorch, torchvision e torchaudio compatíveis com CUDA 11.3
RUN conda run -n plantseg_env conda install pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch -y

# Instale o OpenMIM e o MMCV na versão necessária
RUN conda run -n plantseg_env pip install -U openmim && \
    conda run -n plantseg_env mim install mmengine && \
    conda run -n plantseg_env mim install "mmcv==2.1.0"

# Defina o diretório de trabalho
WORKDIR /app

# Clone o repositório PlantSeg
RUN git clone https://github.com/tqwei05/PlantSeg.git .

# Copie o dataset local para o contêiner
COPY plantsegv2 /app/data/temp_plantseg/

# Ajuste a estrutura do dataset e renomeie para `plantseg115`
RUN if [ -d "/app/data/temp_plantseg/plantsegv2" ]; then \
        mkdir -p /app/data/plantsegv2 && \
        mv /app/data/temp_plantseg/plantsegv2/* /app/data/plantsegv2/ && \
        rmdir /app/data/temp_plantseg/plantsegv2; \
    fi && \
    mv /app/data/plantsegv2 /app/data/plantseg115

# Copie o arquivo requirements.txt
COPY requirements.txt .

# Instale as dependências do projeto
RUN conda run -n plantseg_env pip install -r requirements.txt

# Configure o shell para o uso do Conda
SHELL ["/bin/bash", "-c"]

# Defina o comando padrão ao iniciar o contêiner
CMD ["bash"]