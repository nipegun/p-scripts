#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para descargar las últimas versiones de los containers disponibles en Proxmox
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PostInst/Containers-LXC-Descargar.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
ccColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Proxmox
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de containers para ProxmoxVE 3...${vFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 3 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de containers para ProxmoxVE 4...${vFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 4 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de containers para ProxmoxVE 5...${vFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 5 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de containers para ProxmoxVE 6...${vFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 6 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de containers para ProxmoxVE 7...${vFinColor}"
  echo ""

  # Descargar última versión del container de Debian
    pveam available | grep ebian | sed 's/system/ /g' | sed 's/ //g' > /tmp/ContenedoresDebian.txt
    vUltContDebian=$(cat /tmp/ContenedoresDebian.txt | tail -1)
    pveam download local-btrfs $vUltContDebian

  # Descargar última versión del container de Ubuntu
    pveam available | grep buntu | sed 's/system/ /g' | sed 's/ //g' > /tmp/ContenedoresUbuntu.txt
    vUltContUbuntu=$(cat /tmp/ContenedoresUbuntu.txt | tail -1)
    pveam download local-btrfs $vUltContUbuntu

fi

