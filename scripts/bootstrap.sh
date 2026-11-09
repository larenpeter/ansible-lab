#!/bin/bash
set -e

echo "[+] Starting Homelab Infrastructure Bootstrap..."

# 1. Ensure required local tools are present
if ! command -v ansible &> /dev/null; then
    echo "[+] Installing Ansible..."
    sudo apt update && sudo apt install -y ansible
fi

# 2. Run the master Ansible playbook
echo "[+] Executing Ansible deployment playbook..."
ansible-playbook -i inventory.ini site.yml

echo "[+] Homelab bootstrap complete!"
