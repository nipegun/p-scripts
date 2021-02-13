#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para conectar ProxmoxVE a una ONT de Movistar
#-------------------------------------------------------------------

InterfazCableada1=eth0
InterfazPuente=vmbr0
UsuarioPPPMovistar="adslppp@telefonicanetpa"
ClavePPPMovistar="adslppp"
MacDelRouterMovistar="00:00:00:00:00:00"

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}-------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de conexión de Proxmox a una ONT de Movistar...${FinColor}"
echo -e "${ColorVerde}-------------------------------------------------------------------${FinColor}"
echo ""

echo ""
echo -e "${ColorVerde}Instalando paquetes de red...${FinColor}"
echo ""
apt-get -y update
apt-get -y install vlan pppoe wget

echo ""
echo -e "${ColorVerde}Activando el módulo 8021q para VLANs...${FinColor}"
echo ""
echo 8021q >> /etc/modules

echo ""
echo -e "${ColorVerde}Configurando la interfaz loopback...${FinColor}"
echo ""
echo "auto lo"                   > /etc/network/interfaces
echo "  iface lo inet loopback" >> /etc/network/interfaces
echo ""                         >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la interfaz WAN...${FinColor}"
echo ""
echo "auto $InterfazCableada1"                                                             >> /etc/network/interfaces
echo "  allow-hotplug $InterfazCableada1"                                                  >> /etc/network/interfaces
echo "  iface $InterfazCableada1 inet manual"                                              >> /etc/network/interfaces
echo "  # hwaddress ether $MacDelRouterMovistar # Necesario para evitar futuros problemas" >> /etc/network/interfaces
echo ""                                                                                    >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la conexión PPP...${FinColor}"
echo ""
echo "auto MovistarWAN"                                                                    >> /etc/network/interfaces
echo "  iface MovistarWAN inet ppp"                                                        >> /etc/network/interfaces
echo "  pre-up /bin/ip link set $InterfazCableada1.6 up"                                   >> /etc/network/interfaces
echo "  provider MovistarWAN"                                                              >> /etc/network/interfaces
echo ""                                                                                    >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la vlan de datos (6) y prioridad (1)...${FinColor}"
echo ""
echo "# VLAN de Datos"                                                                                    >> /etc/network/interfaces
echo "auto $InterfazCableada1.6"                                                                          >> /etc/network/interfaces
echo "  iface $InterfazCableada1.6 inet manual"                                                           >> /etc/network/interfaces
echo "  #vlan-raw-device $InterfazCableada1 # Necesario si la vlan se crea con un nombre no convencional" >> /etc/network/interfaces
echo "  metric 1"                                                                                         >> /etc/network/interfaces
echo ""                                                                                                   >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la vlan de televisión (2) y prioridad (4)...${FinColor}"
echo ""
echo "# VLAN de Televisión"                                                                               >> /etc/network/interfaces
echo "auto $InterfazCableada1.2"                                                                          >> /etc/network/interfaces
echo "  iface $InterfazCableada1.2 inet dhcp"                                                             >> /etc/network/interfaces
echo "  #vlan-raw-device $InterfazCableada1 # Necesario si la vlan se crea con un nombre no convencional" >> /etc/network/interfaces
echo "  metric 4"                                                                                         >> /etc/network/interfaces
echo ""                                                                                                   >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la vlan de voz (3) y prioridad (4)...${FinColor}"
echo ""
echo "# VLAN de Telefonía"                                                                                >> /etc/network/interfaces
echo "auto $InterfazCableada1.3"                                                                          >> /etc/network/interfaces
echo "  iface $InterfazCableada1.3 inet dhcp"                                                             >> /etc/network/interfaces
echo "  #vlan-raw-device $InterfazCableada1 # Necesario si la vlan se crea con un nombre no convencional" >> /etc/network/interfaces
echo "  metric 4"                                                                                         >> /etc/network/interfaces
echo ""                                                                                                   >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la interfaz para las MVs...${FinColor}"
echo ""
echo "auto $InterfazPuente"                                                                 >> /etc/network/interfaces
echo "  iface $InterfazPuente inet static"                                                  >> /etc/network/interfaces
echo "  address 192.168.0.1"                                                                >> /etc/network/interfaces
echo "  netmask 255.255.255.0"                                                              >> /etc/network/interfaces
echo "  bridge-ports none"                                                                  >> /etc/network/interfaces
echo "  bridge-stp off"                                                                     >> /etc/network/interfaces
echo "  bridge-fd 0"                                                                        >> /etc/network/interfaces
echo "  post-up   iptables -t nat -A POSTROUTING -s '192.168.0.0/24' -o ppp0 -j MASQUERADE" >> /etc/network/interfaces
echo "  post-down iptables -t nat -D POSTROUTING -s '192.168.0.0/24' -o ppp0 -j MASQUERADE" >> /etc/network/interfaces
echo "  post-up   iptables -t raw -I PREROUTING -i fwbr+ -j CT --zone 1"                    >> /etc/network/interfaces
echo "  post-down iptables -t raw -D PREROUTING -i fwbr+ -j CT --zone 1"                    >> /etc/network/interfaces
echo ""                                                                                     >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Creando el archivo para el proveedor PPPoE...${FinColor}"
echo ""
echo "noipdefault" > /etc/ppp/peers/MovistarWAN
echo "defaultroute" >> /etc/ppp/peers/MovistarWAN
echo "replacedefaultroute" >> /etc/ppp/peers/MovistarWAN
echo "hide-password" >> /etc/ppp/peers/MovistarWAN
echo "#lcp-echo-interval 30" >> /etc/ppp/peers/MovistarWAN
echo "#lcp-echo-failure 4" >> /etc/ppp/peers/MovistarWAN
echo "noauth" >> /etc/ppp/peers/MovistarWAN
echo "persist" >> /etc/ppp/peers/MovistarWAN
echo "#mtu 1492" >> /etc/ppp/peers/MovistarWAN
echo "#maxfail 0" >> /etc/ppp/peers/MovistarWAN
echo "#holdoff 20" >> /etc/ppp/peers/MovistarWAN
echo "plugin rp-pppoe.so" >> /etc/ppp/peers/MovistarWAN
echo "nic-$InterfazCableada1.6" >> /etc/ppp/peers/MovistarWAN
echo 'user "'$UsuarioPPPMovistar'"' >> /etc/ppp/peers/MovistarWAN
echo "usepeerdns" >> /etc/ppp/peers/MovistarWAN

echo "connect /bin/true"                        > /etc/ppp/peers/MovistarWAN
echo "default-asyncmap"                        >> /etc/ppp/peers/MovistarWAN
echo "defaultroute"                            >> /etc/ppp/peers/MovistarWAN
echo "hide-password"                           >> /etc/ppp/peers/MovistarWAN
echo "holdoff 3"                               >> /etc/ppp/peers/MovistarWAN
echo "ipcp-accept-local"                       >> /etc/ppp/peers/MovistarWAN
echo "ipcp-accept-remote"                      >> /etc/ppp/peers/MovistarWAN
echo "lcp-echo-interval 15"                    >> /etc/ppp/peers/MovistarWAN
echo "lcp-echo-failure 3"                      >> /etc/ppp/peers/MovistarWAN
echo "lock"                                    >> /etc/ppp/peers/MovistarWAN
echo "mru 1492"                                >> /etc/ppp/peers/MovistarWAN
echo "mtu 1492"                                >> /etc/ppp/peers/MovistarWAN
echo "noaccomp"                                >> /etc/ppp/peers/MovistarWAN
echo "noauth"                                  >> /etc/ppp/peers/MovistarWAN
echo "nobsdcomp"                               >> /etc/ppp/peers/MovistarWAN
echo "noccp"                                   >> /etc/ppp/peers/MovistarWAN
echo "nodeflate"                               >> /etc/ppp/peers/MovistarWAN
echo "noipdefault"                             >> /etc/ppp/peers/MovistarWAN
echo "nopcomp"                                 >> /etc/ppp/peers/MovistarWAN
echo "novj"                                    >> /etc/ppp/peers/MovistarWAN
echo "novjccomp"                               >> /etc/ppp/peers/MovistarWAN
echo "persist"                                 >> /etc/ppp/peers/MovistarWAN
echo "plugin rp-pppoe.so"                      >> /etc/ppp/peers/MovistarWAN
echo "nic-$InterfazCableada1.6"                >> /etc/ppp/peers/MovistarWAN
echo "updetach"                                >> /etc/ppp/peers/MovistarWAN
echo "usepeerdns"                              >> /etc/ppp/peers/MovistarWAN
echo 'user "'$UsuarioPPPMovistar'"'            >> /etc/ppp/peers/MovistarWAN


echo ""
echo -e "${ColorVerde}Creando el archivo chap-secrets...${FinColor}"
echo ""
echo '"'$UsuarioPPPMovistar'" * "'$ClavePPPMovistar'"' > /etc/ppp/chap-secrets

echo ""
echo -e "${ColorVerde}Agregando datos al archivo pap-secrets...${FinColor}"
echo ""
echo '"'$UsuarioPPPMovistar'" * "'$ClavePPPMovistar'"' >> /etc/ppp/pap-secrets

echo ""
echo -e "${ColorVerde}Habilitando ip-forwarding...${FinColor}"
echo ""
cp /etc/sysctl.conf /etc/sysctl.conf.bak
sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

echo ""
echo -e "${ColorVerde}Agregando la conexión ppp0 a los ComandosPostArranque...${FinColor}"
echo ""
echo "pon MovistarWAN" >> /root/scripts/ComandosPostArranque.sh

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

