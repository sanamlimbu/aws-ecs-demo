# Build stage
ARG GO_VERSION=1.26.1
FROM golang:${GO_VERSION}-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /app/bin/servicea ./main.go

# Final stage
FROM alpine:latest

ARG SERVICE_NAME=servicea
RUN adduser -D ${SERVICE_NAME}
USER ${SERVICE_NAME}

WORKDIR /app

COPY --from=builder /app/bin/servicea /app/servicea

EXPOSE 8080

ENTRYPOINT ["/app/servicea"]