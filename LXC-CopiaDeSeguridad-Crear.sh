#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ------------
# Script de NiPeGun para importar una copia de seguridad de contenedor LXC
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/LXC-CopiaDeSeguridad-Crear.sh | bash
# ------------

CantArgsEsperados=1
ArgsInsuficientes=65

ColorAdvertencia='\033[1;31m'
ColorArgumentos='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "${ColorAdvertencia}  Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "  script ${ColorArgumentos}[IDDelContainer]${FinColor}"
    echo ""
    echo "  Ejemplo:"
    echo "  script 130" 
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    vzdump $1 --mode stop --compress gzip --tmpdir /var/tmp --dumpdir /var/tmp
    echo ""
    echo "Copia de seguridad del container guardada en /var/tmp"
    echo ""
fi

