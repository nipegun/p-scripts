#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el último kernel disponible en ProxmoxVExmoxVE
#
# Ejecución remota:
#    curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/Kernel-Ultimo-Disponible-Instalar.sh | bash
# ----------

ccColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
vcFinColor='\033[0m'

# Determinar la versión de Debian
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
  echo "  Iniciando el script de instalación del último kernel para proxmox 3..."
  echo ""
  apt-get update && apt-get -y dist-upgrade
  vUltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $vUltKernelDisponible

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación del último kernel para proxmox 4..."
  echo ""
  apt-get update && apt-get -y dist-upgrade
  vUltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $vUltKernelDisponible

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación del último kernel para proxmox 5..."
  echo ""
  apt-get update && apt-get -y dist-upgrade
  vUltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $vUltKernelDisponible

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación del último kernel para proxmox 6..."
  echo ""
  apt-get update && apt-get -y dist-upgrade
  vUltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $vUltKernelDisponible

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación del último kernel para proxmox 7..."
  echo ""
  apt-get update && apt-get -y dist-upgrade
  vUltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $vUltKernelDisponible

fi

