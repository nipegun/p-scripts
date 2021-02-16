#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para conectar ProxmoxVE a una ONT de Movistar
#-------------------------------------------------------------------

InterfazWAN=eth0
InterfazPuente=vmbr0
UsuarioPPPMovistar="adslppp@telefonicanetpa"
ClavePPPMovistar="adslppp"
IPDeIPTV="2.2.2.2"
MacWANDelRouterMovistar="00:00:00:00:00:00"

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
apt-get -y install vlan pppoe isc-dhcp-server wget

echo ""
echo -e "${ColorVerde}Activando el módulo 8021q para VLANs...${FinColor}"
echo ""
echo 8021q >> /etc/modules

echo ""
echo -e "${ColorVerde}Configurando la interfaz loopback...${FinColor}"
echo ""
echo "# Interfaz LoopBack"       > /etc/network/interfaces
echo "auto lo"                  >> /etc/network/interfaces
echo "  iface lo inet loopback" >> /etc/network/interfaces
echo ""                         >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la interfaz WAN...${FinColor}"
echo ""
echo "# Interfaz WAN"                                                                         >> /etc/network/interfaces
echo "auto $InterfazWAN"                                                                      >> /etc/network/interfaces
echo "  allow-hotplug $InterfazWAN"                                                           >> /etc/network/interfaces
echo "  iface $InterfazWAN inet manual"                                                       >> /etc/network/interfaces
echo "  # hwaddress ether $MacWANDelRouterMovistar # Necesario para evitar futuros problemas" >> /etc/network/interfaces
echo ""                                                                                       >> /etc/network/interfaces                                                                                >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la vlan de datos (6) y prioridad (1)...${FinColor}"
echo ""
echo "# VLAN de Datos"                                                                              >> /etc/network/interfaces
echo "auto $InterfazWAN.6"                                                                          >> /etc/network/interfaces
echo "  iface $InterfazWAN.6 inet manual"                                                           >> /etc/network/interfaces
echo "  #vlan-raw-device $InterfazWAN # Necesario si la vlan se crea con un nombre no convencional" >> /etc/network/interfaces
echo "  metric 1"                                                                                   >> /etc/network/interfaces
echo ""                                                                                             >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la conexión PPP...${FinColor}"
echo ""
echo "# Interfaz PPPoE"                            >> /etc/network/interfaces
echo "auto MovistarWAN"                            >> /etc/network/interfaces
echo "  iface MovistarWAN inet ppp"                >> /etc/network/interfaces
echo "  pre-up /bin/ip link set $InterfazWAN.6 up" >> /etc/network/interfaces
echo "  provider MovistarWAN"                      >> /etc/network/interfaces
echo ""                                            >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la vlan de voz (3) y prioridad (4)...${FinColor}"
echo ""
echo "# VLAN de VoIP"                                                                               >> /etc/network/interfaces
echo "auto $InterfazWAN.3"                                                                          >> /etc/network/interfaces
echo "  iface $InterfazWAN.3 inet dhcp"                                                             >> /etc/network/interfaces
echo "  #vlan-raw-device $InterfazWAN # Necesario si la vlan se crea con un nombre no convencional" >> /etc/network/interfaces
echo "  metric 4"                                                                                   >> /etc/network/interfaces
echo ""                                                                                             >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la vlan de televisión (2) y prioridad (4)...${FinColor}"
echo ""
echo "# VLAN de IPTV"                                                                               >> /etc/network/interfaces
echo "auto $InterfazWAN.2"                                                                          >> /etc/network/interfaces
echo "  iface $InterfazWAN.2 inet static"                                                           >> /etc/network/interfaces
echo "  address $IPDeIPTV"                                                                          >> /etc/network/interfaces
echo "  #vlan-raw-device $InterfazWAN # Necesario si la vlan se crea con un nombre no convencional" >> /etc/network/interfaces
echo "  metric 4"                                                                                   >> /etc/network/interfaces
echo ""                                                                                             >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando la interfaz para las MVs...${FinColor}"
echo ""
echo "auto $InterfazPuente"                                                                 >> /etc/network/interfaces
echo "  iface $InterfazPuente inet static"                                                  >> /etc/network/interfaces
echo "  address 192.168.0.200"                                                              >> /etc/network/interfaces
echo "  netmask 255.255.255.0"                                                              >> /etc/network/interfaces
echo "  bridge-ports none"                                                                  >> /etc/network/interfaces
echo "  bridge-stp off"                                                                     >> /etc/network/interfaces
echo "  bridge-fd 0"                                                                        >> /etc/network/interfaces
echo "  post-up   echo 1 > /proc/sys/net/ipv4/ip_forward"                                   >> /etc/network/interfaces
echo "  post-down echo 0 > /proc/sys/net/ipv4/ip_forward"                                   >> /etc/network/interfaces
echo "  post-up   iptables -t nat -A POSTROUTING -s '192.168.0.0/24' -o ppp0 -j MASQUERADE" >> /etc/network/interfaces
echo "  post-down iptables -t nat -D POSTROUTING -s '192.168.0.0/24' -o ppp0 -j MASQUERADE" >> /etc/network/interfaces
echo "  post-up   iptables -t raw -I PREROUTING -i fwbr+ -j CT --zone 1"                    >> /etc/network/interfaces
echo "  post-down iptables -t raw -D PREROUTING -i fwbr+ -j CT --zone 1"                    >> /etc/network/interfaces
echo ""                                                                                     >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Creando el archivo para el proveedor PPPoE...${FinColor}"
echo ""
echo "connect /bin/true"             > /etc/ppp/peers/MovistarWAN
echo "default-asyncmap"             >> /etc/ppp/peers/MovistarWAN
echo "defaultroute"                 >> /etc/ppp/peers/MovistarWAN
echo "hide-password"                >> /etc/ppp/peers/MovistarWAN
echo "holdoff 3"                    >> /etc/ppp/peers/MovistarWAN
echo "ipcp-accept-local"            >> /etc/ppp/peers/MovistarWAN
echo "ipcp-accept-remote"           >> /etc/ppp/peers/MovistarWAN
echo "lcp-echo-interval 15"         >> /etc/ppp/peers/MovistarWAN
echo "lcp-echo-failure 3"           >> /etc/ppp/peers/MovistarWAN
echo "lock"                         >> /etc/ppp/peers/MovistarWAN
echo "mru 1492"                     >> /etc/ppp/peers/MovistarWAN
echo "mtu 1492"                     >> /etc/ppp/peers/MovistarWAN
echo "noaccomp"                     >> /etc/ppp/peers/MovistarWAN
echo "noauth"                       >> /etc/ppp/peers/MovistarWAN
echo "nobsdcomp"                    >> /etc/ppp/peers/MovistarWAN
echo "noccp"                        >> /etc/ppp/peers/MovistarWAN
echo "nodeflate"                    >> /etc/ppp/peers/MovistarWAN
echo "noipdefault"                  >> /etc/ppp/peers/MovistarWAN
echo "nopcomp"                      >> /etc/ppp/peers/MovistarWAN
echo "novj"                         >> /etc/ppp/peers/MovistarWAN
echo "novjccomp"                    >> /etc/ppp/peers/MovistarWAN
echo "persist"                      >> /etc/ppp/peers/MovistarWAN
echo "plugin rp-pppoe.so"           >> /etc/ppp/peers/MovistarWAN
echo "nic-$InterfazWAN.6"           >> /etc/ppp/peers/MovistarWAN
echo "updetach"                     >> /etc/ppp/peers/MovistarWAN
echo "usepeerdns"                   >> /etc/ppp/peers/MovistarWAN
echo 'user "'$UsuarioPPPMovistar'"' >> /etc/ppp/peers/MovistarWAN

echo ""
echo -e "${ColorVerde}Creando el archivo chap-secrets...${FinColor}"
echo ""
echo '"'$UsuarioPPPMovistar'" * "'$ClavePPPMovistar'"' > /etc/ppp/chap-secrets

echo ""
echo -e "${ColorVerde}Agregando datos al archivo pap-secrets...${FinColor}"
echo ""
echo '"'$UsuarioPPPMovistar'" * "'$ClavePPPMovistar'"' >> /etc/ppp/pap-secrets

echo ""
echo -e "${ColorVerde}Indicando la ubicación del archivo de configuración del demonio dhcpd${FinColor}"
echo -e "${ColorVerde}y la interfaz sobre la que correrá...${FinColor}"
echo ""
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
sed -i -e 's|#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf|DHCPDv4_CONF=/etc/dhcp/dhcpd.conf|g' /etc/default/isc-dhcp-server
sed -i -e 's|INTERFACESv4=""|INTERFACESv4="'$InterfazPuente'"|g'                     /etc/default/isc-dhcp-server

echo ""
echo -e "${ColorVerde}Configurando el servidor DHCP...${FinColor}"
echo ""
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
echo "authoritative;"                                  > /etc/dhcp/dhcpd.conf
echo "subnet 192.168.0.0 netmask 255.255.255.0 {"     >> /etc/dhcp/dhcpd.conf
echo "  range 192.168.0.100 192.168.0.199;"           >> /etc/dhcp/dhcpd.conf
echo "  option routers 192.168.0.200;"                >> /etc/dhcp/dhcpd.conf
echo "  option domain-name-servers 1.1.1.1, 1.0.0.1;" >> /etc/dhcp/dhcpd.conf
echo "  default-lease-time 600;"                      >> /etc/dhcp/dhcpd.conf
echo "  max-lease-time 7200;"                         >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM201 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:01;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.201;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM202 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:02;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.202;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM203 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:03;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.203;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM204 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:04;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.204;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM205 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:05;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.205;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM206 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:06;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.206;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM207 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:07;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.207;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM208 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:08;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.208;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM209 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:09;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.209;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM210 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:10;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.210;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM211 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:11;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.211;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM212 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:12;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.212;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM213 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:13;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.213;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM214 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:14;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.214;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM215 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:15;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.215;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM216 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:16;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.216;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM217 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:17;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.217;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM218 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:18;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.218;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM219 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:19;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.219;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM220 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:20;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.220;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM221 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:21;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.221;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM222 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:22;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.222;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM223 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:23;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.223;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM224 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:24;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.224;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM225 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:25;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.225;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM226 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:26;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.226;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM227 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:27;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.227;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM228 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:28;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.228;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM229 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:29;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.229;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM230 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:30;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.230;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM231 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:31;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.231;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM232 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:32;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.232;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM233 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:33;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.233;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM234 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:34;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.234;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM235 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:35;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.235;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM236 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:36;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.236;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM237 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:37;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.237;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM238 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:38;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.238;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM239 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:39;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.239;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM240 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:40;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.240;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM241 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:41;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.241;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM242 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:42;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.242;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM243 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:43;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.243;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM244 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:44;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.244;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM245 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:45;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.245;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM246 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:46;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.246;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM247 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:47;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.247;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM248 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:48;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.248;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM249 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:49;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.249;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM250 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:50;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.250;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM251 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:51;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.251;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM252 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:52;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.252;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM253 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:53;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.253;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "  host VM254 {"                                 >> /etc/dhcp/dhcpd.conf
echo "    hardware ethernet 00:00:00:00:02:54;"       >> /etc/dhcp/dhcpd.conf
echo "    fixed-address 192.168.0.254;"               >> /etc/dhcp/dhcpd.conf
echo "  }"                                            >> /etc/dhcp/dhcpd.conf
echo ""                                               >> /etc/dhcp/dhcpd.conf
echo "}"                                              >> /etc/dhcp/dhcpd.conf

echo ""
echo -e "${ColorVerde}Descargando archivos de nombres de fabricantes...${FinColor}"
echo ""
wget -O /usr/local/etc/oui.txt http://standards-oui.ieee.org/oui/oui.txt

#echo ""
#echo -e "${ColorVerde}Agregando la conexión ppp0 a los ComandosPostArranque...${FinColor}"
#echo ""
#echo "pon MovistarWAN" >> /root/scripts/ComandosPostArranque.sh

echo ""
echo -e "${ColorVerde}--------------------------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Ejecución del script de conexión de Proxmox a la fibra de Movistar, finalizada.${FinColor}"
echo ""
echo -e "${ColorVerde}Ya puedes apagar Proxmox ejecutando:${FinColor}"
echo "shutdown -h now"
echo -e "${ColorVerde}y conectarle el cable ethernet a la ONT the Movistar.${FinColor}"
echo ""
echo -e "${ColorVerde}Después de encenderlo de nuevo, PVE debería tener internet a través de la interfaz ppp0${FinColor}"
echo -e "${ColorVerde}Si por alguna razón la interfaz ppp0 no se levanta, puedes levantarla manualmente ejecutando:${FinColor}"
echo "pon MovistarWAN"
echo -e "${ColorVerde}--------------------------------------------------------------------------------------------${FinColor}"
echo ""

