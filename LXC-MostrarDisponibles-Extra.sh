#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------------------------------------------
# Script de NiPeGun para mostrar los containers LXC extra disponibles para descargar en ProxmoxVE, fuera del propio PVE
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/LXC-MostrarDisponibles-Extra.sh | bash
#-----------------------------------------------------------------------------------------------------------------------

URLBase="https://uk.lxd.images.canonical.com/images/"
URLKali="$URLBase"kali/current/amd64/default/

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  curl no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update > /dev/null
     apt-get -y install curl
     echo ""
   fi

# Debian
   # amd64
      curl -sL $URLBase/debian/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images | head -n1 > /tmp/lxc-debian-amd64.txt
      DistDebianBeta=$(cat /tmp/lxc-debian-amd64.txt | cut -d'/' -f1)
      sed -i -e "s|^|debian/|" /tmp/lxc-debian-amd64.txt
      sed -i -e "s|^|$URLBase|" /tmp/lxc-debian-amd64.txt
      sed -i -e "s|$|amd64/default/|" /tmp/lxc-debian-amd64.txt
      VersDebianAMD64=$(curl -sL $(cat /tmp/lxc-debian-amd64.txt) | sed 's/a href=/\n/g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images | sed 's|./||' | tail -n1)
      FechaVersDebianBeta=$(echo $VersDebianAMD64| cut -d '_' -f1 | rev | cut -d'/' -f1 | rev)
      sed -i -e "s|$|$VersDebianAMD64|" /tmp/lxc-debian-amd64.txt
      VersDebianAMD64=$(cat /tmp/lxc-debian-amd64.txt | cut -d '_' -f1 | rev | cut -d'/' -f1 | rev)
      sed -i -e 's/$/rootfs.tar.xz/' /tmp/lxc-debian-amd64.txt
   # arm64
      curl -sL $URLBase/debian/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images > /tmp/lxc-debian-arm64.txt
      sed -i -e "s|^|$URLBase|" /tmp/lxc-debian-arm64.txt
      VersDebianARM64=$(cat /tmp/lxc-debian-arm64.txt | cut -d '_' -f1 | rev | cut -d'/' -f1 | rev)
   echo ""
   echo "  -----------------------------"
   echo "  Contenedores extra de Debian:"
   echo "  -----------------------------"
   echo ""
   echo "  amd64:"
   echo ""
   echo "    debian-amd64-$DistDebianBeta-$FechaVersDebianBeta.tar.xz"
   echo "      Para descargarlo: wget $(cat /tmp/lxc-debian-amd64.txt) -O /tmp/debian-amd64-$DistDebianBeta-$FechaVersDebianBeta.tar.xz"
   echo ""
   echo ""
   #echo "  arm64: $(cat /tmp/lxc-debian-arm64.txt)"
   #echo "    wget $(cat /tmp/lxc-debian-arm64.txt) -O /tmp/debian-$VersDebianARM64-arm64.tar.xz"
   #echo ""

# Devuan
   #curl -sL $URLBase/devuan/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images > /tmp/lxc-devuan.txt
   #sed -i -e "s|^|$URLBase|" /tmp/lxc-devuan.txt
   #echo ""
   #cat /tmp/lxc-devuan.txt
   #echo ""

# Kali
   curl -sL $URLKali | sed 's/a href=/\n/g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images | sed 's|./||' | tail -n1 > /tmp/lxc-kali-amd64.txt
   sed -i -e "s|^|$URLKali|" /tmp/lxc-kali-amd64.txt
   VersKali=$(cat /tmp/lxc-kali-amd64.txt | cut -d '_' -f1 | rev | cut -d'/' -f1 | rev)
   sed -i -e 's/$/rootfs.tar.xz/' /tmp/lxc-kali-amd64.txt
   echo ""
   echo "  ---------------------------"
   echo "  Contenedores extra de Kali:"
   echo "  ---------------------------"
   echo ""
   echo "  amd64:"
   echo ""
   echo "    kali-amd64-$VersKali.tar.xz"
   echo "      Para descargarlo:  wget $(cat /tmp/lxc-kali-amd64.txt) -O /tmp/kali-amd64-$VersKali.tar.xz"
   echo ""

# OpenWRT
   #curl -sL $URLBase/openwrt/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images > /tmp/lxc-openwrt.txt
   #sed -i -e "s|^|$URLBase|" /tmp/lxc-openwrt.txt
   #echo ""
   #cat /tmp/lxc-openwrt.txt
   #echo ""

# Ubuntu
   #curl -sL $URLBase/ubuntu/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images > /tmp/lxc-ubuntu.txt
   #sed -i -e "s|^|$URLBase|" /tmp/lxc-ubuntu.txt
   #echo ""
   #cat /tmp/lxc-ubuntu.txt
   #echo ""

