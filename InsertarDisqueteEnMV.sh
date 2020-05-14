#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------
#  Script de NiPeGun para insertar una imagen de disquete en una MV de ProxmoxVE
#---------------------------------------------------------------------------------

ComandoInicioMV=$(qm showcmd $1)
echo "Para insertar el disquete en la máquina virtual ésta debe primero apagarse."
echo ""
echo "Presiona [S] para insertar el disquete apagando la máquina o [N] para cancelar..."
select sn in "Si" "No"; do
    case $sn in
        Si ) #qm stop $1; #$ComandoInicioMV "-drive file=$2,if=floppy,index=0"; break;;
        No ) exit;;
    esac
done

