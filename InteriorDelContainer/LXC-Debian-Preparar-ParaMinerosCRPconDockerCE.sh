#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar el contenedor LXC de debian para correr mineros CRP con docker
#
# Ejecución remota:
# curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/InteriorDelContainer/LXC-Debian-Preparar-ParaMinerosCRPconDockerCE.sh | bash
# ----------

UtopiaPublicKey=C24C4B77698578B46CDB1C109996B0299984FEE46AAC5CD6025786F5C5C61415

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
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 7 (Wheezy) para correr mineros crp en docker..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 8 (Jessie) para correr mineros crp en docker..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 9 (Stretch) para correr mineros crp en docker..."
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 10 (Buster) para correr mineros crp en docker..."
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 11 (Bullseye) para correr mineros crp en docker..."
  echo ""

  # Actualizar el sistema
     apt-get -y update
     apt-get -y upgrade
     apt-get -y dist-upgrade
     apt-get -y autoremove

  # Instalar paquetes necesarios
     #apt-get -y install ethtool
     #apt-get -y install nload
     #apt-get -y install screen
     #apt-get -y install htop
     #apt-get -y install docker.io

  # Instalar DockerCE
     curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/DockerCE-Instalar.sh | bash

  # Instalar PortainerCE
     curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/DockerCE-InstalarContenedor-PortainerCE.sh | bash

  # Instalar miniupnpd
     echo ""
     echo "  Instalando miniupnpd.."
     echo ""
     echo "  Te hará las siguientes preguntas:"
     echo "    - Iniciar con el sistema? Pon que si"
     echo "    - Red externa: eth0"
     echo "    - Red interna: docker0"
     echo ""
     pause
     apt-get -y install miniupnpd
     sed -i -e 's|After=network-online.target|After=network-online.target docker.service|g' /etc/systemd/system/multi-user.target.wants/miniupnpd.service
     sed -i -e 's|#secure_mode=yes|secure_mode=yes|g'                                       /etc/miniupnpd/miniupnpd.conf
     sed -i -e 's|IPTABLES=$(which iptables)|IPTABLES=$(which iptables-legacy)|g'           /etc/miniupnpd/miniupnpd_functions.sh
     sed -i -e 's|IPTABLES=$(which ip6tables)|IPTABLES=$(which ip6tables-legacy)|g'         /etc/miniupnpd/miniupnpd_functions.sh
     sed -i -e 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g'                           /etc/sysctl.conf

  # Creando el dockerfile
     echo "FROM debian:bullseye-slim"                                                                                                   > /root/DockerFileMineroCRP
     echo "RUN \\"                                                                                                                     >> /root/DockerFileMineroCRP
     echo "  cd /tmp                                                                                                            && \\" >> /root/DockerFileMineroCRP
     echo "  apt-get -y update                                                                                                  && \\" >> /root/DockerFileMineroCRP
     echo "  apt-get -y upgrade                                                                                                 && \\" >> /root/DockerFileMineroCRP
     echo "  apt-get -y dist-upgrade                                                                                            && \\" >> /root/DockerFileMineroCRP
     echo "  apt-get -y install dialog                                                                                          && \\" >> /root/DockerFileMineroCRP
     echo "  apt-get -y install apt-utils                                                                                       && \\" >> /root/DockerFileMineroCRP
     echo "  apt-get -y install wget                                                                                            && \\" >> /root/DockerFileMineroCRP
     echo "  apt-get -y install libglib2.0-0                                                                                    && \\" >> /root/DockerFileMineroCRP
     echo "  apt-get -y install netbase                                                                                         && \\" >> /root/DockerFileMineroCRP
     echo "  wget https://update.u.is/downloads/uam/linux/uam-latest_amd64.deb                                                  && \\" >> /root/DockerFileMineroCRP
     echo "  dpkg -i /tmp/uam-latest_amd64.deb                                                                                  && \\" >> /root/DockerFileMineroCRP
     echo "  echo '"'#!/bin/bash'"'      > /root/ObtenerIPDelMinero.sh                                                          && \\" >> /root/DockerFileMineroCRP
     echo "  echo 'hostname -I' >> /root/ObtenerIPDelMinero.sh                                                                  && \\" >> /root/DockerFileMineroCRP
     echo "  chmod +x              /root/ObtenerIPDelMinero.sh                                                                  && \\" >> /root/DockerFileMineroCRP
     echo "  echo '"'#!/bin/bash'"' > /root/EjecutarMinero.sh                                                                   && \\" >> /root/DockerFileMineroCRP
     echo "  echo 'IPLocalDelMinero='"'$(/root/ObtenerIPDelMinero.sh)'"' >> /root/EjecutarMinero.sh'                                  && \\" >> /root/DockerFileMineroCRP
     echo "  echo '/opt/uam/uam --pk $UtopiaPublicKey --no-ui --http ["'"$IPLocalDelMinero"'"]:8090' >> /root/EjecutarMinero.sh && \\" >> /root/DockerFileMineroCRP
     echo "CMD /root/EjecutarMinero.sh"                                                                                                >> /root/DockerFileMineroCRP
     nano /root/DockerFileMineroCRP

  # Construit la imagen
     docker build -t nipegun:minerocrp - < /root/DockerFileMineroCRP

  # Ejecutar el contenedor
     docker run -d --restart=always --cap-add=IPC_LOCK --name minerocrp1 -v /Host/MineroCRP1:/data nipegun:minerocrp

fi

