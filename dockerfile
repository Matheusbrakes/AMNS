# Use uma imagem base oficial do Python 3.11
FROM python:3.11-slim

# Instale dependências do sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instale o Miniconda
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Adicione o conda ao PATH
ENV PATH=/opt/conda/bin:$PATH

# Crie e ative o ambiente conda
RUN conda create --name openmmlab python=3.11 -y && \
    echo "conda activate openmmlab" >> ~/.bashrc

# Instale o PyTorch e torchvision
RUN conda install -n openmmlab pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch -y

# Instale o MMCV e MMEngine usando MIM
RUN conda install -n openmmlab -c conda-forge openmim && \
    mim install -n openmmlab mmengine && \
    mim install -n openmmlab "mmcv>=2.0.0"

# Clone o repositório do PlantSeg
WORKDIR /app
RUN git clone https://github.com/tqwei05/PlantSeg.git ./

# Instale as dependências do PlantSeg
RUN conda run -n openmmlab pip install -r requirements.txt

# Instale o PlantSeg
RUN conda run -n openmmlab python setup.py install

# Defina o comando padrão ao iniciar o contêiner
CMD ["bash"]
