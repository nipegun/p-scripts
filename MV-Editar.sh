#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para EDITAR EL ARCHIVO DE CONFIGURACIÓN DE UNA VM
# ----------

cCantArgumEsperados=1
E_BADARGS=65

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

FechaDeExp=$(date +A%YM%mD%d@%T)

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "edvm ${cColorVerde}[IDDeLaVM]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo "edvm 101"
    echo "-------------------------------------------------------------------------"
    echo ""
    exit
  else
    nano /etc/pve/qemu-server/$1.conf
fi

