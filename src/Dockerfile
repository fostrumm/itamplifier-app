# Gebruik een lichte Python-versie
FROM python:3.9-slim

# Map instellen in de container
WORKDIR /app

# Eerst de benodigdheden installeren (voor snellere builds)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# De rest van de code kopiëren
COPY . .

# De poort openzetten voor Azure
EXPOSE 5000

# De app echt opstarten
CMD ["python", "app.py"]