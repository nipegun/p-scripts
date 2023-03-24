#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para dejar sólo el último kernel instalado en ProxmoxVE
#
#  Ejecución remota:
#    curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/Kernel-DejarSoloElUltimo.sh | bash
# ----------

vColorRojo='\033[1;31m'
vColorVerde='\033[1;32m'
vFinColor='\033[0m'

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
  echo "  Iniciando el script para dejar sólo el último kernel instalado en ProxmoxVE 3..."
  echo ""

  echo ""
  echo "  Comandos para Proxmox 3 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "  Iniciando el script para dejar sólo el último kernel instalado en ProxmoxVE 4..."
  echo ""

  echo ""
  echo "  Comandos para Proxmox 4 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "  Iniciando el script para dejar sólo el último kernel instalado en ProxmoxVE 5..."
  echo ""

  echo ""
  echo "  Comandos para Proxmox 5 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "  Iniciando el script para dejar sólo el último kernel instalado en ProxmoxVE 6..."
  echo ""

  dpkg-query -l | grep pve-kernel | cut -d ' ' -f3 | grep -v firmware | grep -v helper > /tmp/KernelsInstalados.txt
  echo '#!/bin/bash '                                   > /tmp/BorrarKernelsViejos.sh
  echo ""                                              >> /tmp/BorrarKernelsViejos.sh
  cat /tmp/KernelsInstalados.txt | head -n -1          >> /tmp/BorrarKernelsViejos.sh
  sed -i -e 's|pve-kernel|apt-get -y remove pve-kernel|g' /tmp/BorrarKernelsViejos.sh
  echo ""                                              >> /tmp/BorrarKernelsViejos.sh
  echo "apt-get -y autoremove"                         >> /tmp/BorrarKernelsViejos.sh
  chmod +x                                                /tmp/BorrarKernelsViejos.sh
  /tmp/BorrarKernelsViejos.sh

  # apt-get -y remove pve-kernel-4.15.18-10-pve --purge
  # apt-get -y remove pve-headers-4.15.18-10-pve --purge

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "  Iniciando el script para dejar sólo el último kernel instalado en ProxmoxVE 7..."
  echo ""

  dpkg-query -l | grep pve-kernel | cut -d ' ' -f3 | grep -v firmware | grep -v helper > /tmp/KernelsInstalados.txt
  echo '#!/bin/bash '                                   > /tmp/BorrarKernelsViejos.sh
  echo ""                                              >> /tmp/BorrarKernelsViejos.sh
  cat /tmp/KernelsInstalados.txt | head -n -1          >> /tmp/BorrarKernelsViejos.sh
  sed -i -e 's|pve-kernel|apt-get -y remove pve-kernel|g' /tmp/BorrarKernelsViejos.sh
  echo ""                                              >> /tmp/BorrarKernelsViejos.sh
  echo "apt-get -y autoremove"                         >> /tmp/BorrarKernelsViejos.sh
  chmod +x                                                /tmp/BorrarKernelsViejos.sh
  /tmp/BorrarKernelsViejos.sh

fi

