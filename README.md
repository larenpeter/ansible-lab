# ansible-lab

Rebuild my Ubuntu homelab VM with one command.

## What it deploys
- Uptime Kuma (monitoring)
- Homepage (dashboard)
- Navidrome (music streaming)

## Requirements
- Ubuntu with Ansible installed
- A user with sudo rights

On Ubuntu releases that ship `sudo-rs`, Ansible can't answer the sudo
password prompt. For a lab VM, allow passwordless sudo:

    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER
    sudo chmod 440 /etc/sudoers.d/$USER

## Usage
    git clone https://github.com/larenpeter/ansible-lab.git
    cd ansible-lab
    ansible-galaxy collection install -r requirements.yml
    ansible-playbook site.yml

Running the playbook a second time should report `changed=0`.

## Layout
- `site.yml`: main playbook (installs Docker, deploys the stacks)
- `requirements.yml`: Ansible collections needed (community.docker)
- `files/`: Docker Compose files for each app
- `homepage/config/`: Homepage dashboard settings
- `deployed-apps/`: generated on the target machine, not tracked in Gitrebuild my Ubuntu VM with Docker and Navidrome in one command
- `roles/docker_app/`: reusable role that deploys one Docker Compose app
