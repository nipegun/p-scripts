#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para importar una copia de seguridad de contenedor LXC
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/LXC-ExpandirPartRootAlMax.sh | bash -s NumContainer
#--------------------------------------------------------------------------------------------------------------------------

CantArgsEsperados=1
ArgsInsuficientes=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo "-------------------------------------------------------------------------------"
    echo -e "${ColorRojo}  Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "  $0 ${ColorVerde}[NumeroDelContainer]${FinColor}"
    echo ""
    echo "  Ejemplo:"
    echo "  $0 115"
    echo ""
    echo "-------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    # Apagar el contenedor
      pct shutdown $1

    # Definir variables
      vNombreAlmacenamiento=$(cat /etc/pve/lxc/$1.conf | grep rootfs | sed 's- --g' | cut -d':' -f2)
      vArchivoDeDisco=$(cat /etc/pve/lxc/$1.conf | grep rootfs | cut -d'/' -f2 | cut -d',' -f1)
      vCarpetaAlmacenamiento=$(cat /etc/pve/storage.cfg | grep -m2 $vNombreAlmacenamiento | tail -n1 | sed 's- --g' | cut -d'h' -f2)

      # echo "vNombreAlmacenamiento = $vNombreAlmacenamiento"
      # echo "vArchivoDeDisco = $vArchivoDeDisco"
      # echo "vCarpetaAlmacenamiento = $vCarpetaAlmacenamiento"

    # Desmontar el disco (Si es que está montado)
      umount $vCarpetaAlmacenamiento\images/$1/$vArchivoDeDisco

    # Forzar la aceptación de que el disco no está montado
      tune2fs -f -E clear_mmp $vCarpetaAlmacenamiento\images/$1/$vArchivoDeDisco

    # Revisar y reparar el sistema de archivos del contenedor
      e2fsck -f $vCarpetaAlmacenamiento\images/$1/$vArchivoDeDisco

    # Realizar la expansión
      resize2fs $vCarpetaAlmacenamiento\images/$1/$vArchivoDeDisco

fi
