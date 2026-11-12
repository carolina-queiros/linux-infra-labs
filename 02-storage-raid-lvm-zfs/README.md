# Linux Storage Management: RAID 6 (mdadm), LVM2 & OpenZFS

Scripts and commands used to configure software RAID 6 with hot-spares, LVM2 logical volumes, and OpenZFS pools on Debian.

## 1. RAID 6 Array & LVM2 (`scripts/setup_raid6_lvm.sh`)

Configures `/dev/md0` using 6 virtual disks (4 active + 2 hot-spare) and initializes LVM2 across `/dev/md0`, `/dev/sdh`, and `/dev/sdi`:

- **Linear LV (`lv0`):** 200MB formatted with `ext4`, mounted at `/mnt/vg0-lv0`, and later extended by +60MB online (`lvextend -L +60M --resizefs`).
- **Mirrored LV (`lv1`):** 52MB with 1 mirror (`-m 1`), consuming 2x52MB from `vg0`.
- **Striped LV (`lv2`):** 190MB across 2 stripes (`-i 2`).
- **Fault Simulation:** Tested hot-spare rebuild by failing `/dev/sdb` (`mdadm /dev/md0 --fail /dev/sdb && mdadm /dev/md0 --remove /dev/sdb`).
- **PE Auditing:** Used `pvdisplay -m` on `/dev/md0`, `/dev/sdh`, and `/dev/sdi` to inspect Physical Extent allocation per Logical Volume.

## 2. OpenZFS Pool (`scripts/setup_zfs_pool.sh`)

Sets up `userpool` in `RAIDZ1` (3 disks) with a mirrored Separate Intent Log (`log mirror` on the 4th and 5th disks) and an `lz4`-compressed dataset (`userpool/users`).
