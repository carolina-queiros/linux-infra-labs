#!/bin/bash
# Configuracao do Array RAID 6 (mdadm) + LVM2
# Os 6 discos iniciais de 100MB sao identificados como /dev/sdb a /dev/sdg
# Os 2 discos adicionais de 200MB sao /dev/sdh e /dev/sdi

set -e

# a) Criacao do Array RAID 6 (4 ativos e 2 hot-spare)
mdadm --create /dev/md0 --level=6 --raid-devices=4 --spare-devices=2 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg

# b) Confirmacao do Layout
mdadm --detail /dev/md0
cat /proc/mdstat

# d) Criacao de Volumes Fisicos (PV)
pvcreate /dev/md0
pvcreate /dev/sdh /dev/sdi

# e) Criacao do Grupo de Volumes (VG)
vgcreate vg0 /dev/md0 /dev/sdh

# f) Criacao de LV Linear com Informacao do VG
lvcreate -L 200M -n lv0 vg0
vgdisplay vg0

# g) Formatacao e Montagem Permanente
mkfs.ext4 /dev/vg0/lv0
mkdir -p /mnt/vg0-lv0
mount /dev/vg0/lv0 /mnt/vg0-lv0
# Adicionar ao /etc/fstab:
# /dev/mapper/vg0-lv0 /mnt/vg0-lv0 ext4 defaults 0 2

# h) Adicao do Segundo Disco ao VG
vgextend vg0 /dev/sdi
vgdisplay vg0

# i) Criacao de LV Espelhado (Mirrored - consome 2x52MB)
lvcreate -m 1 -L 52M -n lv1 vg0
vgdisplay vg0

# j) Criacao de LV Segmentado (Striped - 2 stripes)
lvcreate -i 2 -L 190M -n lv2 vg0

# k) Aumento de tamanho e Filesystem (+60MB)
lvextend -L +60M --resizefs /dev/vg0/lv0

# Mapeamento de Physical Extents (PE)
pvdisplay -m /dev/md0
pvdisplay -m /dev/sdh
pvdisplay -m /dev/sdi
