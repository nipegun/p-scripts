#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------
#  Script de NiPeGun para parchear el OVMF de Clover para que pueda usarse Clover BootLoader
#---------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "$0 ${ColorVerde}Quitar el parche de OVMF para ser utilizado por Clover...${FinColor}"
echo ""

apt-mark unhold pve-edk2-firmware
apt -y install pve-edk2-firmware

