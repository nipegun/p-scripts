#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que te salga de los huevos con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------
#  Script de NiPeGun para crear una máquina virtual para DSM en el MicroServer Gen10
#-------------------------------------------------------------------------------------

EXPECTED_ARGS=4
E_BADARGS=65

ColorAdvertencia='\033[1;31m'
ColorArgumentos='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${ColorAdvertencia}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "CrearMVDSMParaMSGen10 ${ColorArgumentos}[IDDeLaMV] [Núcleos] [RAM] [TamañoDiscoEnGB]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo ""
    echo "CrearMVDSMParaMSGen10 200 2 2048 32"
    echo "-------------------------------------------------------------------------"
    echo ""
    exit $E_BADARGS
  else
    mkdir /var/lib/vz/images/$1
    cd /var/lib/vz/images/$1
    wget --no-check-certificate http://hacks4geeks.com/_/premium/descargas/DSM/6.1.4/JunsMod1.02b.img
    qm create $1 --args /var/lib/vz/images/$1/JunsMod1.02b.img --balloon 0 --boot d --cores $2 --keyboard es --memory $3 --name DSM --net0 e1000=00:11:32:2c:a7:85,bridge=vmbr0 --numa 0 --onboot 1 --ostype l26 --sata0 local-lvm:$4 --scsihw virtio-scsi-pci --serial0 socket --sockets 1 
    sed -i -e '/smbios1/d' /etc/pve/qemu-server/$1.conf
    sed -i -e '/vmgenid/d' /etc/pve/qemu-server/$1.conf
    sed -i -e '/bootdisk/d' /etc/pve/qemu-server/$1.conf
    qm start $1
    cat /etc/pve/qemu-server/$1.conf

    echo ""
    echo -e "  ${ColorArgumentos}Proceso de creación de la máquina virtual, FINALIZADO.${FinColor}"
    echo -e "  ${ColorArgumentos}Ya puedes arrancar la máquina virtual normalmente.${FinColor}"
    echo -e "  ${ColorArgumentos}Para que funcione el apagado ACPI tendrás que aplicar un parche.${FinColor}"
    echo -e "  ${ColorArgumentos}Tienes más información al respecto en hacks4geeks.com${FinColor}"
    echo ""
fi

