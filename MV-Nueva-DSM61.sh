#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que te salga de los huevos con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para crear una máquina virtual para DSM en el MicroServer Gen10
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-Nueva-DSM6.sh | bash -s 255 2 2048 50 local-lvm
# ----------

EXPECTED_ARGS=5
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
    echo -e "CrearMVDSMParaMSGen10 ${ColorArgumentos}[IDDeLaMV] [Núcleos] [RAM] [TamañoDiscoEnGB] [NombreDelAlmacenamiento]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo ""
    echo "CrearMVDSMParaMSGen10 200 2 2048 32 locallvm"
    echo "-------------------------------------------------------------------------"
    echo ""
    exit $E_BADARGS
  else
    # Descargar el Loader
      mkdir /root/Loaders
      cd /root/Loaders
      wget --no-check-certificate http://hacks4geeks.com/_/premium/descargas/DSM/JunsLoader1.03b-DS3615xs.img
    # Crear la MV
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
    # Agregar un disco SATA raw de 50GB
      #qm set $1 --sata0 local:$4
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
    echo -e "  ${ColorArgumentos}Proceso de creación de la máquina virtual, FINALIZADO.${FinColor}"
    echo -e "  ${ColorArgumentos}Ya puedes arrancar la máquina virtual normalmente.${FinColor}"
    echo -e "  ${ColorArgumentos}Para que funcione el apagado ACPI tendrás que aplicar un parche.${FinColor}"
    echo -e "  ${ColorArgumentos}Tienes más información al respecto en hacks4geeks.com${FinColor}"
    echo ""
fi

