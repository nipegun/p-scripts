#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para insertar una imagen de disquete en una MV de ProxmoxVE
# ----------

cCantArgumEsperados=2


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo "-----------------------------------------------------------------------------------------"
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${cColorVerde}[IDDeLaVM] [ArchivoDeImagen]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ''$0' 206 "/home/pepe/Disquete con datos.ima"'
    echo "-----------------------------------------------------------------------------------------"
    echo ""
    exit
  else
    echo ""
    echo "Para insertar el disquete en la máquina virtual ésta debe primero apagarse."
    echo ""

    echo "¿Quieres insertar el disquete apagando la máquina? (Número + [Enter] para elegir)"
    select yn in "Si" "No";
    do
      case $yn in
        Si ) echo "";
             echo "Insertando disquete y re-arrancando la MV...";
             echo "";
             ComandoInicio=$(qm showcmd $1)
             ComandoAgregado=" -drive 'file=$2,if=floppy,format=raw,index=0'"
             ComandoFinal=$ComandoInicio$ComandoAgregado
             qm stop $1
             $ComandoFinal
             echo ""
             echo "Si la máquina virtual no arranca o lo anterior te dio un eror, copia esta línea:"
             echo ""
             echo $ComandoFinal
             echo ""
             echo "Y ejecútala manualmente."
             echo ""
             echo "NOTA: La imagen de disco se expulsará automáticamente al apagar la MV."
             echo ""
             break;;
        No ) echo "";
             echo "Operación cancelada.";
             echo "";
             exit;;
         * ) echo "";
             echo "Opción incorrecta. Elige 1 o 2.";
             echo "";;
      esac
    done
fi

