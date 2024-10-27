#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar las máquinas virtuales para un laboratorio de ciberseguridad en Proxmox
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/Packs/CyberSecLab-DescargarEImportar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/Packs/CyberSecLab-DescargarEImportar.sh | nano -
# ----------

# Deficir el almacenamiento donde importar
  vAlmacenamiento='local-lvm'

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
#    echo "auto vmbr10"              >> /etc/network/interfaces
#    echo "iface vmbr10 inet manual" >> /etc/network/interfaces
#    echo "  bridge-ports none"      >> /etc/network/interfaces
#    echo "  bridge-stp off"         >> /etc/network/interfaces
#    echo "  bridge-fd 0"            >> /etc/network/interfaces
#    echo "#Switch lan"              >> /etc/network/interfaces
#    echo ""                         >> /etc/network/interfaces
  # vmbr20
#    echo "auto vmbr20"              >> /etc/network/interfaces
#    echo "iface vmbr20 inet manual" >> /etc/network/interfaces
#    echo "  bridge-ports none"      >> /etc/network/interfaces
#    echo "  bridge-stp off"         >> /etc/network/interfaces
#    echo "  bridge-fd 0"            >> /etc/network/interfaces
#    echo "# Switch lab"             >> /etc/network/interfaces
#    echo ""                         >> /etc/network/interfaces

# Reiniciar el servicio de red
#  systemctl restart networking

# Descargar máquinas virtuales a /tmp
  echo ""
  echo "  Descargando y restaurando las máquinas virtuales para el laboratorio de ciberseguridad..."
  echo ""

  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install curl
      echo ""
    fi

  # openwrtlab
    echo ""
    echo "    Descargando y restaurando openwrtlab..."
    echo ""
    curl -L https://hacks4geeks.com/_/descargas/PVE/Packs/CyberSecLab/openwrtlab.vma.gz -o /tmp/vzdump-qemu-1000-2024_01_01-01_01_01.vma.gz
    qmrestore /tmp/vzdump-qemu-1000-2024_01_01-01_01_01.vma.gz 1000 --storage $vAlmacenamiento && rm -f /tmp/vzdump-qemu-1000-2024_01_01-01_01_01.vma.gz
    # Asignar RAM correcta
      qm set 1000 -memory 2048 -balloon 0
    # Conectar a los puentes correctos
      qm set 1000 -net0 bridge=vmbr0
      qm set 1000 -net1 bridge=vmbr10
      qm set 1000 -net2 bridge=vmbr20

  # kali
    echo ""
    echo "    Descargando y restaurando kali..."
    echo ""
    curl -L https://hacks4geeks.com/_/descargas/PVE/Packs/CyberSecLab/kali.vma.gz       -o /tmp/vzdump-qemu-1002-2024_01_01-01_01_01.vma.gz
    qmrestore /tmp/vzdump-qemu-1002-2024_01_01-01_01_01.vma.gz 1002 --storage $vAlmacenamiento && rm -f /tmp/vzdump-qemu-1002-2024_01_01-01_01_01.vma.gz
    # Asignar RAM correcta
      qm set 1002 -memory 8192 -balloon 0
    # Conectar al puente correcto
      qm set 1002 -net0 bridge=vmbr10

  # sift
    echo ""
    echo "    Descargando y restaurando sift..."
    echo ""
    curl -L https://hacks4geeks.com/_/descargas/PVE/Packs/CyberSecLab/sift.vma.gz       -o /tmp/vzdump-qemu-1003-2024_01_01-01_01_01.vma.gz
    qmrestore /tmp/vzdump-qemu-1003-2024_01_01-01_01_01.vma.gz 1003 --storage $vAlmacenamiento && rm -f /tmp/vzdump-qemu-1003-2024_01_01-01_01_01.vma.gz
    # Asignar RAM correcta
      qm set 1003 -memory 8192 -balloon 0
    # Conectar al puente correcto
      qm set 1003 -net0 bridge=vmbr10

  # pruebas
    echo ""
    echo "    Descargando y restaurando máquina de pruebas..."
    echo ""
    curl -L https://hacks4geeks.com/_/descargas/PVE/Packs/CyberSecLab/pruebas.vma.gz    -o /tmp/vzdump-qemu-2002-2024_01_01-01_01_01.vma.gz
    qmrestore /tmp/vzdump-qemu-2002-2024_01_01-01_01_01.vma.gz 2002 --storage $vAlmacenamiento && rm -f /tmp/vzdump-qemu-2002-2024_01_01-01_01_01.vma.gz
    # Asignar RAM correcta
      qm set 2002 -memory 8192 -balloon 0
    # Conectar al puente correcto
      qm set 2002 -net0 bridge=vmbr20
  
