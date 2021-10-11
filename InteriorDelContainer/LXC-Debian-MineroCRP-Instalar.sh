#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------------
#  Script de NiPeGun el script para instalar el minero de Utupia en el contenedor LXC de debian standard
#---------------------------------------------------------------------------------------------------------

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
  echo "------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 7 (Wheezy)..."
  echo "------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 7 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 8 (Jessie)..."
  echo "------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 8 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 9 (Stretch)..."
  echo "-------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 9 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 10 (Buster)..."
  echo "-------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 10 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 11 (Bullseye)..."
  echo "---------------------------------------------------------------------------------------------------------"
  echo ""

  if [ ! -f /root/Fase1MineroCRPComp.txt ]
    then
      ## Crear el usuario no-root
         echo ""
         echo "  Ejecutando el comando read..."
         echo ""
         read -p '  Ingresa el nombre de usuario para el usuario no-root y presiona Enter: ' UsuarioNoRoot
         echo ""
         echo -e "${ColorVerde}  Agregando el usuario $UsuarioNoRoot...${FinColor}"
         echo ""
         useradd -d /home/$UsuarioNoRoot/ -s /bin/bash $UsuarioNoRoot
         echo -e "${ColorVerde}  Creando la carpeta del usuario con permisos estándar...${FinColor}"
         echo ""
         mkdir /home/$UsuarioNoRoot/
         chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
         find /home/$UsuarioNoRoot -type d -exec chmod 775 {} \;
         find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;
         echo ""
         echo -e "${ColorVerde}Denegando el acceso a la carpeta /home/$UsuarioNoRoot a los otros usuarios...${FinColor}"
         echo ""
         find /home/$UsuarioNoRoot -type d -exec chmod 750 {} \;
         find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;
      ## Activar auto-logueo del usuario no-root
         #curl --silent https://raw.githubusercontent.com/nipegun/d-scripts/master/Usuarios-AutologuearUsuarioXEnModoTexto-Activar.sh | bash
      ## Instalar el minero CRP
         #curl --silent https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/Cryptos-CRP-Minero-InstalarOActualizar.sh | bash

      ## Activar auto-ejecución del minero al auto-loguearse con el usuario no-root

      ## Indicar que la fase 1 ya se ha completado
         touch /root/Fase1MineroCRPComp.txt
    else

      echo ""
      echo "  Ya se ha ejecutado la instalación del minero de Utopia en este contenedor."
      echo ""
         
  fi
  
fi

