# Phoenix Customizations

Customizações do Phoenix.

## 🚀 Como Atualizar

```bash
./upgrade.sh main --force
```

Isso irá:
1. Clonar a versão mais recente do Phoenix
2. Copiar os arquivos customizados 
3. Aplicar os patches de modificação
4. Gerar o diretório `phoenix-upgraded/` pronto para build

### Opções

| Comando | Descrição |
|---------|-----------|
| `./upgrade.sh main` | Atualiza para branch main |
| `./upgrade.sh v4.0.0` | Atualiza para tag específica |
| `./upgrade.sh main --force` | Sobrescreve upgrade anterior |

## 📁 Estrutura

```
├── upgrade.sh
├── UPGRADE.md
├── files/
│   ├── classification_metrics.py
│   ├── ClassificationMetrics.py
│   ├── ClassificationReportTooltip.tsx
│   └── compose.yaml
└── patches/
    └── *.patch
```

## 📋 Customizações Incluídas

| Feature | Descrição |
|---------|-----------|
| **Classification Metrics** | F1, Precision, Recall, Support nas métricas |
| **Classification Report** | Tooltip com detalhes por classe |
| **Latency Stdev** | Desvio padrão de latência |
| **Show Evaluators Toggle** | Botão para mostrar/ocultar colunas de avaliadores |
| **Sorting & Resizing** | Ordenação e redimensionamento de colunas |
| **Database Config** | Configuração para PostgreSQL com roles |

## 🔧 Em Caso de Conflitos

Se patches falharem:

1. Veja qual patch falhou no output
2. Abra o arquivo `.patch` correspondente
3. Compare com o arquivo atual na nova versão
4. Aplique as mudanças manualmente

> 💡 **Dica:** Use uma IA para ajudar a adaptar o patch.

## 📝 Próximos Passos Após Upgrade

```bash
cd phoenix-upgraded
docker compose build
docker compose up -d
# Teste em http://localhost:6006
```
