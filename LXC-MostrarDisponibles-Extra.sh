#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para mostrar los containers LXC extra disponibles para descargar en ProxmoxVE, fuera del propio PVE
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/LXC-MostrarDisponibles-Extra.sh | bash
#-----------------------------------------------------------------------------------------------------------------------

URLBase="https://uk.lxd.images.canonical.com/images"

## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  curl no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update > /dev/null
     apt-get -y install curl
     echo ""
   fi

## Debian
   curl -s $URLBase/debian/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images > /tmp/lxc-debian.txt
   sed -i -e "s/^/$URLBase/" /tmp/lxc-debian.txt
   echo ""
   cat /tmp/lxc-debian.txt
   echo ""
## Devuan
   curl -s $URLBase/devuan/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images > /tmp/lxc-devuan.txt
   sed -i -e "s/^/$URLBase/" /tmp/lxc-devuan.txt
   echo ""
   cat /tmp/lxc-devuan.txt
   echo ""
## Kali
   curl -s $URLBase/kali/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images > /tmp/lxc-kali.txt
   sed -i -e "s/^/$URLBase/" /tmp/lxc-kali.txt
   echo ""
   cat /tmp/lxc-kali.txt
   echo ""
## OpenWRT
   curl -s $URLBase/openwrt/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images > /tmp/lxc-openwrt.txt
   sed -i -e "s/^/$URLBase/" /tmp/lxc-openwrt.txt
   echo ""
   cat /tmp/lxc-openwrt.txt
   echo ""
## Ubuntu
   curl -s $URLBase/ubuntu/ | sed 's.a href=.\n.g' | sed 's.</a>.\n.g' | grep '/"' | cut -d '"' -f2 | grep -v images > /tmp/lxc-ubuntu.txt
   sed -i -e "s/^/$URLBase/" /tmp/lxc-ubuntu.txt
   echo ""
   cat /tmp/lxc-ubuntu.txt
   echo ""

