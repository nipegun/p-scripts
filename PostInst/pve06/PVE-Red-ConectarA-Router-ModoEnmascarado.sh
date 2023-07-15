#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para conectar un servidor con ProxmoxVE a un router normal
# ----------

InterfazCableada=eth0
InterfazPuente=vmbr0

cColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${cColorVerde}-----------------------------------------------------------------------------${cFinColor}"
echo -e "${cColorVerde}Iniciando el script de conexión de Proxmox a un router en modo enmascarado...${cFinColor}"
echo -e "${cColorVerde}-----------------------------------------------------------------------------${cFinColor}"
echo ""

echo ""
echo -e "${cColorVerde}Configurando la interfaz loopback...${cFinColor}"
echo ""
echo "auto lo"                   > /etc/network/interfaces
echo "  iface lo inet loopback" >> /etc/network/interfaces
echo ""                         >> /etc/network/interfaces

echo ""
echo -e "${cColorVerde}Configurando el puerto ethernet...${cFinColor}"
echo ""
echo "auto $InterfazCableada"               >> /etc/network/interfaces
echo "iface $InterfazCableada inet dhcp"    >> /etc/network/interfaces
echo "  hwaddress ether 00:00:00:00:02:00"  >> /etc/network/interfaces
echo ""                                     >> /etc/network/interfaces

echo ""
echo -e "${cColorVerde}Configurando el puente para las MVs...${cFinColor}"
echo ""
echo "  iface $InterfazPuente inet static"                                                               >> /etc/network/interfaces
echo "  address 192.168.0.200"                                                                           >> /etc/network/interfaces
echo "  netmask 255.255.255.0"                                                                           >> /etc/network/interfaces
echo "  gateway 192.168.0.1"                                                                             >> /etc/network/interfaces
echo "  bridge-ports none"                                                                               >> /etc/network/interfaces
echo "  bridge-stp off"                                                                                  >> /etc/network/interfaces
echo "  bridge-fd 0"                                                                                     >> /etc/network/interfaces
echo "  post-up   echo 1 > /proc/sys/net/ipv4/ip_forward"                                                >> /etc/network/interfaces
echo "  post-down echo 0 > /proc/sys/net/ipv4/ip_forward"                                                >> /etc/network/interfaces
echo "  post-up   iptables -t nat -A POSTROUTING -s '192.168.0.0/24' -o $InterfazCableada -j MASQUERADE" >> /etc/network/interfaces
echo "  post-down iptables -t nat -D POSTROUTING -s '192.168.0.0/24' -o $InterfazCableada -j MASQUERADE" >> /etc/network/interfaces
echo "  post-up   iptables -t raw -I PREROUTING -i fwbr+ -j CT --zone 1"                                 >> /etc/network/interfaces
echo "  post-down iptables -t raw -D PREROUTING -i fwbr+ -j CT --zone 1"                                 >> /etc/network/interfaces

echo ""
echo -e "${cColorVerde}Indicando la ubicación del archivo de configuración del demonio dhcpd${cFinColor}"
echo -e "${cColorVerde}y la interfaz sobre la que correrá...${cFinColor}"
echo ""
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
echo 'DHCPDv4_CONF=/etc/dhcp/dhcpd.conf'  > /etc/default/isc-dhcp-server
echo 'INTERFACESv4="$InterfazPuente"'    >> /etc/default/isc-dhcp-server
echo 'INTERFACESv6=""'                   >> /etc/default/isc-dhcp-server

echo ""
echo -e "${cColorVerde}Configurando el servidor DHCP...${cFinColor}"
echo ""
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
echo "authoritative;"                                  > /etc/dhcp/dhcpd.conf
echo "subnet 192.168.0.0 netmask 255.255.255.0 {"     >> /etc/dhcp/dhcpd.conf
echo "  range 192.168.0.100 192.168.0.199;"           >> /etc/dhcp/dhcpd.conf
echo "  option routers 192.168.0.1;"                  >> /etc/dhcp/dhcpd.conf
echo "  option domain-name-servers 192.168.0.200;"    >> /etc/dhcp/dhcpd.conf
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
echo -e "${cColorVerde}--------------------------------------------------------------------------------------------${cFinColor}"
echo -e "${cColorVerde}Ejecución del script de conexión de Proxmox a un router normal, finalizada.${cFinColor}"
echo ""
echo -e "${cColorVerde}Ya puedes apagar Proxmox ejecutando:${cFinColor}"
echo "shutdown -h now"
echo -e "${cColorVerde}y conectarle el cable ethernet a cualquier puerto LAN del router.${cFinColor}"
echo ""
echo -e "${cColorVerde}Después de encenderlo de nuevo, PVE debería tener internet a través de la interfaz $InterfazCableada1${cFinColor}"
echo -e "${cColorVerde}--------------------------------------------------------------------------------------------${cFinColor}"
echo ""
