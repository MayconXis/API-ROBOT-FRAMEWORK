FROM python:3.11-slim
WORKDIR /app
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN mkdir -p reports/{html,xml,logs,screenshots}

CMD ["robot", "--outputdir", "reports/html", "--output", "reports/xml/output.xml", "--log", "reports/logs/log.html", "tests/"]