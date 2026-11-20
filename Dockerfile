FROM golang:1.27-alpine AS build

WORKDIR /src
COPY go.mod ./
COPY tarantula.go ./
RUN apk add --no-cache ca-certificates \
    && mkdir -p /out \
    && CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/tarantula-ng .

FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /out/tarantula-ng /tarantula-ng
USER 65532:65532
ENTRYPOINT ["/tarantula-ng"]
