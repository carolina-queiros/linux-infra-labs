#!/bin/bash
# Configuracao de OpenZFS: Pool RAIDZ1 (3 discos) + Mirrored LOG (2 discos)

set -e

apt-get update && apt-get install -y zfsutils-linux

# Criar zpool userpool em RAIDZ1 com 3 discos e log espelhado no 4o e 5o disco
zpool create userpool raidz1 /dev/sdb /dev/sdc /dev/sdd log mirror /dev/sde /dev/sdf

# Criar volume ZFS comprimido (lz4)
zfs create -o compression=lz4 userpool/users

zpool status userpool
zfs list
