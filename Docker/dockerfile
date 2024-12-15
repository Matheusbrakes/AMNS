# Use uma imagem base NVIDIA com suporte a CUDA 11.8
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# Instale dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instale o Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/opt/miniconda/bin:$PATH"

# Crie o ambiente Conda e instale Python 3.11
RUN conda create --name plantseg_env python=3.11 -y

# Instale PyTorch, torchvision e torchaudio com CUDA
RUN conda run -n plantseg_env conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y

# Instale o OpenMIM e MMCV na versão necessária
RUN conda run -n plantseg_env pip install -U openmim && \
    conda run -n plantseg_env mim install mmengine && \
    conda run -n plantseg_env mim install "mmcv==2.1.0"

# Defina o diretório de trabalho
WORKDIR /app

# Clone o repositório PlantSeg
RUN git clone https://github.com/tqwei05/PlantSeg.git .

# Copie o dataset local para o contêiner
COPY plantseg /app/data/temp_plantseg/

# Ajuste a estrutura do dataset e renomeie para `plantseg115`
RUN if [ -d "/app/data/temp_plantseg/plantseg" ]; then \
        mkdir -p /app/data/plantseg && \
        mv /app/data/temp_plantseg/plantseg/* /app/data/plantseg/ && \
        rmdir /app/data/temp_plantseg/plantseg; \
    fi && \
    mv /app/data/plantseg /app/data/plantseg115

# Copie o arquivo requirements.txt
COPY requirements.txt .

# Instale as dependências do projeto
RUN conda run -n plantseg_env pip install -r requirements.txt

# Configure o shell para o uso do Conda
SHELL ["/bin/bash", "-c"]

# Defina o comando padrão ao iniciar o contêiner
CMD ["bash"]