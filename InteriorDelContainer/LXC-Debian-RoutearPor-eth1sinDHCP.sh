#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar xxxxxxxxx en Debian
#
#  Ejecución remota:
#  curl -s x | bash
# ----------


vInterfazFuera="eth0"
vInterfazDentro="eth1"
vSubred="192.168.1"

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
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Configurando la interfaz loopback"
  echo ""
  echo "auto lo"                                                    > /etc/network/interfaces
  echo "  iface lo inet loopback"                                  >> /etc/network/interfaces
  echo "  pre-up iptables-restore < /root/ReglasIPTablesIP4Router" >> /etc/network/interfaces
  echo ""                                                          >> /etc/network/interfaces

  echo ""
  echo "  Configurando la 1ra interfaz ethernet"
  echo ""
  echo "auto $vInterfazFuera"              >> /etc/network/interfaces
  echo "  allow-hotplug $vInterfazFuera"   >> /etc/network/interfaces
  echo "  iface $vInterfazFuera inet dhcp" >> /etc/network/interfaces
  echo ""                                  >> /etc/network/interfaces

  echo ""
  echo "  Configurando la 2da interfaz ethenet"
  echo ""
  echo "auto $vInterfazDentro"                >> /etc/network/interfaces
  echo "  iface $vInterfazDentro inet static" >> /etc/network/interfaces
  echo "  address $vSubred.1"                 >> /etc/network/interfaces
  echo "  network $vSubred.0"                 >> /etc/network/interfaces
  echo "  netmask 255.255.255.0"              >> /etc/network/interfaces
  echo "  broadcast $vSubred.255"             >> /etc/network/interfaces
  echo ""                                     >> /etc/network/interfaces

  echo ""
  echo "  Habilitando el forwarding entre interfaces de red..."
  echo ""
  cp /etc/sysctl.conf /etc/sysctl.conf.bak
  sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

  echo ""
  echo "  Creando las reglas de IPTables..."
  echo ""
  echo "*mangle"                                                                                           > /root/ReglasIPTablesIP4Router
  echo ":PREROUTING ACCEPT [0:0]"                                                                         >> /root/ReglasIPTablesIP4Router
  echo ":INPUT ACCEPT [0:0]"                                                                              >> /root/ReglasIPTablesIP4Router
  echo ":FORWARD ACCEPT [0:0]"                                                                            >> /root/ReglasIPTablesIP4Router
  echo ":OUTPUT ACCEPT [0:0]"                                                                             >> /root/ReglasIPTablesIP4Router
  echo ":POSTROUTING ACCEPT [0:0]"                                                                        >> /root/ReglasIPTablesIP4Router
  echo "COMMIT"                                                                                           >> /root/ReglasIPTablesIP4Router
  echo ""                                                                                                 >> /root/ReglasIPTablesIP4Router
  echo "*nat"                                                                                             >> /root/ReglasIPTablesIP4Router
  echo ":PREROUTING ACCEPT [0:0]"                                                                         >> /root/ReglasIPTablesIP4Router
  echo ":INPUT ACCEPT [0:0]"                                                                              >> /root/ReglasIPTablesIP4Router
  echo ":OUTPUT ACCEPT [0:0]"                                                                             >> /root/ReglasIPTablesIP4Router
  echo ":POSTROUTING ACCEPT [0:0]"                                                                        >> /root/ReglasIPTablesIP4Router
  echo "-A POSTROUTING -o $vInterfazFuera -j MASQUERADE"                                                  >> /root/ReglasIPTablesIP4Router
  echo "COMMIT"                                                                                           >> /root/ReglasIPTablesIP4Router
  echo ""                                                                                                 >> /root/ReglasIPTablesIP4Router
  echo "*filter"                                                                                          >> /root/ReglasIPTablesIP4Router
  echo ":INPUT ACCEPT [0:0]"                                                                              >> /root/ReglasIPTablesIP4Router
  echo ":FORWARD ACCEPT [0:0]"                                                                            >> /root/ReglasIPTablesIP4Router
  echo ":OUTPUT ACCEPT [0:0]"                                                                             >> /root/ReglasIPTablesIP4Router
  echo "-A FORWARD -i $vInterfazFuera -o $vInterfazDentro -m state --state RELATED,ESTABLISHED -j ACCEPT" >> /root/ReglasIPTablesIP4Router
  echo "-A FORWARD -i $vInterfazDentro -o $vInterfazFuera -j ACCEPT"                                      >> /root/ReglasIPTablesIP4Router
  echo "COMMIT"                                                                                           >> /root/ReglasIPTablesIP4Router

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""


  echo ""
  echo "  Configurando la interfaz loopback"
  echo ""
  echo "auto lo"                                                    > /etc/network/interfaces
  echo "  iface lo inet loopback"                                  >> /etc/network/interfaces
  echo "  pre-up iptables-restore < /root/ReglasIPTablesIP4Router" >> /etc/network/interfaces
  echo ""                                                          >> /etc/network/interfaces

  echo ""
  echo "  Configurando la 1ra interfaz ethernet"
  echo ""
  echo "auto $vInterfazFuera"              >> /etc/network/interfaces
  echo "  allow-hotplug $vInterfazFuera"   >> /etc/network/interfaces
  echo "  iface $vInterfazFuera inet dhcp" >> /etc/network/interfaces
  echo ""                                  >> /etc/network/interfaces

  echo ""
  echo "  Configurando la 2da interfaz ethenet"
  echo ""
  echo "auto $vInterfazDentro"                >> /etc/network/interfaces
  echo "  iface $vInterfazDentro inet static" >> /etc/network/interfaces
  echo "  address $vSubred.1"                 >> /etc/network/interfaces
  echo "  network $vSubred.0"                 >> /etc/network/interfaces
  echo "  netmask 255.255.255.0"              >> /etc/network/interfaces
  echo "  broadcast $vSubred.255"             >> /etc/network/interfaces
  echo ""                                     >> /etc/network/interfaces

  echo ""
  echo "  Habilitando el forwarding entre interfaces de red..."
  echo ""
  cp /etc/sysctl.conf /etc/sysctl.conf.bak
  sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf

  echo ""
  echo "  Creando las reglas de IPTables..."
  echo ""
  echo "*mangle"                                                                                           > /root/ReglasIPTablesIP4Router
  echo ":PREROUTING ACCEPT [0:0]"                                                                         >> /root/ReglasIPTablesIP4Router
  echo ":INPUT ACCEPT [0:0]"                                                                              >> /root/ReglasIPTablesIP4Router
  echo ":FORWARD ACCEPT [0:0]"                                                                            >> /root/ReglasIPTablesIP4Router
  echo ":OUTPUT ACCEPT [0:0]"                                                                             >> /root/ReglasIPTablesIP4Router
  echo ":POSTROUTING ACCEPT [0:0]"                                                                        >> /root/ReglasIPTablesIP4Router
  echo "COMMIT"                                                                                           >> /root/ReglasIPTablesIP4Router
  echo ""                                                                                                 >> /root/ReglasIPTablesIP4Router
  echo "*nat"                                                                                             >> /root/ReglasIPTablesIP4Router
  echo ":PREROUTING ACCEPT [0:0]"                                                                         >> /root/ReglasIPTablesIP4Router
  echo ":INPUT ACCEPT [0:0]"                                                                              >> /root/ReglasIPTablesIP4Router
  echo ":OUTPUT ACCEPT [0:0]"                                                                             >> /root/ReglasIPTablesIP4Router
  echo ":POSTROUTING ACCEPT [0:0]"                                                                        >> /root/ReglasIPTablesIP4Router
  echo "-A POSTROUTING -o $vInterfazFuera -j MASQUERADE"                                                  >> /root/ReglasIPTablesIP4Router
  echo "COMMIT"                                                                                           >> /root/ReglasIPTablesIP4Router
  echo ""                                                                                                 >> /root/ReglasIPTablesIP4Router
  echo "*filter"                                                                                          >> /root/ReglasIPTablesIP4Router
  echo ":INPUT ACCEPT [0:0]"                                                                              >> /root/ReglasIPTablesIP4Router
  echo ":FORWARD ACCEPT [0:0]"                                                                            >> /root/ReglasIPTablesIP4Router
  echo ":OUTPUT ACCEPT [0:0]"                                                                             >> /root/ReglasIPTablesIP4Router
  echo "-A FORWARD -i $vInterfazFuera -o $vInterfazDentro -m state --state RELATED,ESTABLISHED -j ACCEPT" >> /root/ReglasIPTablesIP4Router
  echo "-A FORWARD -i $vInterfazDentro -o $vInterfazFuera -j ACCEPT"                                      >> /root/ReglasIPTablesIP4Router
  echo "COMMIT"                                                                                           >> /root/ReglasIPTablesIP4Router

fi

