#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar las máquinas virtuales para un laboratorio de ciberseguridad en Proxmox
#
# Ejecución remota:
#   curl -sL x | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Crear los puentes, en caso de que no existan
  # vmbr10
    echo "auto vmbr10"              >> /etc/network/interfaces
    echo "iface vmbr10 inet manual" >> /etc/network/interfaces
    echo "  bridge-ports none"      >> /etc/network/interfaces
    echo "  bridge-stp off"         >> /etc/network/interfaces
    echo "  bridge-fd 0"            >> /etc/network/interfaces
    echo "#Switch lan"              >> /etc/network/interfaces
    echo ""                         >> /etc/network/interfaces
  # vmbr20
    echo "auto vmbr20"              >> /etc/network/interfaces
    echo "iface vmbr20 inet manual" >> /etc/network/interfaces
    echo "  bridge-ports none"      >> /etc/network/interfaces
    echo "  bridge-stp off"         >> /etc/network/interfaces
    echo "  bridge-fd 0"            >> /etc/network/interfaces
    echo "# Switch lab"             >> /etc/network/interfaces
    echo ""                         >> /etc/network/interfaces

# Reiniciar el servicio de red
  systemctl restart networking

# Descargar máquinas virtuales a /tmp
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install curl
      echo ""
    fi
  curl -sL http://hacks4geeks.com/_/premium/descargas/proxmox/packs/cyberlab/openwrt.gzip -o /tmp/vzdump-qemu-1000-2024_10_26-23_59_00.vma.gz
  curl -sL http://hacks4geeks.com/_/premium/descargas/proxmox/packs/cyberlab/kali.gzip    -o /tmp/vzdump-qemu-1002-2024_10_26-23_59_00.vma.gz
  curl -sL http://hacks4geeks.com/_/premium/descargas/proxmox/packs/cyberlab/sift.gzip    -o /tmp/vzdump-qemu-1003-2024_10_26-23_59_00.vma.gz
  curl -sL http://hacks4geeks.com/_/premium/descargas/proxmox/packs/cyberlab/pruebas.gzip -o /tmp/vzdump-qemu-2002-2024_10_26-23_59_00.vma.gz

