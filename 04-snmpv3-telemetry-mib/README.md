# SNMPv3 Telemetry Pipeline, Custom Agent Extension & SMIv2 MIB

Setup for monitoring a Debian server using Net-SNMP v3 (`authPriv`), a custom Python extension script, proactive Trap/Inform rules, and a Telegraf -> InfluxDB -> Grafana collection pipeline.

## Components

- **SNMPv3 Security (`configs/snmpd.conf`):** Configured with a custom `engineID` (`0x8000000001020304`) and `SHA` + `AES` (`authPriv`).
- **Custom Python Metrics (`scripts/monitor.py`):** Exposes active SSH session count (`who | grep -c pts`), 1-minute load average (`os.getloadavg()`), and available kernel entropy (`/proc/sys/kernel/random/entropy_avail`) via the `extend` directive (`.1.3.6.1.4.1.8072.1.3.2`).
- **Proactive Traps & Informs:** Sends a trap (`Alerta_CPU_Alto`) when user CPU exceeds 80% (`.1.3.6.1.4.1.2021.11.9.0`) and an inform message (`Alerta_Disco_Cheio`) when free space on `/` drops below 1GB (`dskErrorFlag != 0`).
- **SMIv2 Custom MIB (`mibs/LAB-ENVIRONMENT-MIB.txt`):** Defines a custom `sensorTable` indexed by `nodeID` with range-checked `Integer32` objects (`temperature`, `humidity`), `Gauge32` (`batteryLevel`), `TimeTicks` (`lastContact`), and `batteryLowNotification`.
