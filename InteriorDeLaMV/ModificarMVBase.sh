#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------
#  Script de NiPeGun para modificar una MV Base para adaptarla a una nueva MV Clonada
#
#  Este script debe correr dentro de una máquina virtual de ProxmoxVE
#--------------------------------------------------------------------------------------

CantArgsEsperados=2
ArgsInsuficientes=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "  $0 ${ColorVerde}[NombreDeLaNuevaMV] [NombreDelUsuarioNoRoot]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo ""
    echo "  $0 debianpepe pepe"
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    echo -e "${ColorVerde}Cambiando el nombre de la MV a $1...${FinColor}"
    echo ""
    find /bin        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /boot       -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /dev        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /etc        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /home       -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /lib        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /lib64      -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /lost+found -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /media      -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /mnt        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /opt        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /root       -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /run        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /sbin       -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /srv        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /tmp        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /usr        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;
    find /var        -type f -exec sed -i -e "s|DebianBase|$1|g" {} \;

    echo ""
    echo -e "${ColorVerde}Cambiando el nombre y la carpeta del usuario no root...${FinColor}"
    echo ""
    usermod -l $2 usuario
    usermod -d /home/$2 -m $2
    groupmod -n $2 usuario
    echo -e "$2\n$2" | passwd $2
    echo ""
    echo -e "Nuevo nombre: ${ColorVerde}$2${FinColor}"
    echo -e "Nuevo password: ${ColorVerde}$2${FinColor}"

    echo ""
    echo -e "${ColorVerde}Reconfigurando las interfaces de red...${FinColor}"
    echo ""
    echo "auto lo" > /etc/network/interfaces
    echo "  iface lo inet loopback" >> /etc/network/interfaces
    echo "" >> /etc/network/interfaces
    echo "auto eth0" >> /etc/network/interfaces
    echo "  allow-hotplug eth0" >> /etc/network/interfaces
    echo "  iface eth0 inet dhcp" >> /etc/network/interfaces
    echo "" >> /etc/network/interfaces

    echo ""
    echo -e "${ColorVerde}Reseteando SSH...${FinColor}"
    echo ""
    rm /etc/ssh/ssh_host_*
    dpkg-reconfigure openssh-server

    echo ""
    echo -e "${ColorVerde}Poniendo todos los logs a cero...${FinColor}"
    echo ""
    find /var/log/ -type f -exec truncate -s 0 {} \;

    echo ""
    echo -e "${ColorVerde}Borrando el historial de bash...${FinColor}"
    echo ""
    rm /root/.bash_history
    rm /home/$2/.bash_history

    echo ""
    echo -e "${ColorVerde}Reiniciando el sistema...${FinColor}"
    echo ""
    shutdown -r now
fi
