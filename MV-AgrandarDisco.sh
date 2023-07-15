#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para aumentar el tamaño de un disco de una VM
# ----------

cCantArgumEsperados=3

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "AgrandarDiscoVirtual ${cColorVerde}[IDDeLaVM] [PuertoDelDisco] [GigasASumar]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo "AgrandarDiscoVirtual 206 sata1 5"
    echo "-------------------------------------------------------------------------"
    echo ""
    exit
  else
    qm resize $1 $2 +$3G
fi

