#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Dockers para atacar en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/Vulnerable/DockersParaAtacar-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/Vulnerable/DockersParaAtacar-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/dh-scripts/refs/heads/main/SoftInst/Vulnerable/DockersParaAtacar-Instalar.sh | nano -
#
# Más información aquí: https://github.com/vulhub/vulhub
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Comprobar disponibilidad de docker-compose y git"             on

     59 "  Preparar el servicio faustctf-2024-todo-list-service"       off
     58 "  Preparar el servicio faustctf-2024-secretchannel"           off
     57 "  Preparar el servicio faustctf-2024-quickr-maps"             off
     56 "  Preparar el servicio faustctf-2024-missions"                off
     55 "  Preparar el servicio faustctf-2024-lvm"                     off
     54 "  Preparar el servicio faustctf-2024-floppcraft"              off
     53 "  Preparar el servicio faustctf-2024-faust-vault"             off
     52 "  Preparar el servicio faustctf-2024-asm_chat"                off
     
     51 "  Preparar el servicio faustctf-2023-tic-tac-toe"             off
     50 "  Preparar el servicio faustctf-2023-rsa-mail"                off
     49 "  Preparar el servicio faustctf-2023-office-supplies"         off
     48 "  Preparar el servicio faustctf-2023-jokes"                   off
     47 "  Preparar el servicio faustctf-2023-image-galoisry"          off
     46 "  Preparar el servicio faustctf-2023-chat-app"                off
     45 "  Preparar el servicio faustctf-2023-buerographie"            off
     44 "  Preparar el servicio faustctf-2023-auction-service"         off

     43 "  Preparar el servicio faustctf-2022-notes-from-the-future"   off
     42 "  Preparar el servicio faustctf-2022-ghost"                   off
     41 "  Preparar el servicio faustctf-2022-flux-mail"               off
     40 "  Preparar el servicio faustctf-2022-fittyfit"                off
     39 "  Preparar el servicio faustctf-2022-docs-notebook"           off
     38 "  Preparar el servicio faustctf-2022-compiler60"              off
     37 "  Preparar el servicio faustctf-2022-admincrashboard"         off

     36 "  Preparar el servicio faustctf-2021-veighty-machinery"       off
     35 "  Preparar el servicio faustctf-2021-treasurehunt"            off
     34 "  Preparar el servicio faustctf-2021-treasury"                off
     33 "  Preparar el servicio faustctf-2021-thelostbottle"           off
     32 "  Preparar el servicio faustctf-2021-pirate-birthday-planner" off
     31 "  Preparar el servicio faustctf-2021-merklechat"              off
     30 "  Preparar el servicio faustctf-2021-lonely-island"           off
     29 "  Preparar el servicio faustctf-2022-digital-seconds-ago"     off

     28 "  Preparar el servicio faustctf-2020-photoshoot"              off
     27 "  Preparar el servicio faustctf-2020-marsu"                   off
     26 "  Preparar el servicio faustctf-2020-mars-express"            off
     25 "  Preparar el servicio faustctf-2020-marscasino"              off
     24 "  Preparar el servicio faustctf-2020-ipps"                    off
     23 "  Preparar el servicio faustctf-2020-greenhouses"             off
     22 "  Preparar el servicio faustctf-2020-cartography"             off

     21 "  Preparar el servicio faustctf-2019-two-factor-apache"       off
     20 "  Preparar el servicio faustctf-2019-sloc"                    off
     19 "  Preparar el servicio faustctf-2019-responsivesecurity"      off
     18 "  Preparar el servicio faustctf-2019-ptth"                    off
     17 "  Preparar el servicio faustctf-2019-punchy"                  off
     16 "  Preparar el servicio faustctf-2019-posthorn"                off
     15 "  Preparar el servicio faustctf-2019-happy-birthday-gdpr"     off

     14 "  Preparar el servicio faustctf-2018-the-tangle"              off
     13 "  Preparar el servicio faustctf-2018-restchain"               off
     12 "  Preparar el servicio faustctf-2018-mtcamlx"                 off
     11 "  Preparar el servicio faustctf-2018-jodlgang"                off
     10 "  Preparar el servicio faustctf-2018-helpline"                off
      9 "  Preparar el servicio faustctf-2018-diagon-alley"            off

      8 "  Preparar el servicio faustctf-2017-toilet"                  off
      7 "  Preparar el servicio faustctf-2017-tempsense"               off
      6 "  Preparar el servicio faustctf-2017-smartscale"              off
      5 "  Preparar el servicio faustctf-2017-smartmeter"              off
      4 "  Preparar el servicio faustctf-2017-doodle"                  off
      3 "  Preparar el servicio faustctf-2017-doedel"                  off
      2 "  Preparar el servicio faustctf-2017-alexa"                   off

    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Comprobando disponibilidad de docker-compose y git..."
          echo ""
          # Comprobar si el paquete docker-compose está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s docker-compose 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}    El paquete docker-compose no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install docker-compose
              echo ""
            fi
          # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${cColorRojo}    El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install git
              echo ""
            fi

        ;;

       59)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       58)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       57)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       56)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       55)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       54)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       53)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       52)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       51)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       50)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       49)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       48)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       47)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       46)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       45)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       44)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       43)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       42)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       41)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       40)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       39)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       38)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       37)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       36)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       35)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       34)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       33)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       32)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       31)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       30)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       29)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       28)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       27)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       26)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       25)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       24)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       23)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       22)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       21)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       20)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       19)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       18)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       17)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       16)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       15)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       14)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       13)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       12)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       11)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

       10)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

        9)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

        8)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

        7)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

        6)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

        5)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

        4)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

        3)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

        2)

          echo ""
          echo "  Preparando el servicio x..."
          echo ""
          cd ~/
          git clone https://github.com/fausecteam/x
          cd x

        ;;

    esac

done

