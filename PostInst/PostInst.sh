#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar xxxxxxxxx en Proxmox
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PostInst/PostInst.sh | bash
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
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
  echo -e "${vColorAzulClaro}  Iniciando el script de post-instalación para ProxmoxVE 3...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Proxmox 3 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de post-instalación para ProxmoxVE 4...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Proxmox 4 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de post-instalación para ProxmoxVE 5...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Proxmox 5 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de post-instalación para ProxmoxVE 6...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Proxmox 6 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de post-instalación para ProxmoxVE 7...${vFinColor}"
  echo ""

  # Si no existe el archivo /root/Fase1Comp.txt
    if [ ! -f /root/Fase1Comp.txt ]; then

      # Modificar /etc/default/grub, timeout 1 bios devname y net.ifnames
        sed -i -e 's|GRUB_TIMEOUT.*|GRUB_TIMEOUT="5"|g'                                        /etc/default/grub
        sed -i -e 's|GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"|g' /etc/default/grub
        update-grub

      # Modificar etc network interfaces para poner eth0 y hwaddress
        echo "auto lo"                              > /etc/network/interfaces
        echo "iface lo inet loopback"              >> /etc/network/interfaces
        echo ""                                    >> /etc/network/interfaces
        echo "iface eth0 inet manual"              >> /etc/network/interfaces
        echo ""                                    >> /etc/network/interfaces
        echo "auto vmbr0"                          >> /etc/network/interfaces
        echo "iface vmbr0 inet static"             >> /etc/network/interfaces
        echo "  address 192.168.1.200"             >> /etc/network/interfaces
        echo "  netmask 255.255.255.0"             >> /etc/network/interfaces
        echo "  gateway 192.168.1.1"               >> /etc/network/interfaces
        echo "  bridge_ports eth0"                 >> /etc/network/interfaces
        echo "  bridge_stp off"                    >> /etc/network/interfaces
        echo "  bridge_fd 0"                       >> /etc/network/interfaces
        echo "  hwaddress 00:00:00:00:02:00"       >> /etc/network/interfaces

      # Activar IOMMU
        # Determinar si el procesador es Intel o AMD
          vArquitec="x"
        # Modificar /etc/default/grub según arquitectura
          if [ vArquitect == "Intel" ]; then
            sed -i -e 's|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt pcie_acs_override=downstream"|g' /etc/default/grub
          elif [ vArquitect == "AMD" ]; then
            sed -i -e 's|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt pcie_acs_override=downstream"|g' /etc/default/grub
          else
            echo ""
            echo -e "${vColorRojo}    No se pudo activar IOMMU en grub porque no se pudo determinar la arquitectura del procesador.${vFinColor}"
            echo ""
          fi

      # Poner la política de entrada del cortafuegos en ACCEPT y activar el cortafuegos


      # Agregar las reglas de cortafuegos del cluster


      # Crear el archivo de fase 1 completada
        touch /root/Fase1Compt.txt

      # Notificar fin de fase 1
        echo ""
        echo -e "${vColorVerde}    Fase 1 del script completada.${vFinColor}"
        echo -e "${vColorVerde}    La siguiente vez que ejecutes el script se ejecutará la fase 2.${vFinColor}"
        echo ""

      # Reiniciar el sistema
        shutdown -r now

    fi

  # Si no existe el archivo /root/Fase2Comp.txt
    if [ ! -f /root/Fase2Comp.txt ]; then

      # Desactivar repositorio enterprise
        sed -i -e 's|deb.*|#deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise|g' /etc/apt/sources.list.d/pve-enterprise.list

      # Agregar repositorio para no-suscritos
        echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

      # Actualizar lista de paquetes
        apt-get -y update

      # Actualizar a lo último
        apt-get -y dist-upgrade

      # Poner sistema en español
        sed -i 's/^# *\(es_ES.UTF-8\)/\1/' /etc/locale.gen
        locale-gen
        echo -e 'LANG="es_ES.UTF-8"\nLANGUAGE="es_ES:es"\n' > /etc/default/locale

      # Crear el archivo de fase 2 completada
        touch /root/Fase2Comp.txt

      # Notificar fin de fase 2
        echo ""
        echo -e "${vColorVerde}    Fase 2 del script completada.${vFinColor}"
        echo -e "${vColorVerde}    La siguiente vez que ejecutes el script se ejecutará la fase 3.${vFinColor}"
        echo ""

      # Reiniciar el sistema
        shutdown -r now

    fi

  # Si no existe el archivo /root/Fase3Comp.txt
    if [ ! -f /root/Fase3Comp.txt ]; then

      # Instalar curl
        apt-get -y install curl

      # Instalar los p-scripts
        curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PScripts-Sincronizar.sh | bash

      # Instalar los d-scripts
        curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/DScripts-Sincronizar.sh | bash

      # Preparar tareas cron
        curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/TareasCron-Preparar.sh | bash

      # Preparar comandos post arranque
        curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/ComandosPostArranque-Preparar.sh | bash

      # Preparar el cortafuegos
        curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/Cortafuegos-Preparar.sh | bash

      # Quitar mensaje de suscripción
        cp /usr/share/perl5/PVE/API2/Subscription.pm /usr/share/perl5/PVE/API2/Subscription.pm.bak
        sed -i -e 's|status => "NotFound",|status => "Active",|g' /usr/share/perl5/PVE/API2/Subscription.pm

      # Descargar plantillas de contenedores
        curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PostInst/Containers-LXC-Descargar.sh | bash

      # Descargar ISOs más utilizadas
        curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PostInst/ISOs-Descargar.sh | bash

      # Crear el archivo de fase 3 completada
        touch /root/Fase3Comp.txt

      # Notificar fin de fase 3
        echo ""
        echo -e "${vColorVerde}    Fase 3 del script completada.${vFinColor}"
        echo -e "${vColorVerde}    La siguiente vez que ejecutes el script se ejecutará la fase 4.${vFinColor}"
        echo ""

      # Reiniciar el sistema
        shutdown -r now

    fi

  # Si no existe el archivo /root/Fase4Comp.txt
    if [ ! -f /root/Fase4Comp.txt ]; then

      # Instalar el escritorio mate
        curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Escritorio/EscritorioMate-Instalar.sh | bash

      # Personalizar el escritorio mate
        curl

      # Instalar el servidor de escritorio remoto
        apt-get -y install xrdp

      # Evitar que el escritorio de Proxmox se suspenda
        # Desabilitar suspenso e hibernación
          systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
        # Habilitar suspenso e hibernación
          #systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
        # Hacer que Proxmox no se suspensa al cerrar la tapa de un portátil
          echo  "[Login]"                      >> /etc/systemd/logind.conf
          echo  "HandleLidSwitch=ignore"       >> /etc/systemd/logind.conf
          echo  "HandleLidSwitchDocked=ignore" >> /etc/systemd/logind.conf
        # Reiniciar el servicio
          systemctl restart systemd-logind.service

      # Configurar el arranque para modo texto
        curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Interfaz-ModoCLI.sh | bash

      # Crear el usuario de escritorio
        adduser usuariox

      # Crear el archivo de fase 4 completada
        touch /root/Fase4Comp.txt

      # Notificar fin de fase 4
        echo ""
        echo -e "${vColorVerde}    Fase 4 del script completada.${vFinColor}"
        echo -e "${vColorVerde}    La siguiente vez que ejecutes el script se ejecutará la fase 5.${vFinColor}"
        echo ""

      # Reiniciar el sistema
        shutdown -r now

    fi

fi

