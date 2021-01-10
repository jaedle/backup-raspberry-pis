#!/usr/bin/env bash

set -eu -o pipefail

TO_BACKUP="/to-backup"
BACKUP_FOLDER='/backups'
BACKUP="$BACKUP_FOLDER/backup.zip"
BACKUP_ENCRYPTED="$BACKUP_FOLDER/backup.zip.enc"

log() {
  message="$1"

  echo "$(date) $message"
}

cleanup_backup_files() {
  rm -rf "$BACKUP_FOLDER"
  mkdir -p /backups
}

read_configuration() {
  source /config.rc
}

create_backup() {
  cd "$TO_BACKUP/"
  zip -q -1 -r "$BACKUP" .
  log 'created backup'
  log "$(ls -al $BACKUP)"
}

encrypt_backup() {
  echo "$ENCRYPTION_KEY" | gpg \
    --batch \
    --symmetric \
    --passphrase-fd 0 \
    --output "$BACKUP_ENCRYPTED" \
    "$BACKUP"
  log 'encrypted backup'
  log "$(ls -al $BACKUP_ENCRYPTED)"
}

delete_unencrypted_backup() {
  rm "$BACKUP"
}

upload_backup() {
  export AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY
  export AWS_DEFAULT_REGION

  aws s3 cp \
    "$BACKUP_ENCRYPTED" \
    "s3://$S3_BUCKET/$S3_KEY"
  log 'backup uploaded'
}

log '*** backup started'
cleanup_backup_files
read_configuration
create_backup
encrypt_backup
delete_unencrypted_backup
upload_backup
cleanup_backup_files
log '*** backup done'
