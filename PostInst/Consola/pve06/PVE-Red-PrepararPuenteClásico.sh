#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------
#  Script de NiPeGun para conectar un servidor con ProxmoxVE a un router normal
#--------------------------------------------------------------------------------

InterfazCableada1=eth0
InterfazPuente=vmbr0

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}----------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de conexión de Proxmox a un router normal...${FinColor}"
echo -e "${ColorVerde}----------------------------------------------------------------${FinColor}"
echo ""


echo ""
echo -e "${ColorVerde}Activando el módulo 8021q para VLANs...${FinColor}"
echo ""
sed -i -e 's|echo 8021q|#echo 8021q|g' /etc/modules

echo ""
echo -e "${ColorVerde}Configurando la interfaz loopback...${FinColor}"
echo ""
echo "auto lo"                   > /etc/network/interfaces
echo "  iface lo inet loopback" >> /etc/network/interfaces
echo ""                         >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la interfaz WAN...${FinColor}"
echo ""
echo "iface $InterfazCableada1 inet manual" >> /etc/network/interfaces
echo ""                                     >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la interfaz para las MVs...${FinColor}"
echo ""
echo "auto $InterfazPuente"                >> /etc/network/interfaces
echo "  iface $InterfazPuente inet static" >> /etc/network/interfaces
echo "  address 192.168.0.200"             >> /etc/network/interfaces
echo "  netmask 255.255.255.0"             >> /etc/network/interfaces
echo "  gateway 192.168.0.1"               >> /etc/network/interfaces
echo "  bridge-ports eth0"                 >> /etc/network/interfaces
echo "  bridge-stp off"                    >> /etc/network/interfaces
echo "  bridge-fd 0"                       >> /etc/network/interfaces
echo ""                                    >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Habilitando ip-forwarding...${FinColor}"
echo ""
sed -i -e 's|net.ipv4.ip_forward=1|#net.ipv4.ip_forward=1|g' /etc/sysctl.conf

echo ""
echo -e "${ColorVerde}--------------------------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Ejecución del script de conexión de Proxmox a la fibra de Movistar, finalizada.${FinColor}"
echo ""
echo -e "${ColorVerde}Apagando el dispositivo...${FinColor}"
echo ""
echo -e "${ColorVerde}Si por alguna razónla interfaz ppp0 no se levanta, puedes levantarla manualmente ejecutando:${FinColor}"
echo ""
echo "pon MovistarWAN"
echo -e "${ColorVerde}--------------------------------------------------------------------------------------------${FinColor}"
echo ""
shutdown -h now
