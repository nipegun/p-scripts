#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun el script para instalar el minero de Utupia en el contenedor LXC de debian standard
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
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 9 (Stretch)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 10 (Buster)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script para instalar el minero de Utupia en el contenedor LXC de Debian 11 (Bullseye)..."
  echo ""

  if [ ! -f /root/Fase1MineroCRPComp.txt ]
    then
      # Crear el usuario no-root
         # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo "  dialog no está instalado. Iniciando su instalación..."
              echo ""
              apt-get -y update > /dev/null
              apt-get -y install dialog
              echo ""
            fi
         UsuarioNoRoot=$(dialog --keep-tite --title "Ingresa el nombre para el usuario no-root" --inputbox "Nombre de usuario:" 8 60 3>&1 1>&2 2>&3 3>&- )
         echo -e "${cColorVerde}  Agregando el usuario $UsuarioNoRoot...${cFinColor}"
         echo ""
         useradd -d /home/$UsuarioNoRoot/ -s /bin/bash $UsuarioNoRoot
         echo -e "${cColorVerde}  Creando la carpeta del usuario con permisos estándar...${cFinColor}"
         echo ""
         mkdir /home/$UsuarioNoRoot/
         chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R
         find /home/$UsuarioNoRoot -type d -exec chmod 775 {} \;
         find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;
         echo ""
         echo -e "${cColorVerde}  Denegando el acceso a la carpeta /home/$UsuarioNoRoot a los otros usuarios...${cFinColor}"
         echo ""
         find /home/$UsuarioNoRoot -type d -exec chmod 750 {} \;
         find /home/$UsuarioNoRoot -type f -exec chmod 664 {} \;
      # Instalar el minero CRP
         curl --silent https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/Cryptos-CRP-Minero-InstalarOActualizar.sh | bash
      # Activar auto-logueo del usuario no-root
         #mkdir -p /etc/systemd/system/console-getty.service.d/ 2> /dev/null
         #echo "[Service]"                                                                                           > /etc/systemd/system/console-getty.service.d/override.conf
         #echo "ExecStart="                                                                                         >> /etc/systemd/system/console-getty.service.d/override.conf
         #echo "ExecStart=-/sbin/agetty --noclear --autologin usuariox --keep-baud console 115200,38400,9600 $TERM" >> /etc/systemd/system/console-getty.service.d/override.conf
         #mkdir -p /etc/systemd/system/container-getty@.service.d/ 2> /dev/null
         #echo "[Service]"                                                                                          > /etc/systemd/system/container-getty@.service.d/override.conf
         #echo "ExecStart="                                                                                        >> /etc/systemd/system/container-getty@.service.d/override.conf
         #echo "ExecStart=-/sbin/agetty --noclear --autologin usuariox --keep-baud pts/%I 115200,38400,9600 $TERM" >> /etc/systemd/system/container-getty@.service.d/override.conf
      # Activar auto-ejecución del minero al auto-loguearse con el usuario no-root

      # Indicar que la fase 1 ya se ha completado
         touch /root/Fase1MineroCRPComp.txt
    else

      echo ""
      echo "  Ya se ha ejecutado la instalación del minero de Utopia en este contenedor."
      echo ""

  fi

fi

