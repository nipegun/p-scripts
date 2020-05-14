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
echo "Presiona x para apagar la máquina virtual e insertar el disquete, o Z para cancelar "
read -p "Presiona Enter para continuar"
