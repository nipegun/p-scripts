#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------
#  Script de NiPeGun para customizar el contenedor LXC de debian standard
#--------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 7 (Wheezy)..."
  echo "-------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 7 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 8 (Jessie)..."
  echo "-------------------------------------------------------------------------------"
  echo ""

  

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 9 (Stretch)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 10 (Buster)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 11 (Bullseye)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  if [ ! -f /root/Fase1Comp.txt ]
    then
      curl --silent https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/03-CambiarIdiomaYTecladoAS%C3%B3loEspa%C3%B1ol.sh | bash
      touch /root/Fase1Comp.txt
      shutdown -r now
    else
      curl --silent https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/01-Repositorios-PonerTodos.sh | bash
      curl --silent https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/04-TareasCron-Preparar.sh | bash
      curl --silent https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/05-ComandosPostArranque-Preparar.sh | bash
      echo ""
      #read -p "Ingresa el nombre de usuario para el usuario no-root y presiona Enter: " -s UsuarioNoRoot
      curl --silent https://raw.githubusercontent.com/nipegun/d-scripts/master/UsuarioNuevoConShell.sh | bash -s -- usuariox
  fi
  
fi

