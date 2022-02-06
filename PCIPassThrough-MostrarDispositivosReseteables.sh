#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que te salga de los huevos con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para mostrar que dispositivos PCI aceptan ser reseteados
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PCIPassThrough-MostrarDispositivosReseteables.sh | bash
#------------------------------------------------------------------------------------------------------------------------------

for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d)
  do
    echo ""
    echo "Grupo IOMMU nro $(basename "$iommu_group")"

    for device in $(\ls -1 "$iommu_group"/devices/)
      do
        if [[ -e "$iommu_group"/devices/"$device"/reset ]]
          then
            echo -n "$(tput setaf 2)Reseteable$(tput sgr 0)"
          else
            echo -n "$(tput setaf 1)No reseteable$(tput sgr 0)"
        fi
        echo -n $'\t'
        lspci -nns "$device"
    done
  done
  
  
