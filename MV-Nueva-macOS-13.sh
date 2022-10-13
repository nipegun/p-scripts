echo "args: -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" -smbios type=2 -device usb-kbd,bus=ehci.0,port=2 -global nec-usb-xhci.msi=off -global ICH9-LPC.acpi-pci-hotplug-with-bridge-support=off -cpu Haswell,vendor=GenuineIntel,+kvm_pv_eoi,+kvm_pv_unhalt,+hypervisor,kvm=on"
echo "balloon: 0"
echo "bios: ovmf"
echo "boot: order=ide2;virtio0"
echo "cores: 4"
echo "cpu: Haswell"
echo "ide0: none,cache=unsafe"
echo "ide2: PVE:iso/OpenCoreMacOS10.13.iso,cache=unsafe"
echo "machine: q35"
echo "memory: 4096"
echo "name: mimacosventura"
echo "net0: virtio=00:00:00:00:00:99,bridge=vmbr0,firewall=1"
echo "numa: 0"
echo "ostype: other"
echo "scsihw: virtio-scsi-single"
echo "sockets: 1"
echo "vga: vmware"


echo "efidisk0: NVMeMVs:20514/vm-20514-disk-0.raw,efitype=4m,size=528K"

echo "efidisk0: local-lvm:vm-100-disk-0,efitype=4m,size=4M"
echo "ide0: local:iso/Ventura-full.img,cache=unsafe,size=14G"
echo "ide2: local:iso/OpenCore-v17.iso,cache=unsafe,size=150M"
echo "virtio0: local-lvm:vm-100-disk-1,cache=unsafe,discard=on,iothread=1,size=64"

echo ""
echo "  Activando ignorar msrs para evitar loop de arranque..."
echo ""
echo 1 > /sys/module/kvm/parameters/ignore_msrs
echo "options kvm ignore_msrs=Y" >> /etc/modprobe.d/macos.conf
update-initramfs -u -k all

