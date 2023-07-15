#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que te salga de los huevos con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear una máquina virtual para DSM en el MicroServer Gen10
# ----------

cCantArgumEsperados=4
E_BADARGS=65

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${cColorVerde}[IDDeLaMV] [Núcleos] [RAM] [TamañoDiscoEnGB]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ""
    echo "CrearMVDSMParaMSGen10 200 2 2048 32"
    echo "-------------------------------------------------------------------------"
    echo ""
    exit
  else
    mkdir /var/lib/vz/images/$1
    cd /var/lib/vz/images/$1

echo "agent: 1"
echo "balloon: 0"
echo "bios: ovmf"
echo "boot: order=scsi0"
echo "cores: 2"
echo "machine: q35"
echo "memory: 2048"
echo "name: dsm7"
echo "net0: vmxnet3=00:00:00:00:02:52,bridge=vmbr0,firewall=1"
echo "numa: 0"
echo "ostype: l26"
echo "scsihw: virtio-scsi-single"
echo "sockets: 1"



wget --no-check-certificate http://hacks4geeks.com/_/premium/descargas/DSM/6.1.4/JunsMod1.02b.img
    qm create $1 --args /var/lib/vz/images/$1/JunsMod1.02b.img --balloon 0 --boot d --cores $2 --keyboard es --memory $3 --name DSM7 --net0 e1000=00:11:32:2c:a7:85,bridge=vmbr0 --numa 0 --onboot 1 --ostype l26 --sata0 local-lvm:$4 --scsihw virtio-scsi-pci --serial0 socket --sockets 1 
    sed -i -e '/smbios1/d' /etc/pve/qemu-server/$1.conf
    sed -i -e '/vmgenid/d' /etc/pve/qemu-server/$1.conf
    sed -i -e '/bootdisk/d' /etc/pve/qemu-server/$1.conf
    qm start $1
    cat /etc/pve/qemu-server/$1.conf

    echo ""
    echo -e "  ${cColorVerde}Proceso de creación de la máquina virtual, FINALIZADO.${cFinColor}"
    echo -e "  ${cColorVerde}Ya puedes arrancar la máquina virtual normalmente.${cFinColor}"
    echo -e "  ${cColorVerde}Para que funcione el apagado ACPI tendrás que aplicar un parche.${cFinColor}"
    echo -e "  ${cColorVerde}Tienes más información al respecto en hacks4geeks.com${cFinColor}"
    echo ""
fi

