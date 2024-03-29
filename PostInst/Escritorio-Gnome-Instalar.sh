#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el escritorio Gnome en Proxmox
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PostInst/Escritorio-Gnome-Instalar.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Proxmox
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación y configuración de Gnome para ProxmoxVE 3...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 3 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación y configuración de Gnome para ProxmoxVE 4...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 4 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación y configuración de Gnome para ProxmoxVE 5...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 5 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación y configuración de Gnome para ProxmoxVE 6...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 6 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación y configuración de Gnome para ProxmoxVE 7...${cFinColor}"
  echo ""

  # Actualizar la lista de paquetes
    apt-get -y update

  # Instalar tasksel
    apt-get -y install tasksel

  # Instalar gnome con tasksel
    tasksel install gnome-desktop

  # Instalar paquetes en castellano que no se instalaron por defecto
    apt-get -y install firefox-esr-l10n-es-es
    apt-get -y install libreoffice-l10n-es

  # Permitir iniciar el entorno gráfico como root
    sed -i -e 's|\[security]|\[security]\nAllowRoot=true|g' /etc/gdm3/daemon.conf
    # Comentar la línea que tenga el match pam_succeed_if.so, siempre que no esté previamente comantada
      sed -i -e '/pam_succeed_if.so/s|^#*|#|' /etc/pam.d/gdm-password

  # Deshabilitar network manager
    echo ""
    echo "    Deshabilitando NetworkManager..."
    echo ""
    systemctl disable NetworkManager.service

  echo ""
  echo -e "${cColorVerde}    Escritorio Gnome instalado.${cFinColor}"
  echo -e "${cColorVerde}    Recuerda desactivar el ahorro de energía en todas las cuentas para las que se active el inicie sesión.${cFinColor}"
  echo ""

fi

