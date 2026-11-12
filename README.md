# Linux Systems & Network Infrastructure Labs

Configurations, scripts, and lab documentation covering Linux system administration, RAID/LVM/ZFS storage management, high-availability network services, and SNMPv3 telemetry.

All labs were built and tested on macOS (Apple Silicon ARM64) using VMware Fusion, UTM (QEMU), and Proxmox VE with Debian Linux and Windows VMs.

## Modules

- **[01-virtualization-ssh](./01-virtualization-ssh)** — Base Debian VM provisioning, OpenSSH Ed25519 key authentication, `sshd` hardening, and nested virtualization network isolation with Proxmox VE, MariaDB, and Docker.
- **[02-storage-raid-lvm-zfs](./02-storage-raid-lvm-zfs)** — Software RAID 6 (`mdadm`) with hot-spares and fault simulation, LVM2 volume management (linear, mirrored, striped, online resizing), and OpenZFS `RAIDZ1` pools with `lz4` compression and mirrored LOG.
- **[03-ha-dns-dhcp](./03-ha-dns-dhcp)** — High-availability BIND9 DNS (Master/Slave zone transfers via AXFR/IXFR) and ISC DHCP Failover with Dynamic DNS (DDNS) updates signed via TSIG keys.
- **[04-snmpv3-telemetry-mib](./04-snmpv3-telemetry-mib)** — Net-SNMP v3 (`authPriv` SHA/AES) setup, custom Python agent extension (SSH sessions, load average, kernel entropy), proactive CPU/Disk traps, custom SMIv2 MIB definition, and Telegraf + InfluxDB + Grafana integration.
- **[05-sme-network-integration](./05-sme-network-integration)** — Small/Medium Enterprise (SME) network architecture integrating a pfSense + OpenVPN gateway, Samba 4 Active Directory Domain Controller, hardened NFSv4 exports (`root_squash`, `nosuid`), and automated daily `rsync` backups via `cron`.
