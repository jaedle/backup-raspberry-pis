FROM alpine:3

RUN apk add --no-cache \
      aws-cli \
      bash \
      gnupg
