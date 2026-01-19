#!/usr/bin/env bash

# 1. Lade das Build-System (erstellt den Container)
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.sh)

# 2. Einstellungen für den neuen Container
function build_container() {
  # Standard-Werte
  export PCT_OSTYPE="debian"
  export PCT_OSVERSION="12"
  export PCT_DISK_SIZE="8"
  export PCT_CPUS="2"
  export PCT_RAM="2048"
  # Diese Funktion startet den Proxmox-Dialog
  build_container
}

# 3. Das eigentliche Installations-Skript (deine Logik)
# Wir definieren hier, dass dieses Skript sich selbst als Installer aufruft
export INSTALL_SCRIPT="https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh"

# 4. Starte die Installation, falls wir bereits IM Container sind
if [[ -n "$FUNCTIONS_FILE_PATH" ]]; then
  # Hier kommt dein bisheriger Code (Docker, Arcane Auswahl etc.)
  # ... (dein restliches Skript) ...
  msg_info "Installing Docker..."
  # usw.
else
  # Wenn wir auf dem Host sind, starte den Erstellungsprozess
  bash -c "$(wget -qLO - https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/install.sh)"
fi
