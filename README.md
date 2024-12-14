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
cd AMNS
```

Preencha os seguintes campos no `Makefile` antes de rodar os comandos:

1. **`DATASET_PATH`:** 
   - O caminho para o diretório onde está localizado o dataset para treinamento.
   - Exemplo: `/home/user/data/`.

2. **`OUTPUT_PATH`:** 
   - O diretório onde os resultados e métricas serão salvos.
   - Exemplo: `/home/user/output/`.

3. **`LOG_DIR`:**
   - O diretório onde os logs e checkpoints serão armazenados.
   - Exemplo: `/home/user/logs/`.

4. **`CONFIG_FILE`:**
   - O caminho do arquivo de configuração do modelo que você deseja usar para treinar.
   - Exemplo: `configs/segnext/segnext_mscan-t_1xb16-adamw-40k_plantseg115-512x512.py`.
---

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
- O dataset estar no caminho correto definido por `DATASET_PATH`.
- O arquivo de configuração do modelo (`CONFIG_FILE`) estar correto.

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
