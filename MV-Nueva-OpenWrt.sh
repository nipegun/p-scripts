#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear una máquina virtual para OpenWrt desde la terminal de ProxmoxVE
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-Nueva-OpenWrt.sh | bash
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-Nueva-OpenWrt.sh |sed 's-vIdMV="201"-vIdMV="999"-g' | bash
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-Nueva-OpenWrt.sh |sed 's-vIdMV="201"-vIdMV="999"-g' | sed 's-vNomAlmMV="PVE"-vNomAlmMV="local-lvm"-g' | bash
# ----------

vIdMV="201"
vNomAlmMV="PVE"
vNomAlmISO="PVE"
vCarpAlmISO="/PVE/template/iso"
vURLDescarga="https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/"

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorAzul}  Iniciando el script de creación de máquina virtual de OpenWrt para Proxmox...${cFinColor}"
echo ""

# Detener la MV o CT si es que existe y está encendida/o
  echo ""
  echo -e "${cColorAzulClaro}    Deteniendo la MV o CT $vIdMV, si es que existe y está encendida/o...${cFinColor}"
  echo ""
  qm stop $vIdMV     2> /dev/null
  pct stop $vIdMV    2> /dev/null
# Borrar la MV existente
  echo ""
  echo -e "${cColorAzulClaro}    Borrando la MV o CT $vIdMV, si es que existe...${cFinColor}"
  echo ""
  # Quitar la protección a la MV
    sed -i -e 's-protection: 1--'g /etc/pve/qemu-server/$vIdMV.conf 2> /dev/null
  # Borrarla
  qm destroy $vIdMV  2> /dev/null
  pct destroy $vIdMV 2> /dev/null
# Crear archivo de configuración para la máquina nueva
  echo ""
  echo -e "${cColorAzulClaro}    Creando un nuevo archivo de configuración para la MV $vIdMV...${cFinColor}"
  echo ""
  touch /etc/pve/qemu-server/$vIdMV.conf
  echo "name: openwrt"                                           > /etc/pve/qemu-server/$vIdMV.conf
  echo "onboot: 1"                                              >> /etc/pve/qemu-server/$vIdMV.conf
  echo "machine: q35"                                           >> /etc/pve/qemu-server/$vIdMV.conf
  echo "balloon: 512"                                           >> /etc/pve/qemu-server/$vIdMV.conf
  echo "memory: 1024"                                           >> /etc/pve/qemu-server/$vIdMV.conf
  echo "numa: 0"                                                >> /etc/pve/qemu-server/$vIdMV.conf
  echo "sockets: 1"                                             >> /etc/pve/qemu-server/$vIdMV.conf
  echo "cores: 2"                                               >> /etc/pve/qemu-server/$vIdMV.conf
  echo "net0: virtio=00:00:00:00:02:01,bridge=vmbr0,firewall=1" >> /etc/pve/qemu-server/$vIdMV.conf
  echo "scsihw: virtio-scsi-pci"                                >> /etc/pve/qemu-server/$vIdMV.conf
  echo "bios: ovmf"                                             >> /etc/pve/qemu-server/$vIdMV.conf
  echo "boot: order=ide0;sata0"                                 >> /etc/pve/qemu-server/$vIdMV.conf
  echo "ostype: l26"                                            >> /etc/pve/qemu-server/$vIdMV.conf
  echo "protection: 1"                                          >> /etc/pve/qemu-server/$vIdMV.conf
# Crear disco para la máquina nueva
  echo ""
  echo -e "${cColorAzulClaro}    Agregando un nuevo disco duro a la máquina virtual $vIdMV...${cFinColor}"
  echo ""
  qm set $vIdMV --sata0 $vNomAlmMV:28
# Descargar una versión de debian live
  echo ""
  echo -e "${cColorAzulClaro}    Descargando la última versión de Debian Live...${cFinColor}"
  echo ""
  #vArchivo=$(curl -sL $vURLDescarga | sed 's->->\n-g' | grep href |grep "mate.iso" | tail -n 1 | cut -d'"' -f2)
  vArchivo=$(curl -sL $vURLDescarga | sed 's->->\n-g' | grep href |grep "standard.iso" | tail -n 1 | cut -d'"' -f2)
  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}   El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install wget
      echo ""
    fi
  wget -q --show-progress $vURLDescarga$vArchivo -O $vCarpAlmISO/$vArchivo
# Asignar la ISO descargada a la máquina virtual
  echo ""
  echo -e "${cColorAzulClaro}    Asignando la ISO recién descargada a la lectora IDE de la nueva máquina virtual...${cFinColor}"
  echo ""
  qm set $vIdMV --cdrom $vNomAlmISO:iso/$vArchivo
  sed -i -e 's|ide2:|ide0:|g' /etc/pve/qemu-server/$vIdMV.conf
  sed -i -e 's|boot: order=ide0;sata0;ide2|boot: order=ide0;sata0|g' /etc/pve/qemu-server/$vIdMV.conf
# Iniciar la máquina virtual para empezar a instalar
  echo ""
  echo -e "${cColorAzulClaro}    Iniciando la nueva máquina virtual para proceder con la instalación de OpenWrt...${cFinColor}"
  echo ""
  qm start $vIdMV
  echo ""

