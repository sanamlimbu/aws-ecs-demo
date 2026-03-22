# Build stage
ARG GO_VERSION=1.26.1
FROM golang:${GO_VERSION}-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /app/bin/serviceb ./main.go

# Final stage
FROM alpine:latest

ARG SERVICE_NAME=serviceb
RUN adduser -D ${SERVICE_NAME}
USER ${SERVICE_NAME}

WORKDIR /app

COPY --from=builder /app/bin/serviceb /app/serviceb

EXPOSE 8080

ENTRYPOINT ["/app/serviceb"]