#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el servidor DHCP en ProxmoxPVE
#-------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración del servidor DHCP para ProxmoxVE 3..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para ProxmoxVE 3 todavía no preparado. Prueba ejecutarlo en otra versión de Proxmox."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración del servidor DHCP para ProxmoxVE 4..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para ProxmoxVE 4 todavía no preparado. Prueba ejecutarlo en otra versión de Proxmox."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración del servidor DHCP para ProxmoxVE 5..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para ProxmoxVE 5 todavía no preparado. Prueba ejecutarlo en otra versión de Proxmox."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración del servidor DHCP para ProxmoxVE 6..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para ProxmoxVE 6 todavía no preparado. Prueba ejecutarlo en otra versión de Proxmox."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración del servidor DHCP para ProxmoxVE 7..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  apt-get -y install isc-dhcp-server

  ## Crear el archivo de configuración
     cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
     echo "authoritative;"                                 > /etc/dhcp/dhcpd.conf
     echo "  subnet 192.168.1.0 netmask 255.255.255.0 {"  >> /etc/dhcp/dhcpd.conf
     echo "    range 192.168.1.100 192.168.1.199;"        >> /etc/dhcp/dhcpd.conf
     echo "    option routers 192.168.1.1;"               >> /etc/dhcp/dhcpd.conf
     echo "    option domain-name-servers 192.168.1.200;" >> /etc/dhcp/dhcpd.conf
     echo "    default-lease-time 600;"                   >> /etc/dhcp/dhcpd.conf
     echo "    max-lease-time 7200;"                      >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM201 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:01;"    >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.201;"            >> /etc/dhcp/dhcpd.conf
     echo "    }"                                         >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM202 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:02;"    >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.202;"            >> /etc/dhcp/dhcpd.conf
     echo "    }"                                         >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM203 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:03;"    >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.203;"            >> /etc/dhcp/dhcpd.conf
     echo "    }"                                         >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM204 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:04;"    >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.204;"            >> /etc/dhcp/dhcpd.conf
     echo "    }"                                         >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM205 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:05;"    >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.205;"            >> /etc/dhcp/dhcpd.conf
     echo "    }"                                         >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM206 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:06;"    >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.206;"            >> /etc/dhcp/dhcpd.conf
     echo "    }"                                         >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM207 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:07;"    >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.207;"            >> /etc/dhcp/dhcpd.conf
     echo "    }"                                         >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM208 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:08;"    >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.208;"            >> /etc/dhcp/dhcpd.conf
     echo "    }"                                         >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM209 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:09;"    >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.209;"            >> /etc/dhcp/dhcpd.conf
     echo "    }"                                         >> /etc/dhcp/dhcpd.conf
     echo ""                                              >> /etc/dhcp/dhcpd.conf
     echo "    host VM210 {"                              >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:10;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.210;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM211 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:11;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.211;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM212 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:12;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.212;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM213 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:13;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.213;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM214 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:14;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.214;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM215 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:15;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.215;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM216 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:16;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.216;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM217 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:17;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.217;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM218 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:18;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.218;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM219 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:19;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.219;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM220 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:20;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.220;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM221 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:21;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.221;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM222 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:22;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.222;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM223 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:23;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.223;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM224 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:24;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.224;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM225 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:25;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.225;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM226 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:26;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.226;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM227 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:27;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.227;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM228 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:28;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.228;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM229 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:29;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.229;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM230 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:30;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.230;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM231 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:31;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.231;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM232 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:32;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.232;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM233 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:33;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.233;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM234 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:34;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.234;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM235 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:35;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.235;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM236 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:36;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.236;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM237 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:37;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.237;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM238 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:38;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.238;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM239 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:39;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.239;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM240 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:40;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.240;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM241 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:41;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.241;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM242 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:42;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.242;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM243 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:43;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.243;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM244 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:44;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.244;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM245 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:45;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.245;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM246 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:46;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.246;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM247 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:47;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.247;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM248 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:48;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.248;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM249 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:49;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.249;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM250 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:50;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.250;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM251 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:51;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.251;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM252 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:52;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.252;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM253 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:53;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.253;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "    host VM254 {" >> /etc/dhcp/dhcpd.conf
     echo "      hardware ethernet 00:00:00:00:02:54;" >> /etc/dhcp/dhcpd.conf
     echo "      fixed-address 192.168.1.254;" >> /etc/dhcp/dhcpd.conf
     echo "    }" >> /etc/dhcp/dhcpd.conf
     echo "" >> /etc/dhcp/dhcpd.conf
     echo "  }" >> /etc/dhcp/dhcpd.conf

fi
