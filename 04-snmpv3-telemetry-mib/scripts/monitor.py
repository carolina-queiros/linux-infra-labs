#!/usr/bin/env python3
import os
import subprocess

# 1. Contar sessoes SSH (conta as linhas com pts no comando who)
try:
    ssh_output = subprocess.getoutput("who | grep -c pts")
    ssh_sessions = ssh_output if ssh_output.strip() else "0"
except:
    ssh_sessions = "0"

# 2. Load Average (1 minuto)
try:
    load_1m, load_5m, load_15m = os.getloadavg()
except:
    load_1m = 0.0

# 3. Entropia disponivel
try:
    with open("/proc/sys/kernel/random/entropy_avail", "r") as f:
        entropy = f.read().strip()
except:
    entropy = "0"

# Imprimir valores (um por linha)
print(ssh_sessions)
print(load_1m)
print(entropy)
