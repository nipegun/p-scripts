#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------
# Script de NiPeGun para activar el reenvio de todo el tráfico DNS hacia la IP de Proxmox
#-------------------------------------------------------------------------------------------

InterfazPuente=vmbr0

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
ColorFin='\033[0m'

# Comprobar si el paquete tcpdump está instalado. Si no está, instalarlo.
if [[ $(dpkg-query -s tcpdump 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "tcpdump no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install tcpdump
fi

echo ""
echo -e "${ColorVerde}...${ColorFin}"
echo ""

tcpdump -i $InterfazPuente port 53

