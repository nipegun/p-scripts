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
    echo "  El archivo /etc/modprobe.d/pci-passthrough.conf no existe."
    echo "  No parece que hayas configurado pci-passthrough en el pasado."
    echo ""
fi

