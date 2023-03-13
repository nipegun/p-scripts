#!/bin/bash

# Modificar /etc/default/grub, timeout 1 bios devname y net.ifnames
  sed -i -e 's|GRUB_TIMEOUT.*|GRUB_TIMEOUT="5"|g'                                        /etc/default/grub
  sed -i -e 's|GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"|g' /etc/default/grub
  update-grub

# Modificar etc network interfaces para poner eth0 y hwaddress
  echo "auto lo"                              > /etc/network/interfaces
  echo "iface lo inet loopback"              >> /etc/network/interfaces
  echo ""                                    >> /etc/network/interfaces
  echo "iface eth0 inet manual"              >> /etc/network/interfaces
  echo ""                                    >> /etc/network/interfaces
  echo "auto vmbr0"                          >> /etc/network/interfaces
  echo "iface vmbr0 inet static"             >> /etc/network/interfaces
  echo "  address 192.168.1.200"             >> /etc/network/interfaces
  echo "  netmask 255.255.255.0"             >> /etc/network/interfaces
  echo "  gateway 192.168.1.1"               >> /etc/network/interfaces
  echo "  bridge_ports eth0"                 >> /etc/network/interfaces
  echo "  bridge_stp off"                    >> /etc/network/interfaces
  echo "  bridge_fd 0"                       >> /etc/network/interfaces
  echo "  hwaddress 00:00:00:00:02:00"       >> /etc/network/interfaces

# Reiniciar el sistema
  shutdown -r now
