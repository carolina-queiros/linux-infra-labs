# Redundant DNS (BIND9) & ISC DHCP Failover with DDNS

Configuration files for a primary/secondary BIND9 DNS setup and ISC DHCP failover with dynamic DNS updates (TSIG) on a `192.168.64.0/24` network.

## Network Addressing

- `dns1.linux.local` (`192.168.64.200`) — Primary (Master) BIND9 Server
- `dns2.linux.local` (`192.168.64.201`) — Secondary (Slave) BIND9 Server
- `dhcp1.linux.local` (`192.168.64.100`) — Primary ISC DHCP Server
- `dhcp2.linux.local` (`192.168.64.101`) — Failover Peer ISC DHCP Server
- `wstation.linux.local` (`192.168.64.90`) — Ubuntu Desktop Client (MAC Reservation `72:62:96:38:43:23`)

## Architecture Details

- **Zone Transfers (AXFR / IXFR):** `dns1` restricts zone transfers to `192.168.64.201` (`allow-transfer`) and sends `NOTIFY` messages on SOA serial updates.
- **Dynamic DNS (DDNS):** ISC DHCP updates forward (`A`) and reverse (`PTR`) records in BIND9 signed with a shared `hmac-sha256` TSIG key (`ddns-key`).
- **Failover Validation:** Tested by stopping `bind9` on `dns1` and verifying continued name resolution from the client workstation via `dns2` using `getent hosts` and `host`.
