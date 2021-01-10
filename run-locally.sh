#!/usr/bin/env bash

set -eu -o pipefail

build() {
  docker image build -t jaedle/backup-raspberry-pis:local .
}

start() {
  docker container run \
    --rm \
    -it \
    --name backup-raspberry-pi \
    --mount type=bind,source="$PWD/.config.rc",target=/config.rc,readonly \
    --mount type=bind,source="$PWD/test-fixture/",target=/to-backup,readonly \
    jaedle/backup-raspberry-pis:local
}


build
start
