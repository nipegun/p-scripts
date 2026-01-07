#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que te salga de los huevos con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear una máquina virtual para DSM en el MicroServer Gen10
# ----------

cCantArgumEsperados=4

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

    # Variables
      vIDDeLaMV="$1"
      vHilos="$2"
      vRAM="$3"
      vAlmacenamiento="local"

    # Crear la máquina virtual
      qm create "$vIDDeLaMV"        \
        --balloon 0                 \
        --bios ovmf                 \
        --boot order=sata0          \
        --cores "$vHilos"           \
        --keyboard es               \
        --machine q35               \
        --memory "$vRAM"            \
        --name DSM7                 \
        --net0 virtio,bridge=vmbr0  \
        --ostype l26                \
        --scsihw virtio-scsi-single \
        --serial0 socket            \
        --sockets 1

    # Descargar el bootloader rr
      # Obtener el tag de la última release del repo rr
        # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
          if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install curl
            echo ""
          fi
        # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
          if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo -e "${cColorRojo}      El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install jq
            echo ""
          fi
        vUltVersRR=$(curl -s https://api.github.com/repos/RROrg/rr/releases/latest | jq -r '.tag_name')
      # Descargar asset
        vURLArchivo=$(curl -sL https://api.github.com/repos/RROrg/rr/releases/tags/"$vUltVersRR" | jq -r '.assets[].browser_download_url' | grep '\.zip$' | grep img)
        wget "$vURLArchivo" -O /tmp/rr.zip
      # Descomprimir archivo
        cd /tmp
        unzip -o /tmp/rr.zip

    # Importar la imagen del bootloader en la máquina virtual
      qm importdisk "$vIDDeLaMV" /tmp/rr.img "$vAlmacenamiento"
      vRutaAlDisco=$(qm config "$vIDDeLaMV" | grep unused | cut -d' ' -f2 | head -n1)
      qm set "$vIDDeLaMV" --sata0 "$vRutaAlDisco",format=raw,cache=writeback

    # Crear el disco para el almacenamiento
      qm set "$vIDDeLaMV" --sata1 "$vAlmacenamiento":50

    # Crear la nota para la máquina virtual
      sed -i '1i#<p>Elige el modelo DS3622xs+</p>' /etc/pve/qemu-server/"$vIDDeLaMV".conf


    echo ""
    echo -e "  ${cColorVerde}Proceso de creación de la máquina virtual, FINALIZADO.${cFinColor}"
    echo -e "  ${cColorVerde}Ya puedes arrancar la máquina virtual normalmente.${cFinColor}"
    echo ""


    #mkdir /var/lib/vz/images/$1
    #cd /var/lib/vz/images/$1

    #echo "agent: 1"
    #echo "balloon: 0"
    #echo "bios: ovmf"
    #echo "boot: order=scsi0"
    #echo "cores: 2"
    #echo "machine: q35"
    #echo "memory: 2048"
    #echo "name: dsm7"
    #echo "net0: vmxnet3=00:00:00:00:02:52,bridge=vmbr0,firewall=1"
    #echo "numa: 0"
    #echo "ostype: l26"
    #echo "scsihw: virtio-scsi-single"
    #echo "sockets: 1"


    #sed -i -e '/smbios1/d' /etc/pve/qemu-server/"$vIDDeLaMV".conf
    #sed -i -e '/vmgenid/d' /etc/pve/qemu-server/"$vIDDeLaMV".conf
    #sed -i -e '/bootdisk/d' /etc/pve/qemu-server/"$vIDDeLaMV".conf
    #qm start $1
    #cat /etc/pve/qemu-server/$1.conf

      #qm create "$vIDDeLaMV" --args /var/lib/vz/images/$1/JunsMod1.02b.img \

fi

