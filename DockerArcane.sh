#!/usr/bin/env bash

# --- 1. Host-Check: Wenn auf PVE (Proxmox) ausgeführt ---
if [[ -z "$FUNCTIONS_FILE_PATH" ]]; then
  echo "Vorbereitung der LXC-Erstellung..."
  
  # Variablen für das Framework
  export APP="Docker-Arcane"
  export var_disk="8"
  export var_cpu="2"
  export var_ram="2048"
  export var_os="debian"
  export var_version="12"
  export NSAPP="dockerarcane"
  
  # WICHTIG: Pfade für die Installation (Diese sind aktuell und stabil)
  export FUNCTIONS_FILE_PATH="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/functions.sh"
  export INSTALL_SCRIPT="https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh"

  echo "Starte Proxmox LXC Setup..."
  # Wir rufen direkt den Installer auf, das vermeidet den 404-Fehler beim Framework-Laden
  bash -c "$(wget -qLO - https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/install.sh)"
  exit
fi

# --- 2. Installation IM Container (wird erst nach LXC-Erstellung aktiv) ---
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Docker"
$STD sh <(curl -fsSL https://get.docker.com)
msg_ok "Installed Docker"

echo -e "${TAB3}Management-UI:\n${TAB3}1) Portainer\n${TAB3}2) Arcane (Standard)\n${TAB3}3) Nur Docker"
read -p "${TAB3}Auswahl [1-3] (Default 2): " ui_choice
ui_choice=${ui_choice:-2}

case "$ui_choice" in
  1)
    msg_info "Installing Portainer"
    docker volume create portainer_data >/dev/null
    $STD docker run -d -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
    ;;
  2)
    msg_info "Installing Arcane"
    mkdir -p /opt/arcane/data /opt/arcane/projects
    IP_ADDR=$(hostname -I | awk '{print $1}')
    $STD docker run -d --name arcane --restart unless-stopped -p 3552:3552 -v /var/run/docker.sock:/var/run/docker.sock -v /opt/arcane/data:/app/data -v /opt/arcane/projects:/app/data/projects -e APP_URL="http://${IP_ADDR}:3552" -e ENCRYPTION_KEY=$(openssl rand -hex 32) -e JWT_SECRET=$(openssl rand -hex 32) -e TZ="Europe/Berlin" ghcr.io/getarcaneapp/arcane:latest
    ;;
esac

customize
cleanup_lxc
