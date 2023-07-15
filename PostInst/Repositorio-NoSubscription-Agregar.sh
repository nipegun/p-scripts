#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft...

# ----------
# Script de NiPeGun para preparar ProxmoxVE para que pueda ser actualizado por no-suscriptores 
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PostInst/Repositorio-NoSubscription-Agregar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
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
  elif [ -f /etc/debian_version ]; then        # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                         # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script que permitirá a los no-suscriptores actualizar ProxmoxVE 3..."
  echo ""

  echo ""
  echo "    Comandos para ProxmoxVE 3 todavía no preparados. Prueba ejecutar el script en otra versión de ProxmoxVE."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script que permitirá a los no-suscriptores actualizar ProxmoxVE 4..."
  echo ""

  echo ""
  echo "    Comandos para ProxmoxVE 4 todavía no preparados. Prueba ejecutar el script en otra versión de ProxmoxVE."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script que permitirá a los no-suscriptores actualizar ProxmoxVE 5..."
  echo ""

  echo ""
  echo -e "${cColorVerde}    Deshabilitando el repositorio Enterprise...${cFinColor}"
  echo ""
  cp /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
  sed -i -e 's|deb https://enterprise.proxmox.com/debian/pve stretch pve-enterprise|# deb https://enterprise.proxmox.com/debian/pve stretch pve-enterprise|g' /etc/apt/sources.list.d/pve-enterprise.list

  echo ""
  echo -e "${cColorVerde}    Agregando el repositorio para no-suscriptores...${cFinColor}"
  echo ""
  echo "deb http://download.proxmox.com/debian/pve stretch pve-no-subscription" > /etc/apt/sources.list.d/pve-no-sub.list

  echo ""
  echo -e "${cColorVerde}    Activando cambios en apt...${cFinColor}"
  echo ""
  apt-get -y update

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script que permitirá a los no-suscriptores actualizar ProxmoxVE 6..."
  echo ""

  echo ""
  echo -e "${cColorVerde}    Deshabilitando el repositorio Enterprise...${cFinColor}"
  echo ""
  cp /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
  sed -i -e 's|deb https://enterprise.proxmox.com/debian/pve buster pve-enterprise|# deb https://enterprise.proxmox.com/debian/pve buster pve-enterprise|g' /etc/apt/sources.list.d/pve-enterprise.list

  echo ""
  echo -e "${cColorVerde}    Agregando el repositorio para no-suscriptores...${cFinColor}"
  echo ""
  echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" > /etc/apt/sources.list.d/pve-no-sub.list

  echo ""
  echo -e "${cColorVerde}    Activando cambios en apt...${cFinColor}"
  echo ""
  apt-get -y update

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script que permitirá a los no-suscriptores actualizar ProxmoxVE 7..."
  echo ""

  echo ""
  echo -e "${cColorVerde}    Deshabilitando el repositorio Enterprise...${cFinColor}"
  echo ""
  cp /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
  sed -i -e 's|deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise|# deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise|g' /etc/apt/sources.list.d/pve-enterprise.list

  echo ""
  echo -e "${cColorVerde}    Agregando el repositorio para no-suscriptores...${cFinColor}"
  echo ""
  echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

  echo ""
  echo -e "${cColorVerde}    Activando cambios en apt...${cFinColor}"
  echo ""
  apt-get -y update

fi

