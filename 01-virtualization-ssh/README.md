# Virtualization Topologies & SSH Setup

Notes and baseline configurations for setting up isolated virtual networks, nested hypervisors (Proxmox VE), and key-based SSH access across Debian VMs.

## 1. Base Debian Template & SSH Key Authentication
Minimal Debian (no GUI) installation used as a base template before taking snapshots or full clones.

- Generate Ed25519 key pair on the host: `ssh-keygen -t ed25519`
- Copy public key to target VM: `ssh-copy-id -i ~/.ssh/id_ed25519.pub carolina@192.168.1.21`
- Apply hardened sshd config and restart service: `sudo systemctl restart ssh`

## 2. Nested Virtualization & Network Isolation (Proxmox VE)
Multi-tier isolation between a container host and a nested database VM inside Proxmox VE:

- **Hypervisor Node (`vm1` - Proxmox VE):** 2 vCPUs, 4GB RAM, nested virtualization enabled.
- **Network Segmentation:**
  - `network1.1` (NAT/Bridged): Default outbound internet access.
  - `network1.2` (Host-Only): Isolated backend network for internal services.
- **Database Node (`vm1.1` - Debian inside Proxmox):** Runs MariaDB bound strictly to `network1.2`.
- **Management Node (`vm2`):** Runs an OCI container (`phpmyadmin/phpmyadmin`) connected to `network1.2`.
