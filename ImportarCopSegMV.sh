#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------
#  Script de NiPeGun para importar una copia de seguridad de una MV
#--------------------------------------------------------------------

CantArgsEsperados=2
ArgsInsuficientes=65

ColorAdvertencia='\033[1;31m'
ColorArgumentos='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "${ColorAdvertencia}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${ColorArgumentos}[NombreCompletoDelArchivo] [IDDeLaMV]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo "$0 windowsxp.vma.gz 130"
    echo ""
    echo "Tienes disponibles las siguientes copias de seguridad:"
    echo ""
    ls /var/lib/vz/dump/
    echo ""
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    qmrestore /var/lib/vz/dump/$1 $2
    echo ""
fi
