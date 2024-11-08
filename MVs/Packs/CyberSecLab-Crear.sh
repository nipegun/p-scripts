#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear un laboratorio de ciberseguridad en Proxmox
#
# Ejecución remota:
#   https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/CyberSecLab-Crear.sh | bash
#
# Ejecución remota con parámetros:
#   https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/CyberSecLab-Crear.sh | bash -s Almacenamiento
#
# Bajar y editar directamente el archivo en nano
#   https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/CyberSecLab-Crear.sh | nano -
# ----------

# Definir el almacenamiento
vAlmacenamiento=${1:-'local-lvm'} # Si le paso un parámetro, el almacenamiento será el primer parámetro. Si no, será local-lvm.

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de creación de laboratorio de ciberseguridad para Promxox...${cFinColor}"
  echo ""

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}    Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Crear los puentes
  echo ""
  echo "    Levantando los puentes vmbr100 y vmbr200..."
  echo ""
  # Crear el puente vmbr100
    ip link add name vmbr100 type bridge
    ip link set dev vmbr100 up
  # Crear el puente vmbr200
    ip link add name vmbr200 type bridge
    ip link set dev vmbr200 up

  echo ""
  echo "    Haciendo los puentes persistentes..."
  echo ""
  echo ""                                         >> /etc/network/interfaces
  echo "auto vmbr100"                             >> /etc/network/interfaces
  echo "iface vmbr100 inet manual"                >> /etc/network/interfaces
  echo "    bridge-ports none"                    >> /etc/network/interfaces
  echo "    bridge-stp off"                       >> /etc/network/interfaces
  echo "    bridge-fd 0"                          >> /etc/network/interfaces
  echo "# Switch para la red LAN del laboratorio" >> /etc/network/interfaces
  echo ""                                         >> /etc/network/interfaces
  echo "auto vmbr200"                             >> /etc/network/interfaces
  echo "iface vmbr200 inet manual"                >> /etc/network/interfaces
  echo "    bridge-ports none"                    >> /etc/network/interfaces
  echo "    bridge-stp off"                       >> /etc/network/interfaces
  echo "    bridge-fd 0"                          >> /etc/network/interfaces
  echo "# Switch para la red LAB del laboratorio" >> /etc/network/interfaces
  echo ""                                         >> /etc/network/interfaces

# Crear la máquina virtual de openwrtlab
  echo ""
  echo "    Creando la máquina virtual de openwrtlab..."
  echo ""
  qm create 1000 \
    --name openwrt \
    --machine q35 \
    --bios ovmf \
    --numa 0 \
    --sockets 1 \
    --cpu x86-64-v2-AES \
    --cores 2 \
    --memory 1024 \
    --balloon 0 \
    --net0 virtio,bridge=vmbr0,firewall=1 \
    --net1 virtio=00:aa:aa:aa:10:01,bridge=vmbr100,firewall=1 \
    --net2 virtio=00:aa:aa:aa:20:01,bridge=vmbr200,firewall=1 \
    --boot order=sata0 \
    --scsihw virtio-scsi-single \
    --ostype l26 \
    --agent 1
  # Descargar el .vmdk de openwrtlab e importarlo en la máquina virtual
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update && apt-get -y install curl
        echo ""
      fi
    curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Packs/CyberSecLab/openwrtlab.vmdk -o /tmp/openwrtlab.vmdk
    qm importdisk 1000 /tmp/openwrtlab.vmdk "$vAlmacenamiento" && rm -f /tmp/openwrtlab.vmdk
    vRutaAlDisco=$(qm config 1000 | grep unused | cut -d' ' -f2)
    qm set 1000 --sata0 $vRutaAlDisco

# Crear la máquina virtual de kali
  echo ""
  echo "    Creando la máquina virtual de kali..."
  echo ""
  qm create 1002 \
    --name kali \
    --machine q35 \
    --bios ovmf \
    --numa 0 \
    --sockets 1 \
    --cpu x86-64-v2-AES \
    --cores 4 \
    --memory 4096 \
    --balloon 0 \
    --vga virtio,memory=512 \
    --net0 virtio=00:aa:aa:aa:10:02,bridge=vmbr100,firewall=1 \
    --boot order=sata0 \
    --scsihw virtio-scsi-single \
    --sata0 none,media=cdrom \
    --ostype l26 \
    --agent 1
  # Descargar el .vmdk de kali e importarlo en la máquina virtual
    curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Packs/CyberSecLab/kali.vmdk -o /tmp/kali.vmdk
    qm importdisk 1002 /tmp/kali.vmdk "$vAlmacenamiento" && rm -f /tmp/kali.vmdk
    vRutaAlDisco=$(qm config 1002 | grep unused | cut -d' ' -f2)
    qm set 1002 --virtio0 $vRutaAlDisco
    qm set 1002 --boot order='sata0;virtio0'

# Crear la máquina virtual de sift
  echo ""
  echo "    Creando la máquina virtual de sift..."
  echo ""
  qm create 1003 \
    --name sift \
    --machine q35 \
    --bios ovmf \
    --numa 0 \
    --sockets 1 \
    --cpu x86-64-v2-AES \
    --cores 4 \
    --memory 4096 \
    --balloon 0 \
    --vga virtio,memory=512 \
    --net0 virtio=00:aa:aa:aa:10:03,bridge=vmbr100,firewall=1 \
    --boot order=sata0 \
    --scsihw virtio-scsi-single \
    --sata0 none,media=cdrom \
    --ostype l26 \
    --agent 1
  # Descargar el .vmdk de sift e importarlo en la máquina virtual
    curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Packs/CyberSecLab/sift.vmdk -o /tmp/sift.vmdk
    qm importdisk 1003 /tmp/sift.vmdk "$vAlmacenamiento" && rm -f /tmp/sift.vmdk
    vRutaAlDisco=$(qm config 1003 | grep unused | cut -d' ' -f2)
    qm set 1003 --virtio0 $vRutaAlDisco
    qm set 1003 --boot order='sata0;virtio0'

# Crear la máquina virtual de pruebas
  echo ""
  echo "    Creando la máquina virtual de pruebas..."
  echo ""
  qm create 2002 \
    --name pruebas \
    --machine q35 \
    --bios ovmf \
    --numa 0 \
    --sockets 1 \
    --cpu x86-64-v2-AES \
    --cores 4 \
    --memory 4096 \
    --balloon 0 \
    --vga virtio,memory=512 \
    --net0 virtio=00:aa:aa:aa:20:02,bridge=vmbr200,firewall=1 \
    --boot order=sata0 \
    --scsihw virtio-scsi-single \
    --sata0 none,media=cdrom \
    --ostype l26 \
    --agent 1
