#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar cada versión de ProxmoxVE a la versión inmediatamente siguiente
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Proxmox
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de actualización de ProxmoxVE 3 a ProxmoxVE 4..."
  echo ""

  echo ""
  echo "  Comandos para ProxmoxVE 3 todavía no preparados. Prueba ejecutar el script en otra versión de ProxmoxVE."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de actualización de ProxmoxVE 4 a ProxmoxVE 5..."
  echo ""

  echo ""
  echo "  Comandos para ProxmoxVE 4 todavía no preparados. Prueba ejecutar el script en otra versión de ProxmoxVE."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de actualización de ProxmoxVE 5 a ProxmoxVE 6..."
  echo ""

  echo ""
  echo "  Comandos para ProxmoxVE 5 todavía no preparados. Prueba ejecutar el script en otra versión de ProxmoxVE."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de actualización de ProxmoxVE 6 a ProxmoxVE 7..."
  echo ""

  if [ ! -f "/root/ActPVE6a7.txt" ]; then
    echo ""
    echo "  Actualizando Proxmox 6 a la última versión antes de actualizar a Proxmox 7..."
    echo ""
    apt-get -y update
    apt-get -y dist upgrade
    apt-get -y autoremove
  fi

  echo ""
  echo "  Apagando todas las máquinas virtuales y contenedores..."
  echo ""
  for IdMV in $(seq $MVIni $MVFin);
    do
      echo "  Apagando la máquina virtual $IdMV..."
      qm shutdown $IdMV
    done

  if [ ! -f "/root/ActPVE6a7.txt" ]; then
    echo ""
    echo "  Reiniciando el sistema..."
    echo ""
    touch /root/ActPVE6a7.txt
    shutdown -r now
  fi

  echo ""
  echo "  Modificando repositorios..."
  echo ""
  sed -i -e 's|buster\/updates|bullseye-security|g' /etc/apt/sources.list
  sed -i -e 's|buster|bullseye|g' /etc/apt/sources.list
  sed -i -e 's|buster|bullseye|g' /etc/apt/sources.list.d/pve-enterprise.list
  sed -i -e 's|buster|bullseye|g' /etc/apt/sources.list.d/pve-no-subscription.list
  sed -i -e 's|buster|bullseye|g' /etc/apt/sources.list.d/pve-no-sub.list

  echo ""
  echo "  Actualizando a la versión 7..."
  echo ""
  apt-get -y update
  apt-get -y dist-upgrade

  echo ""
  echo "  Reiniciando el sistema para iniciar en Proxmox 7..."
  echo ""
  shutdown -r now

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de actualización de ProxmoxVE 7 a ProxmoxVE 8..."
  echo ""

  echo ""
  echo "  Comandos para ProxmoxVE 7 todavía no preparados. Prueba ejecutar el script en otra versión de ProxmoxVE."
  echo ""

fi

