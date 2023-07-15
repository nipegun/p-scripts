#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para descargar las últimas versiones de los ISOs más utilizados
#
# Ejecución remota:
#  https://raw.githubusercontent.com/nipegun/p-scripts/master/PostInst/ISOs-Descargar.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
ccColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Proxmox
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
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de ISOs para ProxmoxVE 3...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 3 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de ISOs para ProxmoxVE 4...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 4 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de ISOs para ProxmoxVE 5...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 5 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de ISOs para ProxmoxVE 6...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Proxmox 6 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de descarga de ISOs para ProxmoxVE 7...${cFinColor}"
  echo ""

  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install curl
      echo ""
    fi

  # Descargar última versión de Debian net-inst
    vURLUltDebianNetInst=$(curl -sL google.es)

  # Descargar última versión de Ubuntu
    vURLUltUbuntu=$(curl -sL google.es)

fi

