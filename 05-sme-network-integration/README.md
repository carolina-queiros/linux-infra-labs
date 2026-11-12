# SME Network Architecture: Samba 4 AD, NFSv4 Storage & pfSense Gateway

Final integration lab combining perimeter routing/VPN (pfSense), centralized authentication (Active Directory / Samba 4), RAID 6 + NFSv4 storage, and automated `rsync` backups on an isolated `192.168.100.0/24` subnet.

## Network Addressing

- `gw` (`192.168.100.1` - Static) — pfSense v2.5 Gateway & OpenVPN Server
- `store` (`192.168.100.2` - Static) — Debian 11 Storage Server (RAID 6, NFSv4, ISC DHCP, SNMPv3/MRTG)
- `dc` (`192.168.100.3` - Static) — Domain Controller (Samba 4 AD & DNS, SMB Shares, SNMPv3/MRTG)
- `ws1` (`192.168.100.x` - DHCP) — Windows 11 Pro (ARM64) Workstation joined to the domain

## Implementation Details

- **NFSv4 Security (`configs/exports`):** Enforces `root_squash` (mapping client UID 0 to `nobody`) and `nosuid` to prevent privilege escalation via SUID binaries on shared directories. Applied via `sudo exportfs -ra`.
- **Auto-Mount on Boot (`configs/fstab.client`):** Uses `_netdev` in `/etc/fstab` to ensure the network stack is active before mounting `/mnt/backup`.
- **Automated Backups (`scripts/daily_backup_cron.sh`):** Configures a `@daily` cron task on the Domain Controller to synchronize `/etc` and `/home` to the remote NFS storage array using `rsync -a --delete`.
- **Active Directory & Roaming Profiles:** Configured domain authentication, DNS `SRV` records (`_ldap._tcp` and `_kerberos._tcp`), and roaming user profiles (`\\dc\profiles\%USERNAME%`).
