#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para crear una máquina virtual para OpenWrt desde la terminal de ProxmoxVE
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-Nueva-OpenWrt.sh | bash
# ----------

vIdMV="201"
vNomAlmMV="PVE"
vNomAlmISO="PVE"
vCarpAlmISO="/PVE/template/iso"
vURLDescarga="https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/"

echo ""
echo "---------------------------------------------------------------------------------"
echo "  Iniciando el script de creación de máquina virtual de OpenWrt para Proxmox..."
echo "---------------------------------------------------------------------------------"
echo ""

# Detener la MV o CT si es que existe y está encendida/o
  echo ""
  echo "  Deteniendo la MV o CT $vIdMV, si es que existe y está encendida/o..."
  echo ""
  qm stop $vIdMV     2> /dev/null
  pct stop $vIdMV    2> /dev/null
# Borrar la MV existente
  echo ""
  echo "  Borrando la MV o CT $vIdMV, si es que existe..."
  echo ""
  # Quitar la protección a la MV
    sed -i -e 's-protection: 1--'g /etc/pve/qemu-server/$vIdMV.conf 2> /dev/null
  # Borrarla
  qm destroy $vIdMV  2> /dev/null
  pct destroy $vIdMV 2> /dev/null
# Crear archivo de configuración para la máquina nueva
  echo ""
  echo "  Creando archivo de configuración para la MV $vIdMV..."
  echo ""
  touch /etc/pve/qemu-server/$vIdMV.conf
  echo "name: openwrt"                                           > /etc/pve/qemu-server/$vIdMV.conf
  echo "onboot: 1"                                              >> /etc/pve/qemu-server/$vIdMV.conf
  echo "machine: q35"                                           >> /etc/pve/qemu-server/$vIdMV.conf
  echo "balloon: 512"                                           >> /etc/pve/qemu-server/$vIdMV.conf
  echo "memory: 2048"                                           >> /etc/pve/qemu-server/$vIdMV.conf
  echo "numa: 0"                                                >> /etc/pve/qemu-server/$vIdMV.conf
  echo "sockets: 1"                                             >> /etc/pve/qemu-server/$vIdMV.conf
  echo "cores: 2"                                               >> /etc/pve/qemu-server/$vIdMV.conf
  echo "net0: virtio=00:00:00:00:02:01,bridge=vmbr0,firewall=1" >> /etc/pve/qemu-server/$vIdMV.conf
  echo "scsihw: virtio-scsi-pci"                                >> /etc/pve/qemu-server/$vIdMV.conf
  echo "ide0: none,media=cdrom"                                 >> /etc/pve/qemu-server/$vIdMV.conf
  echo "bios: ovmf"                                             >> /etc/pve/qemu-server/$vIdMV.conf
  echo "boot: order=ide0;sata0"                                 >> /etc/pve/qemu-server/$vIdMV.conf
  echo "ostype: l26"                                            >> /etc/pve/qemu-server/$vIdMV.conf
  echo "protection: 1"                                          >> /etc/pve/qemu-server/$vIdMV.conf
# Crear disco para la máquina nueva
  echo ""
  echo "  Agregando un disco duro a la máquina virtual $vIdMV..."
  echo ""
  qm set $vIdMV --sata0 $vNomAlmMV:28
# Descargar una versión de debian live
  echo ""
  echo "  Descargando la última versión de Debian Live con escritorio Mate..."
  echo ""
  vArchivo=$(curl -s $vURLDescarga | sed 's->->\n-g' | grep href |grep "mate.iso" | tail -n 1 | cut -d'"' -f2)
  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  wget no está instalado. Iniciando su instalación..."
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install wget
    echo ""
  fi
  wget -q --show-progress $vURLDescarga$vArchivo -O $vCarpAlmISO/$vArchivo
# Asignar la ISO descargada a la máquina virtual
  echo ""
  echo "  Asignando la ISO descargada a la lectora IDE de la máquina virtual..."
  echo ""
  qm set $vIdMV --ide0 $vNomAlmISO:iso/$vArchivo
# Iniciar la máquina virtual para empezar a instalar
  echo ""
  echo "  Iniciando la máquina virtual para proceder con la instalación..."
  echo ""
  qm start $vIdMV

