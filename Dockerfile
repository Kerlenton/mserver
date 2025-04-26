# ------------------ builder stage ------------------
    FROM golang:1.24-alpine AS builder

    WORKDIR /src
    COPY go.mod go.sum ./
    RUN go mod download
    
    COPY . .
    # Сборка статического бинаря
    RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o mail-service
    
    # ------------------ final stage ------------------
    FROM scratch
    
    WORKDIR /app
    # Копируем бинарь
    COPY --from=builder /src/mail-service .
    # Копируем папку с миграциями
    COPY --from=builder /src/db/migrations ./db/migrations
    
    # Запускаем от непривилегированного юзера
    USER 65532:65532
    
    # Точка входа
    ENTRYPOINT ["./mail-service"]
    # Открываем порт
    EXPOSE 8080
    