#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------
#  Script de NiPeGun para borrar todos los kernels viejos de ProxmoxVE
#
#  Ejecución remota:
#  curl -s | bash
#
#-----------------------------------------------------------------------

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

  echo ""
  echo "Script para Proxmox 3 todavía no preparado. Prueba ejecutarlo en otra versión de Proxmox"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de borrado de kernels viejos para ProxmoxVE 4..."
  echo "------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Script para Proxmox 4 todavía no preparado. Prueba ejecutarlo en otra versión de Proxmox"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de borrado de kernels viejos para ProxmoxVE 5..."
  echo "------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Script para Proxmox 5 todavía no preparado. Prueba ejecutarlo en otra versión de Proxmox"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de borrado de kernels viejos para ProxmoxVE 6..."
  echo "------------------------------------------------------------------------"
  echo ""

  apt-get -y remove pve-kernel-4.10.1-2-pve  pve-headers-4.10.1-2-pve
  apt-get -y remove pve-kernel-4.10.5-1-pve  pve-headers-4.10.5-1-pve
  apt-get -y remove pve-kernel-4.10.8-1-pve  pve-headers-4.10.8-1-pve
  apt-get -y remove pve-kernel-4.10.11-1-pve pve-headers-4.10.11-1-pve
  apt-get -y remove pve-kernel-4.10.15-1-pve pve-headers-4.10.15-1-pve
  apt-get -y remove pve-kernel-4.10.17-1-pve pve-headers-4.10.17-1-pve
  apt-get -y remove pve-kernel-4.10.17-2-pve pve-headers-4.10.17-2-pve
  apt-get -y remove pve-kernel-4.10.17-3-pve pve-headers-4.10.17-3-pve
  apt-get -y remove pve-kernel-4.10.17-4-pve pve-headers-4.10.17-4-pve
  apt-get -y remove pve-kernel-4.10.17-5-pve pve-headers-4.10.17-5-pve
  # apt-get -y remove pve-kernel-4.13
  apt-get -y remove pve-kernel-4.13.3-1-pve  pve-headers-4.13.3-1-pve
  apt-get -y remove pve-kernel-4.13.4-1-pve  pve-headers-4.13.4-1-pve
  apt-get -y remove pve-kernel-4.13.8-1-pve  pve-headers-4.13.8-1-pve
  apt-get -y remove pve-kernel-4.13.8-2-pve  pve-headers-4.13.8-2-pve
  apt-get -y remove pve-kernel-4.13.8-3-pve  pve-headers-4.13.8-3-pve
  apt-get -y remove pve-kernel-4.13.13-1-pve pve-headers-4.13.13-1-pve
  apt-get -y remove pve-kernel-4.13.13-2-pve pve-headers-4.13.13-2-pve
  apt-get -y remove pve-kernel-4.13.13-3-pve pve-headers-4.13.13-3-pve
  apt-get -y remove pve-kernel-4.13.13-4-pve pve-headers-4.13.13-4-pve
  apt-get -y remove pve-kernel-4.13.13-5-pve pve-headers-4.13.13-5-pve
  apt-get -y remove pve-kernel-4.13.13-6-pve pve-headers-4.13.13-6-pve
  apt-get -y remove pve-kernel-4.13.16-1-pve pve-headers-4.13.16-1-pve
  apt-get -y remove pve-kernel-4.13.16-2-pve pve-headers-4.13.16-2-pve
  apt-get -y remove pve-kernel-4.13.16-3-pve pve-headers-4.13.16-3-pve
  # apt-get -y remove pve-kernel-4.15
  apt-get -y remove pve-kernel-4.15.3-1-pve  pve-headers-4.15.3-1-pve
  apt-get -y remove pve-kernel-4.15.10-1-pve pve-headers-4.15.10-1-pve
  apt-get -y remove pve-kernel-4.15.15-1-pve pve-headers-4.15.15-1-pve
  apt-get -y remove pve-kernel-4.15.17-1-pve pve-headers-4.15.17-1-pve
  apt-get -y remove pve-kernel-4.15.17-2-pve pve-headers-4.15.17-2-pve
  apt-get -y remove pve-kernel-4.15.17-3-pve pve-headers-4.15.17-3-pve
  apt-get -y remove pve-kernel-4.15.18-1-pve pve-headers-4.15.18-1-pve
  apt-get -y remove pve-kernel-4.15.18-2-pve pve-headers-4.15.18-2-pve
  apt-get -y remove pve-kernel-4.15.18-3-pve pve-headers-4.15.18-3-pve
  apt-get -y remove pve-kernel-4.15.18-4-pve pve-headers-4.15.18-4-pve
  apt-get -y remove pve-kernel-4.15.18-5-pve pve-headers-4.15.18-5-pve
  apt-get -y remove pve-kernel-4.15.18-6-pve pve-headers-4.15.18-6-pve
  apt-get -y remove pve-kernel-4.15.18-7-pve pve-headers-4.15.18-7-pve
  apt-get -y remove pve-kernel-4.15.18-8-pve pve-headers-4.15.18-8-pve
  apt-get -y remove pve-kernel-4.15.18-9-pve pve-headers-4.15.18-9-pve
  apt-get -y remove pve-kernel-4.15.18-10-pve pve-headers-4.15.18-10-pve

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "------------------------------------------------------------------------"
  echo "  Iniciando el script de borrado de kernels viejos para ProxmoxVE 7..."
  echo "------------------------------------------------------------------------"
  echo ""

  apt-get update && apt-get -y dist-upgrade
  UltKernelDisponible=$(apt-cache search pve-kernel | grep atest | tail -1 | cut -d ' ' -f1)
  apt-get -y install $UltKernelDisponible
  KernelsInstalados=$(dpkg-query -l | grep pve-kernel | cut -d ' ' -f3 | grep -v firmware | grep -v helper)

fi

