#!/usr/bin/env bash

# --- 1. Host-Check: Wenn auf PVE ausgeführt, baue LXC ---
if [[ -z "$FUNCTIONS_FILE_PATH" ]]; then
  APP="Docker-Arcane"
  var_disk="8"
  var_cpu="2"
  var_ram="2048"
  var_os="debian"
  var_version="12"
  
  echo "Lade Proxmox-Helper Framework..."
  source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.sh)
  
  function build_container() {
    build_container
  }
  
  # WICHTIG: Dieser Pfad muss exakt stimmen!
  export FUNCTIONS_FILE_PATH="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/functions.sh"
  export INSTALL_SCRIPT="https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh"
  
  echo "Starte LXC Setup..."
  bash -c "$(wget -qLO - https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/install.sh)"
  exit
fi

# --- 2. Installation IM Container ---
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
