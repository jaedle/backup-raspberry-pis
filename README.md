# Backup your raspberry pi

## Introduction

I tend to run the services on my raspberry pi inside of docker containers. This makes backups quite easy.

Assume the following setup:
`/home/someusers/docker`: contains all start scripts and mounted volumes for your container

This docker container performs the following operations on your backup:

1. create an archive of the backup folder
2. encrypt the backup with gpg with a static passphrase
3. upload the backup to a s3-bucket

## Usage

Create a configuration file for your backup and; place it somewhere safe. This examples uses `/home/some-user/.backup-rasperry-pis/.config.rc`
```sh
# cron expression for execution
CRON_EXPRESSION="0 1 * * *"

# AWS credentials
AWS_ACCESS_KEY_ID='example-access-key'       
AWS_SECRET_ACCESS_KEY='example-secret-key'
AWS_DEFAULT_REGION='eu-west-1'

# Bucket and key in bucket to upload
S3_BUCKET='an-example-bucket'
S3_KEY='example-prefix/backup.zip.enc'

# encryption key for gpg; please use a long, random passphrase
ENCRYPTION_KEY='static-encryption-key'
```

```sh
docker container run \
    --restart=always \
    --name backup-raspberry-pi \
    --mount type=bind,source=/home/some-user/.backup-rasperry-pis/.config.rc,target=/config.rc,readonly \
    --mount type=bind,source=/home/some-user/docker,target=/to-backup,readonly \
    jaedle/backup-raspberry-pis:latest-arm32v7
```

## Decrypt backup


```sh
gpg --decrypt --output backup.zip backup.zip.enc
```
