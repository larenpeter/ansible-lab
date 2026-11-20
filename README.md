# ansible-lab

Ansible playbook and bootstrap script that rebuild a Docker-based homelab VM
(Ubuntu 26.04 LTS on VirtualBox).

![Homepage dashboard](docs/homepage.png?v=2)

## What it deploys
- **Monitoring & System Stats:**
  - Homepage dashboard, with Prometheus-backed widgets, live ping checks, and container status
  - Prometheus and deco-rate (metrics for a TP-Link Deco X50 mesh; the deco-rate source is pinned to a reviewed commit and built locally)
  - Beszel and Beszel Agent (lightweight host and Docker resource monitoring)
- **Media & Voice:**
  - MiniDLNA (DLNA music server for a WiiM streamer and a Samsung TV)
  - Asterisk (VoIP PBX with PJSIP extensions 6001/6002, *43 Echo, 7000 Speaking Clock, and 9700 Voicemail)
  - Navidrome (music streaming, commented out in `site.yml`, uncomment to run)
- **Operations & Utilities:**
  - Dozzle (live container logs, bound to localhost)
  - Watchtower (checks for newer images, monitor only)
  - IT-Tools (offline developer and network utilities)
  - LibreSpeed (local Wi-Fi and LAN speedtest)
  - CyberChef (data encoding, decoding, and log analysis)
  - BentoPDF (lightweight in-browser PDF toolkit)

## Design notes
- One reusable role, `roles/docker_app`, deploys any app from
  `files/<app>-compose.yml`. Adding an app is one line in the `site.yml` loop.
- No secrets in the repo. Real credentials live outside it and are mounted
  read-only into the containers.
- Containers that need no outside access publish no ports, bind to `127.0.0.1`,
  and mount shared media folders read-only (`:ro`).

## What you provide yourself (not in the repo)
- `~/secrets/deco-rate.yaml`: the deco-rate config with your TP-Link login
- `~/secrets/beszel.env`: the Beszel agent SSH public key (`KEY="ssh-ed25519 ..."`)
- `~/secrets/homepage.env`: the Beszel login credentials for Homepage (`HOMEPAGE_VAR_BESZEL_USER`, `HOMEPAGE_VAR_BESZEL_PASS`)
- `asterisk/config/pjsip.conf` & `voicemail.conf`: copy `.example` files and set real passwords/PINs
- VirtualBox shared folders `sf_Music`, `sf_Songs`, `sf_Songs1` for MiniDLNA,
  or edit the paths in `files/minidlna-compose.yml`

## Usage
    git clone https://github.com/larenpeter/ansible-lab.git
    cd ansible-lab
    ansible-galaxy collection install -r requirements.yml
    bash scripts/bootstrap.sh

`bootstrap.sh` installs Ansible and Docker if missing, then runs the playbook.
To run the playbook directly: `ansible-playbook site.yml -K`

## Layout
- `site.yml`: main playbook (installs Docker, deploys the stacks)
- `requirements.yml`: Ansible collections needed (community.docker)
- `files/`: Docker Compose files for each app
- `homepage/config/`, `monitoring/config/`, `asterisk/config/`: app settings
- `roles/docker_app/`: role that deploys one Docker Compose app
- `scripts/bootstrap.sh`: prepares a fresh machine and runs the playbook
- `deployed-apps/`: generated on the target machine, not tracked in Git
