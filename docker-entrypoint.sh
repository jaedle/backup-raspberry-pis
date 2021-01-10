#!/usr/bin/env bash

set -eu -o pipefail

read_configuration() {
  source /config.rc
}

set_crontab() {
  rm -rf /etc/cron/
  mkdir /etc/cron/

  echo "$CRON_EXPRESSION /app/backup.sh >> /dev/stdout 2>&1
  # crontab requires an empty line at the end of the file" > /etc/cron/crontab

  crontab /etc/cron/crontab
}

start_cron() {
  crond -f
}

read_configuration
set_crontab
start_cron
