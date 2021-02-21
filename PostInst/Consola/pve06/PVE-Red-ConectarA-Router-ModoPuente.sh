#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------
#  Script de NiPeGun para conectar un servidor con ProxmoxVE a rNormal.shun router normal
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
echo -e "${ColorVerde}Configurando la interfaz loopback...${FinColor}"
echo ""
echo "auto lo"                   > /etc/network/interfaces
echo "  iface lo inet loopback" >> /etc/network/interfaces
echo ""                         >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando el puerto ethernet...${FinColor}"
echo ""
echo "iface $InterfazCableada1 inet manual" >> /etc/network/interfaces
echo ""                                     >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Configurando el puente para las MVs...${FinColor}"
echo ""
echo "auto $InterfazPuente"                >> /etc/network/interfaces
echo "  iface $InterfazPuente inet static" >> /etc/network/interfaces
echo "  address 192.168.0.200"             >> /etc/network/interfaces
echo "  netmask 255.255.255.0"             >> /etc/network/interfaces
echo "  gateway 192.168.0.1"               >> /etc/network/interfaces
echo "  bridge-ports eth0"                 >> /etc/network/interfaces
echo "  bridge-stp off"                    >> /etc/network/interfaces
echo "  bridge-fd 0"                       >> /etc/network/interfaces
echo "  hwaddress ether 00:00:00:00:02:00" >> /etc/network/interfaces
echo ""                                    >> /etc/network/interfaces

echo ""
echo -e "${ColorVerde}Indicando la ubicación del archivo de configuración del demonio dhcpd${FinColor}"
echo -e "${ColorVerde}y la interfaz sobre la que correrá...${FinColor}"
echo ""
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
echo 'DHCPDv4_CONF=/etc/dhcp/dhcpd.conf'  > /etc/default/isc-dhcp-server
echo 'INTERFACESv4="$InterfazPuente"'    >> /etc/default/isc-dhcp-server
echo 'INTERFACESv6=""'                   >> /etc/default/isc-dhcp-server

echo ""
echo -e "${ColorVerde}Configurando el servidor DHCP...${FinColor}"
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
echo -e "${ColorVerde}--------------------------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Ejecución del script de conexión de Proxmox a un router normal, finalizada.${FinColor}"
echo ""
echo -e "${ColorVerde}Ya puedes apagar Proxmox ejecutando:${FinColor}"
echo "shutdown -h now"
echo -e "${ColorVerde}y conectarle el cable ethernet a cualquier puerto LAN del router.${FinColor}"
echo ""
echo -e "${ColorVerde}Después de encenderlo de nuevo, PVE debería tener internet a través de la interfaz $InterfazCableada1${FinColor}"
echo -e "${ColorVerde}--------------------------------------------------------------------------------------------${FinColor}"
echo ""

