ARG ARCH=
FROM ${ARCH}alpine:3

RUN apk add --no-cache \
      aws-cli \
      bash
