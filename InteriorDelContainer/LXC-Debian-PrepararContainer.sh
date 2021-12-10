#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para customizar el contenedor LXC de debian standard
#
# Ejecución remota:
# curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/InteriorDelContainer/LXC-Debian-PrepararContainer.sh | bash
#-------------------------------------------------------------------------------------------------------------------------------

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
  echo "  Script para Debian 7 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 8 (Jessie)..."
  echo "-------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 8 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 9 (Stretch)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 9 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 10 (Buster)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Script para Debian 10 todavía no preparado. Prueba instalarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script para preparar el contenedor LXC de Debian 11 (Bullseye)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  if [ ! -f /root/Fase1Comp.txt ]
    then
      ## Poner que sólo se genere el español de España cuando se creen locales
         echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen
      ## Compilar los locales borrando primero los existentes y dejando nada más que el español de España
         locale-gen --purge es_ES.UTF-8
      ## Modificar el archivo /etc/default/locale reflejando los cambios
         echo 'LANG="es_ES.UTF-8"'   > /etc/default/locale
         echo 'LANGUAGE="es_ES:es"' >> /etc/default/locale
      ## Poner el teclado en español de España
         echo 'XKBMODEL="pc105"'   > /etc/default/keyboard
         echo 'XKBLAYOUT="es"'    >> /etc/default/keyboard
         echo 'XKBVARIANT=""'     >> /etc/default/keyboard
         echo 'XKBOPTIONS=""'     >> /etc/default/keyboard
         echo ''                  >> /etc/default/keyboard
         echo 'BACKSPACE="guess"' >> /etc/default/keyboard
         echo ''                  >> /etc/default/keyboard
      ## Marcar la fase 1
         touch /root/Fase1Comp.txt
      ## Reiniciar sistema
         shutdown -r now
    else
      ## Poner todos los repositorios
         cp /etc/apt/sources.list /etc/apt/sources.list.bak
         echo "deb http://deb.debian.org/debian bullseye main contrib non-free"                         > /etc/apt/sources.list
         echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free"                    >> /etc/apt/sources.list
         echo ""                                                                                       >> /etc/apt/sources.list
         echo "deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free"     >> /etc/apt/sources.list
         echo "deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list
         echo ""                                                                                       >> /etc/apt/sources.list
         echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free"                >> /etc/apt/sources.list
         echo "deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free"            >> /etc/apt/sources.list
         echo ""                                                                                       >> /etc/apt/sources.list
      ## Preparar tareas cron
         echo ""
         echo -e "${ColorVerde}--------------------------------------------------------${FinColor}"
         echo -e "${ColorVerde}  Creando el archivo para las tareas de cada minuto...${FinColor}"
         echo -e "${ColorVerde}--------------------------------------------------------${FinColor}"
         echo ""
         mkdir -p /root/scripts/ 2> /dev/null
         echo '#!/bin/bash'                                                                                                > /root/scripts/TareasCronCadaMinuto.sh
         echo ""                                                                                                          >> /root/scripts/TareasCronCadaMinuto.sh
         echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                       >> /root/scripts/TareasCronCadaMinuto.sh
         echo 'echo "Iniciada la ejecución del cron de cada minuto el $FechaDeEjec" >> /var/log/TareasCronCadaMinuto.log' >> /root/scripts/TareasCronCadaMinuto.sh
         echo ""                                                                                                          >> /root/scripts/TareasCronCadaMinuto.sh
         echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MINUTO"                                        >> /root/scripts/TareasCronCadaMinuto.sh
         echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                      >> /root/scripts/TareasCronCadaMinuto.sh
         echo ""                                                                                                          >> /root/scripts/TareasCronCadaMinuto.sh
         echo ""
         echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
         echo ""
         chmod +x /root/scripts/TareasCronCadaMinuto.sh
         echo ""
         echo -e "${ColorVerde}Instalando la tarea en crontab...${FinColor}"
         echo ""
         crontab -l > /tmp/CronTemporal
         echo "* * * * * /root/scripts/TareasCronCadaMinuto.sh" >> /tmp/CronTemporal
         crontab /tmp/CronTemporal
         rm /tmp/CronTemporal
         echo ""
         echo -e "${ColorVerde}------------------------------------------------------${FinColor}"
         echo -e "${ColorVerde}  Creando el archivo para las tareas de cada hora...${FinColor}"
         echo -e "${ColorVerde}------------------------------------------------------${FinColor}"
         echo ""
         mkdir -p /root/scripts/ 2> /dev/null
         echo '#!/bin/bash'                                                                                            > /root/scripts/TareasCronCadaHora.sh
         echo ""                                                                                                      >> /root/scripts/TareasCronCadaHora.sh
         echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                   >> /root/scripts/TareasCronCadaHora.sh
         echo 'echo "Iniciada la ejecución del cron de cada hora el $FechaDeEjec" >> /var/log/TareasCronCadaHora.log' >> /root/scripts/TareasCronCadaHora.sh
         echo ""                                                                                                      >> /root/scripts/TareasCronCadaHora.sh
         echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA"                                      >> /root/scripts/TareasCronCadaHora.sh
         echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                    >> /root/scripts/TareasCronCadaHora.sh
         echo ""                                                                                                      >> /root/scripts/TareasCronCadaHora.sh
         echo ""
         echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
         echo ""
         chmod +x /root/scripts/TareasCronCadaHora.sh
         echo ""
         echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.hourly/ ...${FinColor}"
         echo ""
         ln -s /root/scripts/TareasCronCadaHora.sh /etc/cron.hourly/TareasCronCadaHora
         echo ""
         echo -e "${ColorVerde}------------------------------------------------------------${FinColor}"
         echo -e "${ColorVerde}  Creando el archivo para las tareas de cada hora impar...${FinColor}"
         echo -e "${ColorVerde}------------------------------------------------------------${FinColor}"
         echo ""
         mkdir -p /root/scripts/ 2> /dev/null
         echo '#!/bin/bash'                                                                                                       > /root/scripts/TareasCronCadaHoraImpar.sh
         echo ""                                                                                                                 >> /root/scripts/TareasCronCadaHoraImpar.sh
         echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                              >> /root/scripts/TareasCronCadaHoraImpar.sh
         echo 'echo "Iniciada la ejecución del cron de cada hora impar el $FechaDeEjec" >> /var/log/TareasCronCadaHoraImpar.log' >> /root/scripts/TareasCronCadaHoraImpar.sh
         echo ""                                                                                                                 >> /root/scripts/TareasCronCadaHoraImpar.sh
         echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA IMPAR"                                           >> /root/scripts/TareasCronCadaHoraImpar.sh
         echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                         >> /root/scripts/TareasCronCadaHoraImpar.sh
         echo ""                                                                                                                 >> /root/scripts/TareasCronCadaHoraImpar.sh
         echo ""
         echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
         echo ""
         chmod +x /root/scripts/TareasCronCadaHoraImpar.sh
         echo ""
         echo -e "${ColorVerde}Instalando la tarea en crontab...${FinColor}"
         echo ""
         crontab -l > /tmp/CronTemporal
         echo "0 1-23/2 * * * /root/scripts/TareasCronCadaHoraImpar.sh" >> /tmp/CronTemporal
         crontab /tmp/CronTemporal
         rm /tmp/CronTemporal
         echo ""
         echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
         echo -e "${ColorVerde}  Creando el archivo para las tareas de cada hora par...${FinColor}"
         echo -e "${ColorVerde}----------------------------------------------------------${FinColor}"
         echo ""
         mkdir -p /root/scripts/ 2> /dev/null
         echo '#!/bin/bash'                                                                                                   > /root/scripts/TareasCronCadaHoraPar.sh
         echo ""                                                                                                             >> /root/scripts/TareasCronCadaHoraPar.sh
         echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                          >> /root/scripts/TareasCronCadaHoraPar.sh
         echo 'echo "Iniciada la ejecución del cron de cada hora par el $FechaDeEjec" >> /var/log/TareasCronCadaHoraPar.log' >> /root/scripts/TareasCronCadaHoraPar.sh
         echo ""                                                                                                             >> /root/scripts/TareasCronCadaHoraPar.sh
         echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA PAR"                                         >> /root/scripts/TareasCronCadaHoraPar.sh
         echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                       >> /root/scripts/TareasCronCadaHoraPar.sh
         echo ""                                                                                                             >> /root/scripts/TareasCronCadaHoraPar.sh
         echo ""
         echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
         echo ""
         chmod +x /root/scripts/TareasCronCadaHoraPar.sh
         echo ""
         echo -e "${ColorVerde}Instalando la tarea en crontab...${FinColor}"
         echo ""
         crontab -l > /tmp/CronTemporal
         echo "0 */2 * * * /root/scripts/TareasCronCadaHoraPar.sh" >> /tmp/CronTemporal
         crontab /tmp/CronTemporal
         rm /tmp/CronTemporal
         echo ""
         echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
         echo -e "${ColorVerde}  Creando el archivo para las tareas de cada día...${FinColor}"
         echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
         echo ""
         echo '#!/bin/bash'                                                                                          > /root/scripts/TareasCronCadaDía.sh
         echo ""                                                                                                    >> /root/scripts/TareasCronCadaDía.sh
         echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                 >> /root/scripts/TareasCronCadaDía.sh
         echo 'echo "Iniciada la ejecución del cron de cada día el $FechaDeEjec" >> /var/log/TareasCronCadaDía.log' >> /root/scripts/TareasCronCadaDía.sh
         echo ""                                                                                                    >> /root/scripts/TareasCronCadaDía.sh
         echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA DÍA"                                     >> /root/scripts/TareasCronCadaDía.sh
         echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                   >> /root/scripts/TareasCronCadaDía.sh
         echo ""                                                                                                    >> /root/scripts/TareasCronCadaDía.sh
         echo ""
         echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
         echo ""
         chmod +x /root/scripts/TareasCronCadaDía.sh
         echo ""
         echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.daily/ ...${FinColor}"
         echo ""
         ln -s /root/scripts/TareasCronCadaDía.sh /etc/cron.daily/TareasCronCadaDía
         echo ""
         echo -e "${ColorVerde}--------------------------------------------------------${FinColor}"
         echo -e "${ColorVerde}  Creando el archivo para las tareas de cada semana...${FinColor}"
         echo -e "${ColorVerde}--------------------------------------------------------${FinColor}"
         echo ""
         echo '#!/bin/bash'                                                                                                > /root/scripts/TareasCronCadaSemana.sh
         echo ""                                                                                                          >> /root/scripts/TareasCronCadaSemana.sh
         echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                       >> /root/scripts/TareasCronCadaSemana.sh
         echo 'echo "Iniciada la ejecución del cron de cada semana el $FechaDeEjec" >> /var/log/TareasCronCadaSemana.log' >> /root/scripts/TareasCronCadaSemana.sh
         echo ""                                                                                                          >> /root/scripts/TareasCronCadaSemana.sh
         echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA SEMANA"                                        >> /root/scripts/TareasCronCadaSemana.sh
         echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                      >> /root/scripts/TareasCronCadaSemana.sh
         echo ""                                                                                                          >> /root/scripts/TareasCronCadaSemana.sh
         echo ""
         echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
         echo ""
         chmod +x /root/scripts/TareasCronCadaSemana.sh
         echo ""
         echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.weekly/ ...${FinColor}"
         echo ""
         ln -s /root/scripts/TareasCronCadaSemana.sh /etc/cron.weekly/TareasCronCadaSemana
         echo ""
         echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
         echo -e "${ColorVerde}  Creando el archivo para las tareas de cada mes...${FinColor}"
         echo -e "${ColorVerde}-----------------------------------------------------${FinColor}"
         echo ""
         echo '#!/bin/bash'                                                                                          > /root/scripts/TareasCronCadaMes.sh
         echo ""                                                                                                    >> /root/scripts/TareasCronCadaMes.sh
         echo 'FechaDeEjec=$(date +A%Y-M%m-D%d@%T)'                                                                 >> /root/scripts/TareasCronCadaMes.sh
         echo 'echo "Iniciada la ejecución del cron de cada mes el $FechaDeEjec" >> /var/log/TareasCronCadaMes.log' >> /root/scripts/TareasCronCadaMes.sh
         echo ""                                                                                                    >> /root/scripts/TareasCronCadaMes.sh
         echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MES"                                     >> /root/scripts/TareasCronCadaMes.sh
         echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                                   >> /root/scripts/TareasCronCadaMes.sh
         echo ""                                                                                                    >> /root/scripts/TareasCronCadaMes.sh
         echo ""
         echo -e "${ColorVerde}Dando permiso de ejecución al archivo...${FinColor}"
         echo ""
         chmod +x /root/scripts/TareasCronCadaMes.sh
         echo ""
         echo -e "${ColorVerde}Creando enlace hacia el archivo en /etc/cron.monthly/ ...${FinColor}"
         echo ""
         ln -s /root/scripts/TareasCronCadaMes.sh /etc/cron.monthly/TareasCronCadaMes
         echo ""
         echo -e "${ColorVerde}-------------------------------------------------------------------------------${FinColor}"
         echo -e "${ColorVerde}  Dando permisos de lectura y ejecución solo al propietario de los scripts...${FinColor}"
         echo -e "${ColorVerde}-------------------------------------------------------------------------------${FinColor}"
         echo ""
         # Si esto no se hace las tareas no se ejecutarán.
         chmod 700 /root/scripts/TareasCronCadaMinuto.sh
         chmod 700 /root/scripts/TareasCronCadaHora.sh
         chmod 700 /root/scripts/TareasCronCadaHoraImpar.sh
         chmod 700 /root/scripts/TareasCronCadaHoraPar.sh
         chmod 700 /root/scripts/TareasCronCadaDía.sh
         chmod 700 /root/scripts/TareasCronCadaSemana.sh
         chmod 700 /root/scripts/TareasCronCadaMes.sh
      ## Preparar comandos post arranque
         echo ""
         echo -e "${ColorVerde}Configurando el servicio...${FinColor}"
         echo ""
         echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
         echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
         echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
         echo ""                                        >> /etc/systemd/system/rc-local.service
         echo "[Service]"                               >> /etc/systemd/system/rc-local.service
         echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
         echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
         echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
         echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
         echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
         echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
         echo ""                                        >> /etc/systemd/system/rc-local.service
         echo "[Install]"                               >> /etc/systemd/system/rc-local.service
         echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service
         echo ""
         echo -e "${ColorVerde}Creando el archivo /etc/rc.local ...${FinColor}"
         echo ""
         echo '#!/bin/bash'                            > /etc/rc.local
         echo ""                                      >> /etc/rc.local
         echo "/root/scripts/ComandosPostArranque.sh" >> /etc/rc.local
         echo "exit 0"                                >> /etc/rc.local
         chmod +x                                        /etc/rc.local
         echo ""
         echo -e "${ColorVerde}Creando el archivo para meter los comandos...${FinColor}"
         echo ""
         mkdir -p /root/scripts/ 2> /dev/null
         echo '#!/bin/bash'                                                                                         > /root/scripts/ComandosPostArranque.sh
         echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
         echo "ColorRojo='\033[1;31m'"                                                                             >> /root/scripts/ComandosPostArranque.sh
         echo "ColorVerde='\033[1;32m'"                                                                            >> /root/scripts/ComandosPostArranque.sh
         echo "FinColor='\033[0m'"                                                                                 >> /root/scripts/ComandosPostArranque.sh
         echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
         echo 'FechaDeEjec=$(date +A%YM%mD%d@%T)'                                                                  >> /root/scripts/ComandosPostArranque.sh
         echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
         echo 'echo "Iniciada la ejecución del script post-arranque el $FechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/ComandosPostArranque.sh
         echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
         echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                    >> /root/scripts/ComandosPostArranque.sh
         echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                  >> /root/scripts/ComandosPostArranque.sh
         echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
         chmod 700                                                                                                    /root/scripts/ComandosPostArranque.sh
         echo ""
         echo -e "${ColorVerde}Activando y arrancando el servicio...${FinColor}"
         echo ""
         systemctl enable rc-local
         systemctl start rc-local.service
      ## Actualizar el sistema y reinciar
         echo ""
         echo "  Container preparado. Actualizando el sistema y reiniciando..."
         echo ""
         apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y install mc && shutdown -r now
  fi
  
fi

