#!/usr/bin/env bash

# Header Informationen für das tteck-Framework
APP="Docker-Arcane"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"

# 1. Lade das Build-Framework (erstellt den LXC)
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.sh)

# 2. Container-Einstellungen (wird vom Framework aufgerufen)
function build_container() {
  build_container
}

# 3. Variablen für den Installer (was im LXC passieren soll)
export FUNCTIONS_FILE_PATH="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/functions.sh"
export INSTALL_SCRIPT="https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh"

# 4. Starte den tteck-Installer Prozess
bash -c "$(wget -qLO - https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/install.sh)"
