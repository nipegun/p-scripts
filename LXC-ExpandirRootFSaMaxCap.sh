#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -------------------
# Script de NiPeGun para importar una copia de seguridad de contenedor LXC
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/LXC-ExpandirRootFSaMaxCap.sh | bash -s NumContainer
# -------------------

cCantArgumEsperados=1

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cColorAzul='\033[1;34m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo "-------------------------------------------------------------------------------"
    echo -e "${cColorRojo}  Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "  $0 ${cColorVerde}[NumeroDelContainer]${cFinColor}"
    echo ""
    echo "  Ejemplo:"
    echo "  $0 115"
    echo ""
    echo "-------------------------------------------------------------------------------"
    echo ""
    exit
  else

    # Apagar el contenedor
      echo ""
      echo -e "${cColorAzul}  Apagando el contendor...${cFinColor}"
      echo ""
      pct shutdown $1

    # Definir variables
      vNombreAlmacenamiento=$(cat /etc/pve/lxc/$1.conf | grep rootfs | sed 's- --g' | cut -d':' -f2)
      vArchivoDeDisco=$(cat /etc/pve/lxc/$1.conf | grep rootfs | cut -d'/' -f2 | cut -d',' -f1)
      vCarpetaAlmacenamiento=$(cat /etc/pve/storage.cfg | grep -m2 $vNombreAlmacenamiento | tail -n1 | sed 's- --g' | cut -d'h' -f2)

      # echo "vNombreAlmacenamiento = $vNombreAlmacenamiento"
      # echo "vArchivoDeDisco = $vArchivoDeDisco"
      # echo "vCarpetaAlmacenamiento = $vCarpetaAlmacenamiento"

    # Desmontar el disco (Si es que está montado)
      echo ""
      echo -e "${cColorAzul}  Desmontando el disco del contendor (si es que está montado en el host de Proxmox)...${cFinColor}"
      echo ""
      umount "$vCarpetaAlmacenamiento"images/$1/$vArchivoDeDisco

    # Forzar la aceptación de que el disco no está montado
      echo ""
      echo -e "${cColorAzul}  Forzando el bloque MMP a limpio...${cFinColor}"
      echo ""
      tune2fs -f -E clear_mmp "$vCarpetaAlmacenamiento"images/$1/$vArchivoDeDisco

    # Revisar y reparar el sistema de archivos del contenedor
      echo ""
      echo -e "${cColorAzul}  Revisando y reparando el sistema de archivos del contendor...${cFinColor}"
      echo ""
      e2fsck -y -f "$vCarpetaAlmacenamiento"images/$1/$vArchivoDeDisco

    # Realizar la expansión
      echo ""
      echo -e "${cColorAzul}  Efectuando la redimensión...${cFinColor}"
      echo ""
      resize2fs "$vCarpetaAlmacenamiento"images/$1/$vArchivoDeDisco

fi

