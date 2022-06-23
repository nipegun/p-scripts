#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para preparar un container LXC de Debian para natear
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/InteriorDelContainer/LXC-Debian-Preparar-Router-NAT-por-eth1.sh | bash
# ----------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

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
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 7 (Wheezy) para NATear..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 8 (Jessie) para NATear..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 9 (Stretch) para NATear..."
  echo "-----------------------------------------------------------------------------------------"
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
  echo "    iptables -A FORWARD -i eth0 -o eth1 -p icmp -j ACCEPT"                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Reenviar paquetes ICMP desde la interfaz LAN hacia la interfaz WAN"                           >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A FORWARD -i eth1 -o eth0 -p icmp -j ACCEPT"                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "# Crear las reglas de NAT"                                                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Enmascarar bajo la misma IP todo lo que vaya desde la subred de la LAN hacia la interfaz WAN" >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A POSTROUTING -s 10.0.0.0/8 -o eth0 -j MASQUERADE"                                  >> /root/scripts/ReglasIPTablesNAT.sh
  chmod +x /root/scripts/ReglasIPTablesNAT.sh

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 10 (Buster) para NATear..."
  echo "-----------------------------------------------------------------------------------------"
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
  echo "    iptables -A FORWARD -i eth0 -o eth1 -p icmp -j ACCEPT"                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Reenviar paquetes ICMP desde la interfaz LAN hacia la interfaz WAN"                           >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A FORWARD -i eth1 -o eth0 -p icmp -j ACCEPT"                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "# Crear las reglas de NAT"                                                                        >> /root/scripts/ReglasIPTablesNAT.sh
  echo "  # Enmascarar bajo la misma IP todo lo que vaya desde la subred de la LAN hacia la interfaz WAN" >> /root/scripts/ReglasIPTablesNAT.sh
  echo "    iptables -A POSTROUTING -s 10.0.0.0/8 -o eth0 -j MASQUERADE"                                  >> /root/scripts/ReglasIPTablesNAT.sh
  chmod +x /root/scripts/ReglasIPTablesNAT.sh
  /root/scripts/ReglasIPTablesNAT.sh 

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del container de Debian 11 (Bullseye) para NATear..."
  echo "-------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Habilitando el forwarding entre interfaces..."
  echo ""
  cp /etc/sysctl.conf /etc/sysctl.conf.bak
  sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

  # Crear las reglas
    echo "table inet filter {"                                                > /root/ReglasNFTablesNAT.rules
    echo "}"                                                                 >> /root/ReglasNFTablesNAT.rules
    echo ""                                                                  >> /root/ReglasNFTablesNAT.rules
    echo "table ip nat {"                                                    >> /root/ReglasNFTablesNAT.rules
    echo "  chain postrouting {"                                             >> /root/ReglasNFTablesNAT.rules
    echo "    type nat hook postrouting priority 100; policy accept;"        >> /root/ReglasNFTablesNAT.rules
    echo '    oifname "eth0" ip saddr 10.0.0.0/8 counter masquerade'         >> /root/ReglasNFTablesNAT.rules
    echo "  }"                                                               >> /root/ReglasNFTablesNAT.rules
    echo ""                                                                  >> /root/ReglasNFTablesNAT.rules
    echo "  chain prerouting {"                                              >> /root/ReglasNFTablesNAT.rules
    echo "    type nat hook prerouting priority 0; policy accept;"           >> /root/ReglasNFTablesNAT.rules
    echo '    iifname "eth0" tcp dport 20022 counter dnat to 10.0.0.240:22'  >> /root/ReglasNFTablesNAT.rules
    echo '    iifname "eth0" tcp dport 20080 counter dnat to 10.0.0.231:80'  >> /root/ReglasNFTablesNAT.rules
    echo '    iifname "eth0" tcp dport 20443 counter dnat to 10.0.0.231:443' >> /root/ReglasNFTablesNAT.rules
    echo "  }"                                                               >> /root/ReglasNFTablesNAT.rules
    echo "}"                                                                 >> /root/ReglasNFTablesNAT.rules

  # Agregar las reglas al archivo de configuración de NFTables
    sed -i '/^flush ruleset/a include "/root/ReglasNFTablesNAT.rules"' /etc/nftables.conf
    sed -i -e 's|flush ruleset|flush ruleset\n|g' /etc/nftables.conf

  # Recargar las reglas generales de NFTables
    nft --file /etc/nftables.conf

fi

