# 📊 Diretorio de Relatorios

Este diretorio armazena todos os relatorios e artefatos gerados durante a execucao dos testes.

## 📁 Estrutura de Pastas

```
reports/
├── html/          # Relatorios HTML (report.html, log.html)
├── xml/           # Arquivos XML (output.xml)
├── logs/          # Logs detalhados de execucao
├── screenshots/   # Capturas de tela (se configuradas)
└── README.md      # Este arquivo
```

## 📋 Tipos de Arquivos Gerados

### Relatorios HTML
- **report.html**: Relatorio visual com estatisticas dos testes
- **log.html**: Log detalhado da execucao com timestamps

### Saida XML
- **output.xml**: Dados estruturados para integracao CI/CD

### Logs
- **robot-*.log**: Logs especificos por execucao
- **debug.log**: Informacoes de debug (se habilitado)

### Screenshots
- Capturas automaticas em caso de falhas
- Screenshots manuais durante a execucao

## 🔄 Limpeza Automatica

Os arquivos sao automaticamente organizados por:
- Data de execucao
- Tipo de teste (JSON, API, Dinamico)
- Status (Passou/Falhou)

## 📈 Visualizacao

Abra `html/report.html` no navegador para visualizar os resultados dos testes.