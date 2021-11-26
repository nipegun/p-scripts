#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para re-escribir /etc/network/interfaceds con los nombres antiguos de las interfaces de red
#-----------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Configurando las interfaces de red...${FinColor}"
echo ""
echo "auto lo"                              > /etc/network/interfaces
echo "iface lo inet loopback"              >> /etc/network/interfaces
echo ""                                    >> /etc/network/interfaces
echo "iface eth0 inet manual"              >> /etc/network/interfaces
echo ""                                    >> /etc/network/interfaces
echo "auto vmbr0"                          >> /etc/network/interfaces
echo "iface vmbr0 inet static"             >> /etc/network/interfaces
echo "  address 192.168.1.200"             >> /etc/network/interfaces
echo "  netmask 255.255.255.0"             >> /etc/network/interfaces
echo "  gateway 192.168.1.1"               >> /etc/network/interfaces
echo "  bridge_ports eth0"                 >> /etc/network/interfaces
echo "  bridge_stp off"                    >> /etc/network/interfaces
echo "  bridge_fd 0"                       >> /etc/network/interfaces
echo "  hwaddress ether 00:00:00:00:02:00" >> /etc/network/interfaces

