# Ambiente sem docker

Alternativamente ao docker, segue esse passo a passo para configurar um ambiente completo para o treinamento de modelos de segmentação de imagens utilizando o PlantSeg e o MMSegmentation.

---

## Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas em sua máquina:

- Bash (para a execução do script `.sh`)
- [Make](https://www.gnu.org/software/make/)

---

## Configuração Inicial

Clone este repositório em sua máquina local:

```bash
git clone https://github.com/Matheusbrakes/AMNS.git
cd AMNS/ambiente_virtual
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


###  Usando o Script .sh


#### 1. Torne o script executável:


```
chmod +x setup_environment.sh
```

#### 2. Execute o script para configurar o ambiente:

```
./setup_environment.sh
```

### 3. Execute o make

```bash
make build
```

### 4. Executar o Treinamento

Para treinar o modelo configurado:

```bash
make train
```

Certifique-se de:
- O dataset foi copiado corretamente para o contêiner.
- O arquivo de configuração do modelo (`CONFIG_FILE`) está correto.

### 5. Avaliar Métricas do Modelo Treinado

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
