#!/usr/bin/env bash

# Docker & Arcane Helper for Proxmox LXC
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

# --- NEU: LXC FEATURE CHECK ---
msg_info "Checking LXC Features"
NESTING_CHECK=$(grep -q "overlay" /proc/filesystems && echo "OK" || echo "FAIL")
if [ "$NESTING_CHECK" == "FAIL" ]; then
  msg_warn "ACHTUNG: 'Nesting' ist nicht aktiviert!"
  msg_warn "Docker benötigt Nesting, um korrekt zu funktionieren."
  echo -e "${TAB3}Bitte in den Proxmox-Optionen des LXC unter 'Features' aktivieren."
  read -r -p "${TAB3}Trotzdem fortfahren? (y/N): " proceed
  if [[ ! ${proceed,,} =~ ^(y|yes)$ ]]; then
    msg_error "Installation abgebrochen."
    exit 1
  fi
else
  msg_ok "LXC Nesting Check bestanden."
fi
# ------------------------------

DOCKER_LATEST_VERSION=$(get_latest_github_release "moby/moby")
ARCANE_LATEST_VERSION=$(get_latest_github_release "getarcaneapp/arcane")

msg_info "Installing Docker $DOCKER_LATEST_VERSION (with Compose, Buildx)"
DOCKER_CONFIG_PATH='/etc/docker/daemon.json'
mkdir -p $(dirname $DOCKER_CONFIG_PATH)
# Optimiert für Journald Logging im LXC
echo -e '{\n  "log-driver": "journald",\n  "storage-driver": "overlay2"\n}' >/etc/docker/daemon.json

# Docker Installation via offiziellen Script
$STD sh <(curl -fsSL https://get.docker.com)
msg_ok "Installed Docker $DOCKER_LATEST_VERSION"

# --- Auswahl-Menü ---
echo -e "${TAB3}Which Management UI would you like to install?"
echo -e "${TAB3}1) Portainer (Classic UI)"
echo -e "${TAB3}2) Arcane (Modern, focused on Docker Compose)"
echo -e "${TAB3}3) Both"
echo -e "${TAB3}4) None (Docker only)"
read -p "${TAB3}Selection [1-4]: " ui_choice

# Portainer Setup
if [[ "$ui_choice" == "1" || "$ui_choice" == "3" ]]; then
  msg_info "Installing Portainer"
  docker volume create portainer_data >/dev/null
  $STD docker run -d \
    -p 9443:9443 \
    --name=portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest
  msg_ok "Portainer installed (Port 9443)"
fi

# Arcane Setup
if [[ "$ui_choice" == "2" || "$ui_choice" == "3" ]]; then
  msg_info "Installing Arcane"
  # Verzeichnisse für Persistenz erstellen
  mkdir -p /opt/arcane/data /opt/arcane/projects
  
  # Aktuelle IP ermitteln für APP_URL
  IP_ADDR=$(hostname -I | awk '{print $1}')
  
  $STD docker run -d \
    --name arcane \
    --restart unless-stopped \
    -p 3552:3552 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /opt/arcane/data:/app/data \
    -v /opt/arcane/projects:/app/data/projects \
    -e APP_URL="http://${IP_ADDR}:3552" \
    -e ENCRYPTION_KEY=$(openssl rand -hex 32) \
    -e JWT_SECRET=$(openssl rand -hex 32) \
    -e TZ="Europe/Berlin" \
    ghcr.io/getarcaneapp/arcane:latest
  msg_ok "Arcane installed (Port 3552)"
fi

# Aufräumen und Abschluss
motd_ssh
customize
cleanup_lxc

msg_info "System configuration"
# Wichtiger Hinweis für LXC User
if [ -f /etc/pve/lxc/*.conf ]; then
  msg_ok "Note: Ensure 'Nesting' and 'Docker' are enabled in LXC Options."
fi
