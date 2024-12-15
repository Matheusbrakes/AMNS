# PlantSeg Training Environment

Este repositório configura um ambiente completo para o treinamento de modelos de segmentação de imagens utilizando o PlantSeg e o MMSegmentation.

---

## Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas em sua máquina:

- [Docker](https://docs.docker.com/get-docker/)
- [Make](https://www.gnu.org/software/make/)

---

## Configuração Inicial

Clone este repositório em sua máquina local:

```bash
git clone https://github.com/Matheusbrakes/AMNS.git
cd AMNS/docker
```

Preencha os seguintes campos no `Makefile` antes de rodar os comandos:

1. **`OUTPUT_PATH`:** 
   - Diretório para salvar os resultados do treinamento.
   - Exemplo: `/home/user/data/`.

2. **`CHECKPOINT_DIR`:** 
   - O diretório onde os checkpoints do modelo serão salvos.
   - Exemplo: `/home/user/output/`.

3. **`LOG_DIR`:**
   - O diretório onde os logs e checkpoints serão armazenados.
   - Exemplo: `/home/user/logs/`.

4. **`CONFIG_FILE`:**
   - O caminho do arquivo de configuração do modelo que você deseja usar para treinar.
   - Exemplo: `configs/segnext/segnext_mscan-t_1xb16-adamw-40k_plantseg115-512x512.py`.
---

### Configuração do Dataset Local

Por padrão, o dataset é copiado para o contêiner a partir do caminho local `plantsegv2/plantsegv2`. O processo é configurado no **Dockerfile**:

```dockerfile
# Copie o dataset local para o contêiner
COPY plantsegv2 /app/data/temp_plantseg/

# Ajuste a estrutura do dataset e renomeie para `plantseg115`
RUN if [ -d "/app/data/temp_plantseg/plantsegv2" ]; then \
        mkdir -p /app/data/plantsegv2 && \
        mv /app/data/temp_plantseg/plantsegv2/* /app/data/plantsegv2/ && \
        rmdir /app/data/temp_plantseg/plantsegv2; \
    fi && \
    mv /app/data/plantsegv2 /app/data/plantseg115
```

##### Como trocar o caminho do dataset
Se você deseja treinar com um dataset localizado em outro caminho, por exemplo, `datasets/my_dataset`, será necessário realizar as seguintes alterações:

1. **Ajuste no Dockerfile**  
   Altere a linha `COPY` para refletir o novo caminho do dataset.  
   Exemplo:
   ```dockerfile
   COPY datasets/my_dataset /app/data/temp_plantseg/
   ```

2. **Ajuste no Makefile**  
   O comando docker run também precisa ser atualizado para mapear corretamente o novo caminho local para o contêiner. Localize a opção -v no alvo train e ajuste o caminho.
   Exemplo, no caso do dataset estar em /home/user/datasets/experiment1:
   ```dockerfile
   -v /home/user/datasets/experiment1:/app/data/plantseg115 \
   ```

3. **Recompile a Imagem Docker*  
   Após ajustar o Dockerfile, reconstrua a imagem para refletir as alterações:
   ```bash
   make build
   ```

## Como Usar

### 1. Construir a Imagem Docker

Para construir a imagem Docker que configura o ambiente:

```bash
make build
```

### 2. Executar o Treinamento

Para treinar o modelo configurado:

```bash
make train
```

Certifique-se de:
- O dataset foi copiado corretamente para o contêiner.
- O arquivo de configuração do modelo (`CONFIG_FILE`) está correto.

### 3. Avaliar Métricas do Modelo Treinado

Para calcular as métricas (ex.: mIoU) do modelo treinado:

```bash
make evaluate
```

Os resultados das métricas serão exibidos no terminal e salvos no diretório configurado em `OUTPUT_PATH`.

### 4. Executar o Container de Forma Interativa

Caso você queira acessar o container manualmente para depuração ou outras tarefas:

```bash
make run
```

### 5. Limpar Contêineres

Para remover apenas os contêineres criados por esta imagem:

```bash
make clean
```

---

## Referências

- [PlantSeg GitHub](https://github.com/tqwei05/PlantSeg)
- [MMSegmentation Documentation](https://mmsegmentation.readthedocs.io/en/latest/)
