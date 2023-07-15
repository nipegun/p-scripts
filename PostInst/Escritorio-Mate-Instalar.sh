#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el escritorio Mate en ProxmoxVE
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PostInst/Escritorio-Mate-Instalar.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  ccColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del escritorio Mate en ProxmoxVE 3..."
  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para ProxmoxVE 3 todavía no preparados. Prueba ejecutar el script en otra versión de ProxmoxVE."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del escritorio Mate en ProxmoxVE 4..."
  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para ProxmoxVE 4 todavía no preparados. Prueba ejecutar el script en otra versión de ProxmoxVE."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del escritorio Mate en ProxmoxVE 5..."
  echo "----------------------------------------------------------------------------"
  echo ""

  tasksel install mate-desktop
  apt-get -y install firefox-esr-l10n-es-es libreoffice-l10n-es
  systemctl disable NetworkManager.service

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del escritorio Mate en ProxmoxVE 6..."
  echo "----------------------------------------------------------------------------"
  echo ""

  apt-get -y update
  apt-get -y install tasksel
  tasksel install mate-desktop
  apt-get -y install caja-open-terminal
  apt-get -y install caja-admin
  apt-get -y install firefox-esr-l10n-es-es
  apt-get -y install libreoffice-l10n-es

  # Permitir caja como root
    mkdir -p /root/.config/autostart/ 2> /dev/null
    echo "[Desktop Entry]"                > /root/.config/autostart/caja.desktop
    echo "Type=Application"              >> /root/.config/autostart/caja.desktop
    echo "Exec=caja --force-desktop"     >> /root/.config/autostart/caja.desktop
    echo "Hidden=false"                  >> /root/.config/autostart/caja.desktop
    echo "X-MATE-Autostart-enabled=true" >> /root/.config/autostart/caja.desktop
    echo "Name[es_ES]=Caja"              >> /root/.config/autostart/caja.desktop
    echo "Name=Caja"                     >> /root/.config/autostart/caja.desktop
    echo "Comment[es_ES]="               >> /root/.config/autostart/caja.desktop
    echo "Comment="                      >> /root/.config/autostart/caja.desktop
    echo "X-MATE-Autostart-Delay=0"      >> /root/.config/autostart/caja.desktop
    gio set /root/.config/autostart/caja.desktop "metadata::trusted" yes

  # Deshabilitar network manager
    echo ""
    echo "  Deshabilitando NetworkManager..."
    echo ""
    systemctl disable NetworkManager.service

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del escritorio Mate en ProxmoxVE 7..."
  echo "----------------------------------------------------------------------------"
  echo ""

  apt-get -y update
  apt-get -y install tasksel
  tasksel install mate-desktop
  apt-get -y install caja-open-terminal
  apt-get -y install caja-admin
  apt-get -y install firefox-esr-l10n-es-es
  apt-get -y install libreoffice-l10n-es

  # Permitir caja como root
    mkdir -p /root/.config/autostart/ 2> /dev/null
    echo "[Desktop Entry]"                > /root/.config/autostart/caja.desktop
    echo "Type=Application"              >> /root/.config/autostart/caja.desktop
    echo "Exec=caja --force-desktop"     >> /root/.config/autostart/caja.desktop
    echo "Hidden=false"                  >> /root/.config/autostart/caja.desktop
    echo "X-MATE-Autostart-enabled=true" >> /root/.config/autostart/caja.desktop
    echo "Name[es_ES]=Caja"              >> /root/.config/autostart/caja.desktop
    echo "Name=Caja"                     >> /root/.config/autostart/caja.desktop
    echo "Comment[es_ES]="               >> /root/.config/autostart/caja.desktop
    echo "Comment="                      >> /root/.config/autostart/caja.desktop
    echo "X-MATE-Autostart-Delay=0"      >> /root/.config/autostart/caja.desktop
    gio set /root/.config/autostart/caja.desktop "metadata::trusted" yes

  # Deshabilitar network manager
    echo ""
    echo "  Deshabilitando NetworkManager..."
    echo ""
    systemctl disable NetworkManager.service

elif [ $OS_VERS == "12" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del escritorio Mate en ProxmoxVE 8..."
  echo "----------------------------------------------------------------------------"
  echo ""

  apt-get -y update
  apt-get -y install tasksel
  tasksel install mate-desktop
  apt-get -y install caja-open-terminal
  apt-get -y install caja-admin
  apt-get -y install firefox-esr-l10n-es-es
  apt-get -y install libreoffice-l10n-es

  # Permitir caja como root
    mkdir -p /root/.config/autostart/ 2> /dev/null
    echo "[Desktop Entry]"                > /root/.config/autostart/caja.desktop
    echo "Type=Application"              >> /root/.config/autostart/caja.desktop
    echo "Exec=caja --force-desktop"     >> /root/.config/autostart/caja.desktop
    echo "Hidden=false"                  >> /root/.config/autostart/caja.desktop
    echo "X-MATE-Autostart-enabled=true" >> /root/.config/autostart/caja.desktop
    echo "Name[es_ES]=Caja"              >> /root/.config/autostart/caja.desktop
    echo "Name=Caja"                     >> /root/.config/autostart/caja.desktop
    echo "Comment[es_ES]="               >> /root/.config/autostart/caja.desktop
    echo "Comment="                      >> /root/.config/autostart/caja.desktop
    echo "X-MATE-Autostart-Delay=0"      >> /root/.config/autostart/caja.desktop
    gio set /root/.config/autostart/caja.desktop "metadata::trusted" yes

  # Deshabilitar network manager
    echo ""
    echo "  Deshabilitando NetworkManager..."
    echo ""
    systemctl disable NetworkManager.service

fi

