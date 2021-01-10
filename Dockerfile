FROM alpine:3

RUN apk add --no-cache \
      aws-cli \
      bash \
      gnupg \
      zip

WORKDIR /app
ADD backup.sh \
    docker-entrypoint.sh \
    ./

ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
