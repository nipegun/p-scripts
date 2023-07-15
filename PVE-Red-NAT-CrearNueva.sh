#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear una red interna con NAT en Proxmox
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-RedNAT-CrearNueva.sh | bash
# ----------

echo ""                                                                                       >> /etc/network/interfaces
echo "auto vmbr10"                                                                            >> /etc/network/interfaces
echo "  iface vmbr10 inet static"                                                             >> /etc/network/interfaces
echo "  address 192.168.10.1"                                                                 >> /etc/network/interfaces
echo "  netmask 255.255.255.0"                                                                >> /etc/network/interfaces
echo "  bridge_ports none"                                                                    >> /etc/network/interfaces
echo "  bridge_stp off"                                                                       >> /etc/network/interfaces
echo "  bridge_fd 0"                                                                          >> /etc/network/interfaces
echo "  post-up echo 1 > /proc/sys/net/ipv4/ip_forward"                                       >> /etc/network/interfaces
echo "  post-up   iptables -t nat -A POSTROUTING -s '192.168.10.0/24' -o vmbr0 -j MASQUERADE" >> /etc/network/interfaces
echo "  post-down iptables -t nat -D POSTROUTING -s '192.168.10.0/24' -o vmbr0 -j MASQUERADE" >> /etc/network/interfaces
echo "#RedNAT"                                                                                >> /etc/network/interfaces
systemctl restart networking

