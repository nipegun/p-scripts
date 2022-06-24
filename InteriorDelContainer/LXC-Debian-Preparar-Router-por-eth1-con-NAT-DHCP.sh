#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para preparar un container LXC de Debian para routear con NAT y DHCP
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/InteriorDelContainer/LXC-Debian-Preparar-Router-por-eth1-con-NAT-DHCP.sh | bash
# ----------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

vIntEth0="eth0"
vIntEth1="eth1"
vRed="192.168.100"

# Determinar la versión de Debian

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
  echo "--------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 7 (Wheezy) para routear con NAT y DHCP..."
  echo "--------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 8 (Jessie) para routear con NAT y DHCP..."
  echo "--------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 9 (Stretch) para routear con NAT y DHCP..."
  echo "---------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Habilitando el forwarding entre interfaces..."
  echo ""
  cp /etc/sysctl.conf /etc/sysctl.conf.bak
  sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

  echo ""
  echo "  Creando las reglas de IPTables..."
  echo ""
  mkdir -p /root/scripts/ 2> /dev/null
  echo '#!/bin/bash'                                                                                       > /root/scripts/ReglasIPTablesNAT.sh
  echo "# Poner todo en DROP"                                                                             >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  iptables -P INPUT DROP"                                                                         >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  iptables -P OUTPUT DROP"                                                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  iptables -P FORWARD DROP"                                                                       >> /root/scripts/ReglasIPTablesNAT.sh
  echo "# Crear las reglas de reenvío"                                                                    >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Reenviar paquetes ICMP desde la interfaz WAN hacia la interfaz LAN"                           >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A FORWARD -i $vIntEth0 -o $vIntEth0 -p icmp -j ACCEPT"                              >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Reenviar paquetes ICMP desde la interfaz LAN hacia la interfaz WAN"                           >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A FORWARD -i $vIntEth1 -o $vIntEth0 -p icmp -j ACCEPT"                              >> /root/scripts/ReglasIPTablesNAT.sh
  echo "# Crear las reglas de NAT"                                                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Enmascarar bajo la misma IP todo lo que vaya desde la subred de la LAN hacia la interfaz WAN" >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A POSTROUTING -s $vRed.0/24 -o $vIntEth0 -j MASQUERADE"                             >> /root/scripts/ReglasIPTablesNAT.sh
  chmod +x /root/scripts/ReglasIPTablesNAT.sh

  # Ejecutar las reglas
  /root/scripts/ReglasIPTablesNAT.sh

  # Agregar las reglas a los ComandosPostArranque
    sed -i -e 's|/root/scripts/ReglasIPTablesNAT.sh||g' /root/scripts/ComandosPostArranque.sh
    echo "/root/scripts/ReglasIPTablesNAT.sh" >>        /root/scripts/ComandosPostArranque.sh

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 10 (Buster) para routear con NAT y DHCP..."
  echo "---------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Habilitando el forwarding entre interfaces..."
  echo ""
  cp /etc/sysctl.conf /etc/sysctl.conf.bak
  sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

  echo ""
  echo "  Creando las reglas de IPTables..."
  echo ""
  mkdir -p /root/scripts/ 2> /dev/null
  echo '#!/bin/bash'                                                                                       > /root/scripts/ReglasIPTablesNAT.sh
  echo "# Poner todo en DROP"                                                                             >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  iptables -P INPUT DROP"                                                                         >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  iptables -P OUTPUT DROP"                                                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  iptables -P FORWARD DROP"                                                                       >> /root/scripts/ReglasIPTablesNAT.sh
  echo "# Crear las reglas de reenvío"                                                                    >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Reenviar paquetes ICMP desde la interfaz WAN hacia la interfaz LAN"                           >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A FORWARD -i $vIntEth0 -o $vIntEth1 -p icmp -j ACCEPT"                              >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Reenviar paquetes ICMP desde la interfaz LAN hacia la interfaz WAN"                           >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A FORWARD -i $vIntEth1 -o $vIntEth0 -p icmp -j ACCEPT"                              >> /root/scripts/ReglasIPTablesNAT.sh
  echo "# Crear las reglas de NAT"                                                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Enmascarar bajo la misma IP todo lo que vaya desde la subred de la LAN hacia la interfaz WAN" >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A POSTROUTING -s $vRed.0/24 -o $vIntEth0 -j MASQUERADE"                             >> /root/scripts/ReglasIPTablesNAT.sh
  chmod +x /root/scripts/ReglasIPTablesNAT.sh

  # Ejecutar las reglas
  /root/scripts/ReglasIPTablesNAT.sh

  # Agregar las reglas a los ComandosPostArranque
    sed -i -e 's|/root/scripts/ReglasIPTablesNAT.sh||g' /root/scripts/ComandosPostArranque.sh
    echo "/root/scripts/ReglasIPTablesNAT.sh" >>        /root/scripts/ComandosPostArranque.sh

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 11 (Bullseye) para routear con NAT y DHCP..."
  echo "-----------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Habilitando el forwarding entre interfaces..."
  echo ""
  cp /etc/sysctl.conf /etc/sysctl.conf.bak
  sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

  # Crear las reglas
    echo "table inet filter {"                                                             > /root/ReglasNFTablesNAT.rules
    echo "}"                                                                              >> /root/ReglasNFTablesNAT.rules
    echo ""                                                                               >> /root/ReglasNFTablesNAT.rules
    echo "table ip nat {"                                                                 >> /root/ReglasNFTablesNAT.rules
    echo "  chain postrouting {"                                                          >> /root/ReglasNFTablesNAT.rules
    echo "    type nat hook postrouting priority 100; policy accept;"                     >> /root/ReglasNFTablesNAT.rules
    echo '    oifname "'"$vIntEth0"'" ip saddr "'"$vRed"'".0/24 counter masquerade'       >> /root/ReglasNFTablesNAT.rules
    echo "  }"                                                                            >> /root/ReglasNFTablesNAT.rules
    echo ""                                                                               >> /root/ReglasNFTablesNAT.rules
    echo "  chain prerouting {"                                                           >> /root/ReglasNFTablesNAT.rules
    echo "    type nat hook prerouting priority 0; policy accept;"                        >> /root/ReglasNFTablesNAT.rules
    echo '    iifname "'"$vIntEth0"'" tcp dport 33892 counter dnat to "'"$vRed"'".2:3389' >> /root/ReglasNFTablesNAT.rules
    echo '    iifname "'"$vIntEth0"'" tcp dport 33893 counter dnat to "'"$vRed"'".3:3389' >> /root/ReglasNFTablesNAT.rules
    echo '    iifname "'"$vIntEth0"'" tcp dport 33894 counter dnat to "'"$vRed"'".4:3389' >> /root/ReglasNFTablesNAT.rules
    echo "  }"                                                                            >> /root/ReglasNFTablesNAT.rules
    echo "}"                                                                              >> /root/ReglasNFTablesNAT.rules

  # Agregar las reglas al archivo de configuración de NFTables
    sed -i '/^flush ruleset/a include "/root/ReglasNFTablesNAT.rules"' /etc/nftables.conf
    sed -i -e 's|flush ruleset|flush ruleset\n|g'                      /etc/nftables.conf

  # Recargar las reglas generales de NFTables
    nft --file /etc/nftables.conf

  # Agregar las reglas a los ComandosPostArranque
    sed -i -e 's|nft --file /etc/nftables.conf||g' /root/scripts/ComandosPostArranque.sh
    echo "nft --file /etc/nftables.conf" >>        /root/scripts/ComandosPostArranque.sh

  # Instalar el servidor DHCP
    echo ""
    echo "  Instalando el servidor DHCP..."
    echo ""
    apt-get -y update && apt-get -y install isc-dhcp-server

    # Indicar la ubicación del archivo de configuración del demonio
      echo ""
      echo "  Indicando la ubicación del archivo de configuración del demonio dhcpd"
      echo "  y la interfaz sobre la que correrá..."
      echo ""
      cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
      echo 'DHCPDv4_CONF=/etc/dhcp/dhcpd.conf'  > /etc/default/isc-dhcp-server
      echo 'INTERFACESv4="$interfazcableada2"' >> /etc/default/isc-dhcp-server
      echo 'INTERFACESv6=""'                   >> /etc/default/isc-dhcp-server

    # Configurar servidor DHCP
      echo ""
      echo "  Configurando el servidor DHCP..."
      echo ""
      cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
      echo "authoritative;"                                  > /etc/dhcp/dhcpd.conf
      echo "subnet $vRed.0 netmask 255.255.255.0 {"         >> /etc/dhcp/dhcpd.conf
      echo "  range $vRed.100 $vRed.199;"                   >> /etc/dhcp/dhcpd.conf
      echo "  option routers $vRed.1;"                      >> /etc/dhcp/dhcpd.conf
      echo "  option domain-name-servers 1.1.1.1, 1.0.0.1;" >> /etc/dhcp/dhcpd.conf
      echo "  default-lease-time 600;"                      >> /etc/dhcp/dhcpd.conf
      echo "  max-lease-time 7200;"                         >> /etc/dhcp/dhcpd.conf
      echo ""                                               >> /etc/dhcp/dhcpd.conf
      echo "  host PrimeraReserva {"                        >> /etc/dhcp/dhcpd.conf
      echo "    hardware ethernet 00:00:00:00:00:01;"       >> /etc/dhcp/dhcpd.conf
      echo "    fixed-address $vRed.10;"                    >> /etc/dhcp/dhcpd.conf
      echo "  }"                                            >> /etc/dhcp/dhcpd.conf
      echo "}"                                              >> /etc/dhcp/dhcpd.conf

    # Descargar archivo de nombres de fabricantes
      echo ""
      echo "  Descargando archivo de nombres de fabricantes..."
      echo ""
      wget -O /usr/local/etc/oui.txt http://standards-oui.ieee.org/oui/oui.txt

fi

