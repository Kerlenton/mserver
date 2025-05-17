# Mail Service (mservice)

Cервис для отправки и получения сообщений между пользователями.  
Использует Gin, GORM (PostgreSQL), RabbitMQ и Redis (опционально).

## Технологии
- Go 1.24
- Gin
- GORM + PostgreSQL
- RabbitMQ
- Redis (для кэширования и rate-limit)

## Требования
- Docker ≥ 20.10
- Docker Compose ≥ 1.29
- Файл `.env` с переменными окружения

## Настройка
1. Склонировать репозиторий и перейти в папку:
   ```bash
   git clone <URL_репозитория>
   cd mservice
   ```
2. Скопировать шаблон и задать свои значения:
   ```bash
   cp .env .env.local
   # отредактировать .env.local
   ```

## Запуск через Docker Compose
```bash
docker-compose up -d
```
Сервисы:
- Postgres 15 на порту 5432
- Redis 7 на порту 6379
- RabbitMQ с UI на 15672
- Ваш сервис на порту из `PORT`

## Ручной запуск в Docker
1. Собрать образ:
   ```bash
   docker build -t mservice .
   ```
2. Запустить контейнер:
   ```bash
   docker run -d \
     --name mservice \
     --env-file .env.local \
     -p ${PORT}:${PORT} \
     mservice
   ```

## API Endpoints
Все пути начинаются с `/api/v1`.

Auth:
- `POST /auth/register` — регистрация (email, password)
- `POST /auth/login`    — вход (email, password)

Защищённые (JWT в `Authorization: Bearer <token>`):
- `GET  /users/me`           — информация о текущем пользователе
- `POST /messages/send`      — отправить сообщение (`recipient_email`, `subject`, `body`)
- `GET  /messages/inbox`     — входящие
- `GET  /messages/sent`      — отправленные
