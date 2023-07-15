#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para importar en Proxmox todas las copias de seguridad de contenedores y máquinas virtuales que haya en una carpeta dada
#
# Ejecución remota:
#    curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-CopSeg-IDs-Importar.sh | bash
# ----------

# Modificar sólo esto antes de ejecutar el script
vCarpetaCopSeg="/CopSegInt/" # La ubicación de la carpeta para las copias debe acabar con /
vArchivoListaLXC="ListaLXC.txt"
vArchivoListaQEMU="ListaQEMU.txt"
vAlmacenamiento="PVE"
#vAlmacenamiento="local-lvm"
#vAlmacenamiento="local"
#vAlmacenamiento="local-btrfs"

vFechaDeEjec=$(date +A%YM%mD%d@%T)

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
ccColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Iniciando importación la de todos los contenedores y máquinas virtuales en la carpeta:${cFinColor}"
echo -e "${cColorAzulClaro}  $vCarpetaCopSeg.${cFinColor}"
echo ""
echo ""

# Abortar script si no existe la carpeta de copias de seguridad
  if [ -d "$vCarpetaCopSeg" ]; then
    echo ""
  else
    echo ""
    echo -e "${cColorRojo}    No se ha encontrado la carpeta de copias de seguridad indicada en el script.${cFinColor}"
    echo -e "${cColorRojo}    Copia de seguridad abortada.${cFinColor}"
    echo ""
    exit 1
  fi

# Obtener lista de contenedores LXC a importar
  echo ""
  echo "  Obteniendo lista de contenedores LXC a importar..."
  echo ""
  find $vCarpetaCopSeg -print -type f -name "*tar.gz" | grep "tar.gz" | grep lxc > $vCarpetaCopSeg$vArchivoListaLXC
  cat $vCarpetaCopSeg$vArchivoListaLXC

# Obtener lista de máquinas virtuales QEMU a importar
  echo ""
  echo "  Obteniendo lista de máquinas virtuales QEMU a importar..."
  echo ""
  find $vCarpetaCopSeg -print -type f -name "*vma.gz" | grep "vma.gz" | grep qemu > $vCarpetaCopSeg$vArchivoListaQEMU
  cat $vCarpetaCopSeg$vArchivoListaQEMU

# Importar los contenedores
  echo ""
  echo "  Importando contenedores LXC..."
  echo ""
  sed -i -e "s|$vCarpetaCopSeg|/root/scripts/p-scripts/LXC-CopiaDeSeguridad-Restaurar.sh $vCarpetaCopSeg|g" $vCarpetaCopSeg$vArchivoListaLXC
  sed -i -e "s|.tar.gz|.tar.gz $vAlmacenamiento|g"                                                          $vCarpetaCopSeg$vArchivoListaLXC
  cat $vCarpetaCopSeg$vArchivoListaLXC
  vContenedores=$(cat $vCarpetaCopSeg$vArchivoListaLXC)
#  for linea in $vContenedores
#    do
#      echo "$linea"
#    done 

# Importar las máquinas virtuales
  echo ""
  echo "  Importando máquinas virtuales QEMU..."
  echo ""
  sed -i -e "s|$vCarpetaCopSeg|/root/scripts/p-scripts/MV-CopiaDeSeguridad-Restaurar.sh $vCarpetaCopSeg|g" $vCarpetaCopSeg$vArchivoListaQEMU
  sed -i -e "s|.vma.gz|.vma.gz $vAlmacenamiento|g"                                                         $vCarpetaCopSeg$vArchivoListaQEMU
  cat $vCarpetaCopSeg$vArchivoListaQEMU
  vMaquinasVirtuales=$(cat $vCarpetaCopSeg$vArchivoListaLXC)
#  for linea in $vMaquinasVirtuales
#    do
#      echo "$linea"
#    done 

