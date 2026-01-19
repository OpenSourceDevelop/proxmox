#!/usr/bin/env bash

# Header
echo "Prüfe Umgebung..."

# Variablen für das Framework
APP="Docker-Arcane"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"

# Frameworks laden
echo "Lade Proxmox-Helper Frameworks..."
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.sh)

# Diese Funktion wird vom Framework aufgerufen
function build_container() {
  build_container
}

# Installations-Parameter
export FUNCTIONS_FILE_PATH="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/functions.sh"
export INSTALL_SCRIPT="https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh"

# Den eigentlichen Erstellungsprozess starten
echo "Starte LXC Erstellung..."
bash -c "$(wget -qLO - https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/install.sh)"
