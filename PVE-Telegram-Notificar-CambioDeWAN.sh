#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para notificar el cambio de IP WAN de un servidor Proxmox
#
#  Este script no puede ser ejecutado remotamente. Debe ser ejecutado desde los p-scripts.
#
#  El script contempla la existencia de dos archivos en dos rutas específicas:
#    /root/scripts/Telegram/TokenDelBot.txt (Con el token del bot que enviará el mensaje)
#    /root/scripts/Telegram/IdChat.txt      (Con el id del chat al que enviar el mensaje de Telegram)
# ----------

cFechaEjecScript=$(date +a%Ym%md%d@%T)

ccColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Notificando la IP pública del nodo $(hostname)...${cFinColor}"
echo ""

# Guardar la IP pública en una variable
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}   El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install curl
      echo ""
    fi
  vIPWAN=$(curl -sL ifconfig.me)

# Comprobar si la IP WAN cambia
  if [[ $vIPWAN != "" ]]; then
    # Notificar por Telegram
      vTokenDelBot=$(cat /root/scripts/Telegram/TokenDelBot.txt)
      vIdChat=$(cat /root/scripts/Telegram/IdChat.txt)
      vMensaje="$cFechaEjecScript - El nodo $(hostname) ahora tiene salida a Internet a través de la siguiente IP pública: $vIPWAN."
      /root/scripts/d-scripts/Telegram-EnviarTexto.sh  "$vTokenDelBot" "$vIdChat" "$vMensaje"
    # Actualizar este archivo para adaptar a la nueva IP
      sed -i -e 's|$vIPWAN != ""|$vIPWAN != "'"$vIPWAN"'"|g' /root/scripts/p-scripts/PVE-Telegram-Notificar-CambioDeWAN.sh
  fi

