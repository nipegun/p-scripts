#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar el último kernel disponible en ProxmoxVExmoxVE
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/Kernel-InstalarUltimoDisponible.sh | bash
#
#---------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de borrado de kernels viejos para ProxmoxVE 3..."
  echo "------------------------------------------------------------------------"
  echo ""

  apt-get update && apt-get -y dist-upgrade
  UltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $UltKernelDisponible

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de borrado de kernels viejos para ProxmoxVE 4..."
  echo "------------------------------------------------------------------------"
  echo ""

  apt-get update && apt-get -y dist-upgrade
  UltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $UltKernelDisponible

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de borrado de kernels viejos para ProxmoxVE 5..."
  echo "------------------------------------------------------------------------"
  echo ""

  apt-get update && apt-get -y dist-upgrade
  UltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $UltKernelDisponible

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de borrado de kernels viejos para ProxmoxVE 6..."
  echo "------------------------------------------------------------------------"
  echo ""

  apt-get update && apt-get -y dist-upgrade
  UltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $UltKernelDisponible

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de borrado de kernels viejos para ProxmoxVE 7..."
  echo "------------------------------------------------------------------------"
  echo ""

  apt-get update && apt-get -y dist-upgrade
  UltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $UltKernelDisponible

fi
