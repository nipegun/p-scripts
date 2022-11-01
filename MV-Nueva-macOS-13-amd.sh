#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar xxxxxxxxx en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-Nueva-macOS-13-amd.sh | bash
# ----------

vIdMV=888888
vAlmacenamiento=PVE
vCarpetaISO="/PVE/template/iso/"

echo ""
echo "  Clonando el repositorio OSX-KVM the NickDude..."
echo ""
rm /root/SoftInst/macOS/ -R 2> /dev/null
mkdir -p /root/SoftInst/macOS/ 2> /dev/null
cd /root/SoftInst/macOS/
# Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  git no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update && apt-get -y install git
    echo ""
  fi
git clone --depth=1 https://github.com/thenickdude/OSX-KVM

echo ""
echo "  Preparando la ISO..."
echo ""
apt-get -y install make
cd /root/SoftInst/macOS/OSX-KVM/scripts/ventura/
make Ventura-recovery.img
mv /root/SoftInst/macOS/OSX-KVM/scripts/ventura/Ventura-recovery.img $vCarpetaISO
vUltVersKVMOC=$(curl -sL https://github.com/thenickdude/KVM-Opencore/tags | sed 's-href-\nhref-g' | grep href | grep .zip | head -n1 | cut -d'"' -f2 | cut -d'/' -f7 | sed 's-.zip--g')
# Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  wget no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update && apt-get -y install wget
    echo ""
  fi
cd /root/SoftInst/macOS/
wget https://github.com/thenickdude/KVM-Opencore/releases/download/$vUltVersKVMOC/OpenCore-$vUltVersKVMOC.iso.gz
# Comprobar si el paquete gzip está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s gzip 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  gzip no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update && apt-get -y install gzip
    echo ""
  fi
gzip -d /root/SoftInst/macOS/OpenCore-$vUltVersKVMOC.iso.gz
mv /root/SoftInst/macOS/OpenCore-$vUltVersKVMOC.iso $vCarpetaISO

echo ""
echo "  Activando ignorar msrs para evitar loop de arranque de macOS..."
echo ""
echo 1 > /sys/module/kvm/parameters/ignore_msrs
echo "options kvm ignore_msrs=Y" >> /etc/modprobe.d/macos.conf
update-initramfs -u -k all

echo ""
echo "  Creando el archivo de configuración de la máquina virtual..."
echo ""
echo 'args: -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
-smbios type=2 \
-device usb-kbd,bus=ehci.0,port=2 \
-global nec-usb-xhci.msi=off \
-global ICH9-LPC.acpi-pci-hotplug-with-bridge-support=off \
-cpu Haswell-noTSX,vendor=GenuineIntel,+invtsc,+hypervisor,kvm=on,vmware-cpuid-freq=on'       > /etc/pve/qemu-server/$vIdMV.conf
echo "balloon: 0"                                                                            >> /etc/pve/qemu-server/$vIdMV.conf
echo "bios: ovmf"                                                                            >> /etc/pve/qemu-server/$vIdMV.conf
echo "boot: order=ide2;virtio0"                                                              >> /etc/pve/qemu-server/$vIdMV.conf
echo "cores: 4"                                                                              >> /etc/pve/qemu-server/$vIdMV.conf
echo "cpu: Haswell"                                                                          >> /etc/pve/qemu-server/$vIdMV.conf
echo "efidisk0: $vAlmacenamiento:$vIdMV/vm-$vIdMV-disk-0.raw,efitype=4m,size=528K"           >> /etc/pve/qemu-server/$vIdMV.conf
echo "ide0: $vAlmacenamiento:iso/Ventura-recovery.img,cache=unsafe"                          >> /etc/pve/qemu-server/$vIdMV.conf
echo "ide2: $vAlmacenamiento:iso/OpenCore-$vUltVersKVMOC.iso,cache=unsafe"                   >> /etc/pve/qemu-server/$vIdMV.conf
echo "machine: q35"                                                                          >> /etc/pve/qemu-server/$vIdMV.conf
echo "memory: 4096"                                                                          >> /etc/pve/qemu-server/$vIdMV.conf
echo "name: mimacosventura"                                                                  >> /etc/pve/qemu-server/$vIdMV.conf
echo "net0: virtio=00:00:00:00:00:99,bridge=vmbr0,firewall=1"                                >> /etc/pve/qemu-server/$vIdMV.conf
echo "numa: 0"                                                                               >> /etc/pve/qemu-server/$vIdMV.conf
echo "ostype: other"                                                                         >> /etc/pve/qemu-server/$vIdMV.conf
echo "scsihw: virtio-scsi-single"                                                            >> /etc/pve/qemu-server/$vIdMV.conf
echo "sockets: 1"                                                                            >> /etc/pve/qemu-server/$vIdMV.conf
echo "vga: vmware"                                                                           >> /etc/pve/qemu-server/$vIdMV.conf
echo "virtio0: $vAlmacenamiento:vm-$vIdMV-disk-1,cache=unsafe,discard=on,iothread=1,size=64" >> /etc/pve/qemu-server/$vIdMV.conf

echo ""
echo "  Script finalizado."
echo ""
echo "  Debes reiniciar Proxmox antes de encender por primera vez la máquina virtual de macOS."
echo ""

