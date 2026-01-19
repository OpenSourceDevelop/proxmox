# Proxmox Scripts

Eine Sammlung von optimierten Helper-Skripten für Proxmox LXC Container.

## Verfügbare Skripte

### 🐳 Docker & Dashboards (Portainer/Arcane)
Installiert Docker (Latest) inkl. Compose und wahlweise Portainer oder Arcane als Management-UI.

**Ausführen in der LXC-Konsole:**
```bash
bash -c "$(wget -qLO - [https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh](https://raw.githubusercontent.com/OpenSourceDevelop/proxmox/main/DockerArcane.sh))"
