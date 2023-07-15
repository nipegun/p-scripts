#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear los alias de los p-scripts
# ----------

ccColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Creando alias para los p-scripts...${cFinColor}"
echo ""

ln -s /root/scripts/p-scripts/PVE-Actualizar.sh                  /root/scripts/p-scripts/Alias/apve
ln -s /root/scripts/p-scripts/PScripts-Sincronizar.sh            /root/scripts/p-scripts/Alias/sinps

echo ""
echo -e "${cColorVerde}    Alias creados. Deberías poder ejecutar los p-scripts escribiendo el nombre de su alias.${cFinColor}"
echo ""

