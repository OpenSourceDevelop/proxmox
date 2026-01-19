#!/usr/bin/env bash
# Skript für den Proxmox Host zum Erstellen des Containers

# 1. Lade das Build-Framework von tteck
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.sh)

# 2. Definiere die Container-Eigenschaften
function build_container() {
  export PCT_OSTYPE="debian"
  export PCT_OSVERSION="12"
  export PCT_DISK_SIZE="8"
  export PCT_CPUS="2"
  export PCT_RAM="2048"
  # Startet den Dialog (Name, IP, etc.)
  build_container 
}

# 3. Variablen für den Installer
export FUNCTIONS_FILE_PATH="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/functions.sh"
# WICHTIG: Link zu deinem existierenden Installations-Skript
export INSTALL_SCRIPT="https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh"

# 4. Starte den tteck-Installer Prozess
bash -c "$(wget -qLO - https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/install.sh)"
