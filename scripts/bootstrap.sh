#!/bin/bash
set -e
cd "$(dirname "$0")/.."

echo "[+] Starting Homelab Infrastructure Bootstrap..."

# 1. Ansible
if ! command -v ansible &> /dev/null; then
    echo "[+] Installing Ansible..."
    sudo apt update && sudo apt install -y ansible
fi

# 2. Docker
if ! command -v docker &> /dev/null; then
    echo "[+] Installing Docker..."
    sudo apt update && sudo apt install -y docker.io docker-compose-v2
    sudo usermod -aG docker "$USER"
fi

# 3. Run the playbook (sg uses the docker group without needing a re-login)
echo "[+] Executing Ansible deployment playbook..."
sg docker -c "ansible-playbook -i inventory.ini site.yml"

echo "[+] Homelab bootstrap complete!"
