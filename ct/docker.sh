#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.sh)

# Hier definierst du die Standard-Werte für deinen Container
function build_container() {
  # Diese Variablen werden vom tteck-Framework genutzt
  export PCT_OSTYPE="debian"
  export PCT_OSVERSION="12"
  export PCT_DISK_SIZE="8"
  export PCT_CPUS="2"
  export PCT_RAM="2048"
  
  # Das Framework erstellt hier den LXC
  build_container
}

# Nach der Erstellung wird dein Installations-Skript im Container aufgerufen
export FUNCTIONS_FILE_PATH="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/functions.sh"
# WICHTIG: Hier dein Installations-Skript verlinken
export INSTALL_SCRIPT="https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh"

# Starte den Installations-Prozess
bash -c "$(wget -qLO - https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/install.sh)"
