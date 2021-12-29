#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para mostrar los containers LXC extra disponibles para descargar en ProxmoxVE, fuera del propio PVE
#
#  Ejecución remota:
#  curl -s | bash
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
   curl -s $URLBase/debian/

## Devuan
   curl -s $URLBase/devuan/

## Kali
   curl -s $URLBase/kali/

## OpenWRT
   curl -s $URLBase/openwrt/

## Ubuntu
   curl -s $URLBase/ubuntu/


