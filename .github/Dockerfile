FROM python:3.11-slim

WORKDIR /app

# Instalar dependencias do sistema
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copiar e instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar codigo do projeto
COPY . .

# Criar estrutura de diretorios
RUN mkdir -p reports/{html,xml,logs,screenshots}

# Comando padrao para execucao
CMD ["robot", "--outputdir", "reports/html", "--output", "reports/xml/output.xml", "--log", "reports/logs/log.html", "tests/"]