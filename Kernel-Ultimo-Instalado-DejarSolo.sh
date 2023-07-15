#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para dejar sólo el último kernel instalado en ProxmoxVE
#
# Ejecución remota:
#    curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/Kernel-Ultimo-Instalado-DejarSolo.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

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

  echo ""
  echo "  Comandos para Proxmox 6 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "  Iniciando el script para dejar sólo el último kernel instalado en ProxmoxVE 7..."
  echo ""

  # Determinar kernels instalados
    /root/scripts/p-scripts/Kernels-Instalados-Mostrar.sh | grep pve | grep "\-pve" > /tmp/KernelsInstalados.txt
  # Crear script
    echo '#!/bin/bash'                                    > /tmp/KernelUltimoInstaladoDejarSolo.sh
    echo ""                                              >> /tmp/KernelUltimoInstaladoDejarSolo.sh
    cat /tmp/KernelsInstalados.txt | head -n -1          >> /tmp/KernelUltimoInstaladoDejarSolo.sh
    sed -i -e 's|pve-kernel|apt-get -y remove pve-kernel|g' /tmp/KernelUltimoInstaladoDejarSolo.sh
    echo ""                                              >> /tmp/KernelUltimoInstaladoDejarSolo.sh
    echo "apt-get -y autoremove"                         >> /tmp/KernelUltimoInstaladoDejarSolo.sh
  # Dar permisos de ejecución al script
    chmod +x /tmp/KernelUltimoInstaladoDejarSolo.sh
  # Ejecutar script
    /tmp/KernelUltimoInstaladoDejarSolo.sh

fi

