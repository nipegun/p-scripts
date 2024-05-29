#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para importar una copia de seguridad de contenedor LXC
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/LXC-CopiaDeSeguridad-Restaurar.sh | bash
# ----------

cCantArgumEsperados=3

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${cColorVerde}[RutaAbsolutaAlArchivo] [IDDelNuevoContainer] [Almacenamiento]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo "$0 '/root/copias/vzdump-lxc-777.tar' 130 local-lvm"
    echo "------------------------------------------------------------------------------"
    echo ""
    exit
  else
    echo ""
    pct restore $2 $1 --storage $3
    echo ""
fi

