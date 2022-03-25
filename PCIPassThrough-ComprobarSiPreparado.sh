#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que te salga de los huevos con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para comprobar si Proxmox está preparado para pasar dispositivos PCI a las máquinas virtuales
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PCIPassThrough-ComprobarSiPreparado.sh | bash
#------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

# Procesador con extensiones de virtualización

echo ""
echo "Extensiones de virtualización:"
echo ""

if [[ $(cat /proc/cpuinfo | grep -o -E "svm|vmx" | head -n1) == "svm" ]]; then
  echo ""
  echo -e "${ColorVerde}  Parece que el equipo tiene un procesador AMD con extensiones de virtualización.${FinColor}"
  echo ""
elif [[ $(cat /proc/cpuinfo | grep -o -E "svm|vmx" | head -n1) == "vmx" ]]; then
  echo ""
  echo -e "${ColorVerde}  Parece que el equipo tiene un procesador Intel con extensiones de virtualización.${FinColor}"
  echo ""
else
  echo ""
  echo -e "${ColorRojo}  El equipo no cuenta con un procesador con extensiones de virtualización.${FinColor}"
  echo -e "${ColorRojo}  NO podrás pasar tarjetas físicas a máquinas virtuales.${FinColor}"
  echo ""
  exit
fi

# Soporte para IOMMU

echo ""
echo "Soporte para IOMMU:"
echo ""

if [[ $(dmesg | grep -e DMAR -e IOMMU | grep ound) != "" ]]; then
  echo ""
  echo -e "${ColorVerde}  Parece que el equipo tiene soporte para IOMMU.${FinColor}"
  echo ""
else
  echo ""
  echo -e "${ColorRojo}  El equipo no tiene soporte IOMMU o no lo has activado en la BIOS.${FinColor}"
  echo -e "${ColorRojo}  NO podrás pasar tarjetas físicas a máquinas virtuales.${FinColor}"
  echo ""
  exit
fi

# Soporte para Interrupt Remapping

echo ""
echo "Interrupt Remapping:"
echo ""

if [[ $(dmesg | grep emapp | grep "remapping") != "" ]];
  then
    echo ""
    echo -e "${ColorVerde}  El equipo tiene soporte para Interrupt Remmaping.${FinColor}"
    echo ""
  else
    echo ""
    echo -e "${ColorRojo}  El equipo NO tiene soporte para Interrupt Remmaping.${FinColor}"
    echo -e "${ColorRojo}  NO podrás pasar tarjetas físicas a máquinas virtuales.${FinColor}"
    echo ""
    exit
fi


# /etc/default/grub

if [[ $(cat /etc/default/grub | grep "_iommu=on") != "" ]];
  then
    echo ""
    echo -e "${ColorVerde}  Parece que has agregado la activación de IOMMU en el archivo /etc/default/grub.${FinColor}"
    echo ""
      if [[ $(cat /etc/default/grub | grep "acs_override") != "" ]];
        then
          echo ""
          echo -e "${ColorVerde}    Parece que has permitido las interrupciones inseguras de Interrupt Remmaping.${FinColor}"
          echo ""
      fi
  else
    echo ""
    echo -e "${ColorRojo}   No has agregado la activación de IOMMU en /etc/default/grub.${FinColor}"
    echo -e "${ColorRojo}   No estás listo para pasar tarjetas PCI a máquinas virtuales.${FinColor}"
    echo ""
    exit
fi

# /etc/modprobe.d/pci-passthrough.conf

if [ -e /etc/modprobe.d/pci-passthrough.conf ];
  then
    echo ""
    echo "  El archivo /etc/modprobe.d/pci-passthrough.conf existe"
    echo ""
    if [[ $(cat /etc/modprobe.d/pci-passthrough.conf | grep unsafe) != "" ]];
      then
        echo ""
        echo "    Parece que has permitido las interrupciones inseguras de Interrupt Remmaping."
        echo ""
    fi
    if [[ $(cat /etc/modprobe.d/pci-passthrough.conf | grep "vfio-pci ids=") != "" ]];
      then
        echo ""
        echo "    Parece que ya has intentado pasar alguna pciid de algún dispositivo."
        echo ""
    fi
  else
    echo ""
    echo -e "${ColorRojo}  El archivo /etc/modprobe.d/pci-passthrough.conf no existe.${FinColor}"
    echo -e "${ColorRojo}  No parece que hayas configurado pci-passthrough en el pasado.${FinColor}"
    echo ""
fi

