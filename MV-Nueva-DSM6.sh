#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que te salga de los huevos con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear una máquina virtual para DSM en el MicroServer Gen10
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-Nueva-DSM6.sh | bash -s 255 2 2048 50 local-lvm
# ----------

cCantArgumEsperados=5


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "CrearMVDSMParaMSGen10 ${cColorVerde}[IDDeLaMV] [Núcleos] [RAM] [TamañoDiscoEnGB] [NombreDelAlmacenamiento]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ""
    echo "CrearMVDSMParaMSGen10 200 2 2048 32 locallvm"
    echo "-------------------------------------------------------------------------"
    echo ""
    exit
  else
    # Descargar el Loader
      echo ""
      echo "  Descargando el loader..."
      echo ""
      mkdir /root/Loaders
      cd /root/Loaders
      wget --no-check-certificate http://hacks4geeks.com/_/premium/descargas/DSM/JunsLoader1.03b-DS3615xs.img
    # Crear la MV
      echo ""
      echo "  Creando la máquina virtual..."
      echo ""
      qm create $1 \
      --memory $3 \
      --balloon 0 \
      --sockets 1 \
      --cores $2 \
      --vga none \
      --machine q35 \
      --scsihw virtio-scsi-pci \
      --net0 e1000=00:11:32:2c:a7:85,bridge=vmbr0 \
      --serial0 socket \
      --name DSM6 \
      --ostype l26 \
      --args /root/Loaders/JunsLoader1.03b-DS3615xs.img \
      --keyboard es \
      --boot d \
      --numa 0 \
      --sata0 $5:$4 \
      --onboot 1
      sed -i -e '/smbios1/d' /etc/pve/qemu-server/$1.conf
      sed -i -e '/vmgenid/d' /etc/pve/qemu-server/$1.conf
      sed -i -e '/bootdisk/d' /etc/pve/qemu-server/$1.conf
    # Agregar un segundo disco SATA de 50GB para RAID 1
      #qm set $1 --sata1 $5:$4
    # Iniciar la MV
      echo ""
      echo "  Iniciando la máquina virtual..."
      echo ""
      qm start $1
    # Mostrar el archivo de configuración
      echo ""
      echo "  El archivo de configuración ha quedado así:"
      echo ""
      cat /etc/pve/qemu-server/$1.conf

    echo ""
    echo -e "  ${cColorVerde}Proceso de creación de la máquina virtual, FINALIZADO.${cFinColor}"
    echo -e "  ${cColorVerde}Ya puedes arrancar la máquina virtual normalmente.${cFinColor}"
    echo -e "  ${cColorVerde}Para que funcione el apagado ACPI tendrás que aplicar un parche.${cFinColor}"
    echo -e "  ${cColorVerde}Tienes más información al respecto en hacks4geeks.com${cFinColor}"
    echo ""
fi

