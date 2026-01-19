#!/usr/bin/env bash

# Hier wird das Framework von tteck geladen
RD=$(echo "\033[01;31m")
YW=$(echo "\033[33m")
GN=$(echo "\033[1;32m")
CL=$(echo "\033[m")

# 1. Framework-Funktionen von tteck laden
# Diese URL enthält alle Definitionen für msg_info, color, etc.
FUNCTIONS_FILE_PATH="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/functions.sh"
source <(curl -sL $FUNCTIONS_FILE_PATH)

# 2. Deine Variablen setzen
NEXTSTEP="Would you like to install another service?"

# 3. Dein eigentliches Installations-Skript aufrufen
# Ersetze die URL mit dem Pfad zu deinem DockerArcane.sh
source <(curl -sL https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh)
