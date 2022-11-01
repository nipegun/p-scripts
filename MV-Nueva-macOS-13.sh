#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar xxxxxxxxx en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-Nueva-macOS-13.sh | bash
# ----------

vIdMV=888888
vAlmacenamiento=PVE

echo 'args: -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
-smbios type=2 \
-device usb-kbd,bus=ehci.0,port=2 \
-global nec-usb-xhci.msi=off \
-global ICH9-LPC.acpi-pci-hotplug-with-bridge-support=off \
-cpu Haswell,vendor=GenuineIntel,+kvm_pv_eoi,+kvm_pv_unhalt,+hypervisor,kvm=on'  > /etc/pve/qemu-server/$vIdMV.conf
echo "balloon: 0"                                                               >> /etc/pve/qemu-server/$vIdMV.conf
echo "bios: ovmf"                                                               >> /etc/pve/qemu-server/$vIdMV.conf
echo "boot: order=ide2;virtio0"                                                 >> /etc/pve/qemu-server/$vIdMV.conf
echo "cores: 4"                                                                 >> /etc/pve/qemu-server/$vIdMV.conf
echo "cpu: Haswell"                                                             >> /etc/pve/qemu-server/$vIdMV.conf
echo "ide0: none,cache=unsafe"                                                  >> /etc/pve/qemu-server/$vIdMV.conf
echo "ide2: $vAlmacenamiento:iso/OpenCoreMacOS10.13.iso,cache=unsafe"           >> /etc/pve/qemu-server/$vIdMV.conf
echo "machine: q35"                                                             >> /etc/pve/qemu-server/$vIdMV.conf
echo "memory: 4096"                                                             >> /etc/pve/qemu-server/$vIdMV.conf
echo "name: mimacosventura"                                                     >> /etc/pve/qemu-server/$vIdMV.conf
echo "net0: virtio=00:00:00:00:00:99,bridge=vmbr0,firewall=1"                   >> /etc/pve/qemu-server/$vIdMV.conf
echo "numa: 0"                                                                  >> /etc/pve/qemu-server/$vIdMV.conf
echo "ostype: other"                                                            >> /etc/pve/qemu-server/$vIdMV.conf
echo "scsihw: virtio-scsi-single"                                               >> /etc/pve/qemu-server/$vIdMV.conf
echo "sockets: 1"                                                               >> /etc/pve/qemu-server/$vIdMV.conf
echo "vga: vmware"                                                              >> /etc/pve/qemu-server/$vIdMV.conf
echo "efidisk0: NVMeMVs:20514/vm-20514-disk-0.raw,efitype=4m,size=528K"         >> /etc/pve/qemu-server/$vIdMV.conf

echo "efidisk0: local-lvm:vm-100-disk-0,efitype=4m,size=4M"                     >> /etc/pve/qemu-server/$vIdMV.conf
echo "ide0: local:iso/Ventura-full.img,cache=unsafe,size=14G"                   >> /etc/pve/qemu-server/$vIdMV.conf
echo "ide2: local:iso/OpenCore-v17.iso,cache=unsafe,size=150M"                     >> /etc/pve/qemu-server/$vIdMV.conf
echo "virtio0: local-lvm:vm-100-disk-1,cache=unsafe,discard=on,iothread=1,size=64" >> /etc/pve/qemu-server/$vIdMV.conf

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
echo "  Activando ignorar msrs para evitar loop de arranque en macOS..."
echo ""
echo 1 > /sys/module/kvm/parameters/ignore_msrs
echo "options kvm ignore_msrs=Y" >> /etc/modprobe.d/macos.conf
update-initramfs -u -k all

echo ""
echo "  Script finalizado."
echo ""
echo "  Debes reiniciar Proxmox antes de encender por primera vez la máquina virtual de macOS."
echo ""

