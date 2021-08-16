#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para preparar el container de Debian Standard
#-------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioNoRoot=NiPeGun

echo ""
echo -e "${ColorVerde}-----------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de preparación del container de Debian...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------------------${FinColor}"
echo ""

## Actualizar
   apt -y update
   apt -y upgrade
   apt -y dist-upgrade
   apt -y autoremove

## Instalar herramientas
   apt -y install mc

## Poner en castellano
   echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen
   locale-gen --purge es_ES.UTF-8
   echo 'LANG="es_ES.UTF-8"' > /etc/default/locale
   echo 'LANGUAGE="es_ES:es"' >> /etc/default/locale

## Reiniciar
   shutdown -r now

