#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------
#  Script de NiPeGun para insertar una imagen de disquete en una MV de ProxmoxVE
#---------------------------------------------------------------------------------

ComandoInicioMV=$(qm showcmd $1)
echo ""
echo "Para insertar el disquete en la máquina virtual ésta debe primero apagarse."
echo ""

echo "¿Quieres insertar el disquete apagando la máquina?"
select yn in "Si" "No, cancelar"; do
    case $yn in
        Si ) echo "Insertando disquete y reárrancando la MV..."; break;;
        No, cancelar ) exit;;
    esac
done

while true; do
    read -p "Presiona [S] para insertar el disquete apagando la máquina o [N] para cancelar... " yn
    case $yn in
        [Yy]* ) comands; break;;
        [Nn]* ) echo ""; echo "Operación cancelada."; echo ""; exit;;
        * ) echo "Responde S o N";;
    esac
done

