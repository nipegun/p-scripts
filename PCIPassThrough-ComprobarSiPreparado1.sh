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

  if [[ $(dmesg | grep emapp | grep "emapping") != "" ]];
    then
      echo ""
      echo -e "${ColorVerde}  Parece que el equipo tiene soporte para Interrupt Remmaping.${FinColor}"
      echo ""
    else
      echo ""
      echo -e "${ColorRojo}  El equipo NO tiene soporte para Interrupt Remmaping.${FinColor}"
      echo -e "${ColorRojo}  NO podrás pasar tarjetas físicas a máquinas virtuales.${FinColor}"
      echo ""
      exit
  fi

# Agrupamiento IOMMU

  echo ""
  echo "Agrupamiento IOMMU:"

  echo '#!/bin/bash'                                                                             > /root/MostrarGruposIOMMU.sh
  echo "for iommu_group in \$(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d);" >> /root/MostrarGruposIOMMU.sh
  echo '  do echo "" && echo "Grupo IOMMU $(basename "$iommu_group")";'                         >> /root/MostrarGruposIOMMU.sh
  echo ""                                                                                       >> /root/MostrarGruposIOMMU.sh
  echo 'for device in $(ls -1 "$iommu_group"/devices/);'                                        >> /root/MostrarGruposIOMMU.sh
  echo '  do echo -n $'\t'; lspci -nns "$device"; done; done'                                   >> /root/MostrarGruposIOMMU.sh
  echo ""                                                                                       >> /root/MostrarGruposIOMMU.sh
  echo 'echo ""'                                                                                >> /root/MostrarGruposIOMMU.sh
  chmod +x /root/MostrarGruposIOMMU.sh

  if [[ $(/root/MostrarGruposIOMMU.sh) != "" ]];
    then
      echo ""
      echo -e "${ColorVerde}  Parece que el equipo tiene soporte para agrupamiento IOMMU.${FinColor}"
      echo -e "${ColorVerde}  Tendrás que asegurarte que la tarjeta que quieras pasar esté aislada en su propio grupo.${FinColor}"
      echo ""
    else
      echo ""
      echo -e "${ColorRojo}  El equipo NO tiene soporte para agrupamiento IOMMU Remmaping.${FinColor}"
      echo -e "${ColorRojo}  Probablemente tu procesador no cuente con la característica ACS (Access Control Services).${FinColor}"
      echo -e "${ColorRojo}  NO podrás pasar tarjetas físicas a máquinas virtuales.${FinColor}"
      echo ""
      exit
  fi

# /etc/default/grub

  echo ""
  echo "Archivo /etc/default/grub:"

  if [[ $(cat /etc/default/grub | grep "_iommu=on") != "" ]];
    then
      echo ""
      echo -e "${ColorVerde}  Parece que has agregado la activación de IOMMU en el archivo /etc/default/grub.${FinColor}"
      echo ""
        if [[ $(cat /etc/default/grub | grep "acs_override") != "" ]];
          then
            echo ""
            echo -e "${ColorVerde}    Parece que has permitido las interrupciones inseguras de Interrupt Remmaping en el archivo /etc/default/grub.${FinColor}"
            echo ""
        fi
    else
      echo ""
      echo -e "${ColorRojo}   No has agregado la activación de IOMMU en /etc/default/grub.${FinColor}"
      echo -e "${ColorRojo}   No estás listo para pasar tarjetas PCI a máquinas virtuales.${FinColor}"
      echo ""
      exit
  fi

# /etc/modprobe.d/pcipassthrough.conf

  echo ""
  echo "/etc/modprobe.d/pcipassthrough.conf:"
  
  if [ -e /etc/modprobe.d/pcipassthrough.conf ];
    then
      echo ""
      echo "  El archivo /etc/modprobe.d/pci-passthrough.conf existe"
      echo ""
      if [[ $(cat /etc/modprobe.d/pci-passthrough.conf | grep unsafe) != "" ]];
        then
          echo ""
          echo "    Parece que has permitido las interrupciones inseguras de Interrupt Remmaping en el archivo pci-passthrough.conf."
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
      echo -e "${ColorRojo}  No parece que hayas configurado PCIPassThrough en el pasado.${FinColor}"
      echo ""
  fi

# Módulos necesarios en el archivo /etc/modules

  echo ""
  echo "Módulos necesarios en el archivo /etc/modules:"

  rm -f /tmp/ModulosEnEtcModules.txt
  touch /tmp/ModulosEnEtcModules.txt
  cat /etc/modules | grep "vfio" | sort >> /tmp/ModulosEnEtcModules.txt

  vVFIO1=$(sed -n 1p /tmp/ModulosEnEtcModules.txt)
  vVFIO2=$(sed -n 2p /tmp/ModulosEnEtcModules.txt)
  vVFIO3=$(sed -n 3p /tmp/ModulosEnEtcModules.txt)
  vVFIO4=$(sed -n 4p /tmp/ModulosEnEtcModules.txt)

  if [[ "$vVFIO1" == "vfio" ]] ; then
    echo -e "${ColorVerde}  El módulo $vVFIO1             está agregado a /etc/modules${FinColor}"
    if [[ "$vVFIO2" == "vfio_iommu_type1" ]] ; then
      echo -e "${ColorVerde}  El módulo $vVFIO2 está agregado a /etc/modules${FinColor}"
      if [[ "$vVFIO3" == "vfio_pci" ]] ; then
        echo -e "${ColorVerde}  El módulo $vVFIO3         está agregado a /etc/modules${FinColor}"
        if [[ "$vVFIO4" == "vfio_virqfd" ]] ; then
          echo -e "${ColorVerde}  El módulo $vVFIO4      está agregado a /etc/modules${FinColor}"
        fi
      fi
    fi
  fi

# Módulos vfio efectivamente cargados

  echo ""
  echo "Módulos vfio efectivamente cargados"

  rm -f /tmp/ModulosVFIOCargados.txt
  lsmod | grep ^vfio | cut -d' ' -f1 | sort > /tmp/ModulosVFIOCargados.txt

  vVFIOcar1=$(sed -n 1p /tmp/ModulosVFIOCargados.txt)
  vVFIOcar2=$(sed -n 2p /tmp/ModulosVFIOCargados.txt)
  vVFIOcar3=$(sed -n 3p /tmp/ModulosVFIOCargados.txt)
  vVFIOcar4=$(sed -n 4p /tmp/ModulosVFIOCargados.txt)

  if [[ "$vVFIOcar1" == "vfio" ]] ; then
    echo -e "${ColorVerde}  El módulo $vVFIOcar1             está agregado a /etc/modules${FinColor}"
    if [[ "$vVFIOcar2" == "vfio_iommu_type1" ]] ; then
      echo -e "${ColorVerde}  El módulo $vVFIOcar2 está agregado a /etc/modules${FinColor}"
      if [[ "$vVFIOcar3" == "vfio_pci" ]] ; then
        echo -e "${ColorVerde}  El módulo $vVFIOcar3         está agregado a /etc/modules${FinColor}"
        if [[ "$vVFIOcar4" == "vfio_virqfd" ]] ; then
          echo -e "${ColorVerde}  El módulo $vVFIOcar4      está agregado a /etc/modules${FinColor}"
        fi
      fi
    fi
  fi
 
