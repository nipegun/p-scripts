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

vMensaje="$1"

# Notificar por Telegram
  vTokenDelBot=$(cat /root/scripts/Telegram/TokenDelBot.txt)
  vIdChat=$(cat /root/scripts/Telegram/IdChat.txt)
  /root/scripts/d-scripts/Telegram-EnviarTexto.sh  "$vTokenDelBot" "$vIdChat" "$vMensaje"


