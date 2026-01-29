# Використовуємо офіційний легкий образ Python
FROM python:3.11-slim

# Встановлюємо змінні оточення для коректної роботи Python в Docker
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Робоча директорія всередині контейнера
WORKDIR /app

# Встановлюємо залежності для роботи з Postgres (необхідні для збірки)
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# Копіюємо та встановлюємо залежності Python
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо весь код проекту
COPY . /app/

# Відкриваємо порт
EXPOSE 8000

# Запуск сервера через Gunicorn (рекомендовано для проду)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]