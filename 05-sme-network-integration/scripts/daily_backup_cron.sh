#!/bin/bash
# Configuracao de backup diario (@daily) de /etc e /home via rsync para o volume NFS em /mnt/backup

mkdir -p /mnt/backup/etc /mnt/backup/home

cat << "CRON" > /etc/cron.d/sme-daily-backup
@daily root rsync -a --delete /etc/ /mnt/backup/etc/ && rsync -a --delete /home/ /mnt/backup/home/
CRON

chmod 644 /etc/cron.d/sme-daily-backup
systemctl restart cron
