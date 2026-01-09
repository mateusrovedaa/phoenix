# Guia de Upgrade do Phoenix

Documentação técnica detalhada para manutenção das customizações.

---

## 📁 Arquivos Customizados

### Arquivos Novos

| Arquivo | Destino | Descrição |
|---------|---------|-----------|
| `classification_metrics.py` | `src/phoenix/server/api/dataloaders/` | DataLoader para métricas de classificação |
| `ClassificationMetrics.py` | `src/phoenix/server/api/types/` | Tipo GraphQL para Classification Report |
| `ClassificationReportTooltip.tsx` | `app/src/components/experiment/` | Componente React do tooltip |
| `compose.yaml` | `/` | Docker Compose configurado |

### Arquivos Modificados (Via Patches)

| Arquivo | Modificações |
|---------|--------------|
| `Experiment.py` | Campos `latencyMsStdev`, `classificationMetric`, `classificationReport` |
| `schema.graphql` | Tipos `ClassificationReport`, `PerClassMetrics`, `ClassMetrics` |
| `ExperimentsTable.tsx` | Colunas de métricas, toggle Show Evaluators, sorting, resizing |
| `DatasetPage.tsx` | Switch "Show Evaluators" |
| `context.py` | Registro do `ClassificationMetricsDataLoader` |
| `app.py` | Instanciação do dataloader |
| `dataloaders/__init__.py` | Import e cache |
| `experiment/index.tsx` | Export do `ClassificationReportTooltip` |
| `numberFormatUtils.ts` | Rounding fix para valores < 1 |

---

## 🛠️ Resolução de Conflitos

### Quando um patch falha:

1. **Identifique o arquivo afetado** olhando o patch:
   ```bash
   head -20 patches/0005-xxx.patch
   ```

2. **Compare as versões:**
   - Veja o que o patch tenta modificar
   - Compare com o arquivo atual na nova versão
   - Identifique linhas movidas ou renomeadas

3. **Aplique manualmente** as mudanças usando:
   - Editor de texto
   - IA para assistência
   - `git apply --3way --reject` para ver `.rej` files

### Arquivos mais propensos a conflitos:

- `ExperimentsTable.tsx` - arquivo grande e frequentemente atualizado
- `schema.graphql` - estrutura pode mudar entre versões
- `Experiment.py` - resolvers podem ser reorganizados

---

## 🧪 Validação Pós-Upgrade

### Checklist de testes:

- [ ] `docker compose build` compila sem erros
- [ ] Frontend carrega sem erros no console
- [ ] Página de Experiments exibe todas as colunas
- [ ] Toggle "Show Evaluators" funciona
- [ ] Colunas de métricas (F1, Precision, etc.) mostram valores
- [ ] Classification Report tooltip aparece ao passar mouse
- [ ] Sorting de colunas funciona
- [ ] Resizing de colunas funciona
