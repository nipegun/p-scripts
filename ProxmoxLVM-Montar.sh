#!/bin/bash

echo ""
echo "  Montando LVM de Proxmox..."
echo ""
sudo mkdir -p /Particiones/LVM/G1/ 2> /dev/null
sudo mkdir -p /Particiones/LVM/G2/ 2> /dev/null
sudo mkdir -p /Particiones/LVM/G3/ 2> /dev/null
sudo mkdir -p /Particiones/LVM/G4/ 2> /dev/null
sudo apt-get -y update
sudo apt-get -y install lvm2
sudo vgchange --activate y pve'
mount -t auto /dev/$vLVMg1/root /Particiones/LVM/G1/root/
mount -t auto /dev/$vLVMg1/root /Particiones/LVM/G1/root/

