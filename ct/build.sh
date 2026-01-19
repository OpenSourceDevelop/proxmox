#!/usr/bin/env bash

# Framework von tteck geladen
RD=$(echo "\033[01;31m")
YW=$(echo "\033[33m")
GN=$(echo "\033[1;32m")
CL=$(echo "\033[m")

# Framework-Funktionen von tteck laden
FUNCTIONS_FILE_PATH="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/functions.sh"
source <(curl -sL $FUNCTIONS_FILE_PATH)

# Variablen setzen
NEXTSTEP="Would you like to install another service?"

source <(curl -sL https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh)
