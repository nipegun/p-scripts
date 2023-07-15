#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para descargar un container específico en Proxmox
# ----------

cCantArgumEsperados=2

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo "-------------------------------------------------------------------------------"
    echo -e "${cColorRojo}  Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "  $0 ${cColorVerde}[NombreDelArchivoDePlantilla] [AlmacenamientoDeDestino]${cFinColor}"
    echo ""
    echo "  Ejemplo:"
    echo "  $0 debian-10-standard_10.7-1_amd64.tar.gz local"
    echo ""
    echo "  Para ver las plantillas de contenedores disponibles para descargar, ejecuta:"
    echo "  pveam update && pveam available"
    echo ""
    echo "-------------------------------------------------------------------------------"
    echo ""
    exit
  else
    echo ""
    pveam download $2 $1
    echo ""
fi

