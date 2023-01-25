#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para importar en Proxmox todas las copias de seguridad de contenedores y máquinas virtuales que haya en una carpeta dada
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-CopSeg-Ids-Todas-Importar.sh | bash
# ----------

# Modificar sólo esto antes de ejecutar el script
vCarpetaCopSeg="/CopSegInt/" # La ubicación de la carpeta para las copias debe acabar con /
vIdIni=100
vIdFin=99999

vFechaDeEjec=$(date +A%YM%mD%d@%T)

ColorAzul="\033[0;34m"
ColorAzulClaro="\033[1;34m"
ColorVerde='\033[1;32m'
ColorRojo='\033[1;31m'
FinColor='\033[0m'

echo ""
echo -e "${ColorAzulClaro}  Iniciando importación la de todos los contenedores y máquinas virtuales en la carpeta:${FinColor}"
echo -e "${ColorAzulClaro}  $vCarpetaCopSeg.${FinColor}"
echo ""
echo ""

# Abortar script si no existe la carpeta de copias de seguridad
  if [ -d "$vCarpetaCopSeg" ]; then
    echo ""
  else
    echo ""
    echo -e "${ColorRojo}    No se ha encontrado la carpeta de copias de seguridad indicada en el script.${FinColor}"
    echo -e "${ColorRojo}    Copia de seguridad abortada.${FinColor}"
    echo ""
    exit 1
  fi

# Importar los contenedores
  echo ""
  echo "  Importando contenedores LXC..."
  echo ""
  find $vCarpetaCopSeg -print -type f -name "*tar.gz" | grep "tar.gz" | grep lxc

# Importar las máquinas virtuales
  echo ""
  echo "  Importando máquinas virtuales QEMU..."
  echo ""
  find $vCarpetaCopSeg -print -type f -name "*vma.gz" | grep "vma.gz" | grep qemu


