#!/usr/bin/env bash

# --- Framework Check & Load ---
if [[ -z "$FUNCTIONS_FILE_PATH" ]]; then
  source <(curl -sL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/functions.sh)
else
  source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
fi

# --- Standard Initialisierung ---
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

# --- LXC Feature Check ---
msg_info "Checking LXC Features"
if ! grep -q "overlay" /proc/filesystems; then
  msg_warn "Nesting ist nicht aktiviert! Docker benötigt Nesting."
  read -r -p "${TAB3}Trotzdem fortfahren? (y/N): " proceed
  if [[ ! ${proceed,,} =~ ^(y|yes)$ ]]; then
    msg_error "Installation abgebrochen."; exit 1
  fi
else
  msg_ok "LXC Nesting Check bestanden."
fi

# --- Docker Installation ---
DOCKER_LATEST_VERSION=$(get_latest_github_release "moby/moby")
msg_info "Installing Docker $DOCKER_LATEST_VERSION"
mkdir -p /etc/docker
echo -e '{\n  "log-driver": "journald",\n  "storage-driver": "overlay2"\n}' >/etc/docker/daemon.json
$STD sh <(curl -fsSL https://get.docker.com)
msg_ok "Installed Docker $DOCKER_LATEST_VERSION"

# --- UI Auswahl (Vorauswahl Arcane) ---
echo -e "${TAB3}Bitte wählen Sie eine Management-Oberfläche:"
echo -e "${TAB3}1) Portainer (Klassisch)"
echo -e "${TAB3}2) Arcane (Modern) [Standard]"
echo -e "${TAB3}3) Keine (Nur Docker)"
read -p "${TAB3}Auswahl [1-3] (Default 2): " ui_choice
ui_choice=${ui_choice:-2} # Setzt 2 als Default, wenn Eingabe leer ist

case "$ui_choice" in
  1)
    msg_info "Installing Portainer"
    docker volume create portainer_data >/dev/null
    $STD docker run -d -p 9443:9443 --name=portainer --restart=always \
      -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
    msg_ok "Portainer installiert auf Port 9443"
    ;;
  2)
    msg_info "Installing Arcane"
    mkdir -p /opt/arcane/data /opt/arcane/projects
    IP_ADDR=$(hostname -I | awk '{print $1}')
    $STD docker run -d --name arcane --restart unless-stopped -p 3552:3552 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /opt/arcane/data:/app/data \
      -v /opt/arcane/projects:/app/data/projects \
      -e APP_URL="http://${IP_ADDR}:3552" \
      -e ENCRYPTION_KEY=$(openssl rand -hex 32) \
      -e JWT_SECRET=$(openssl rand -hex 32) \
      -e TZ="Europe/Berlin" \
      ghcr.io/getarcaneapp/arcane:latest
    msg_ok "Arcane installiert auf http://${IP_ADDR}:3552"
    ;;
  *)
    msg_ok "Nur Docker installiert (kein Dashboard gewählt)."
    ;;
esac

# --- Abschluss ---
motd_ssh
customize
cleanup_lxc
