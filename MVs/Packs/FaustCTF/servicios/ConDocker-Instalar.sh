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
      1 "Comprobar disponibilidad de docker-compose" on
     22 "  faustctf-2024-lvm"                        off
     21 "  faustctf-2024-quickr-maps"                off
     20 "  faustctf-2024-floppcraft"                 off
     19 "  faustctf-2024-todo-list-service"          off
     18 "  faustctf-2024-faust-vault"                off
     17 "  faustctf-2024-asm_chat"                   off
     16 "  faustctf-2024-secretchannel"              off
     15 "  faustctf-2024-missions"                   off
     14 "  faustctf-2023-rsa-mail"                   off
     13 "  faustctf-2023-office-supplies"            off
     12 "  faustctf-2023-image-galoisry"             off
     11 "  faustctf-2023-tic-tac-toe"                off
     10 "  faustctf-2023-jokes"                      off
      9 "  faustctf-2023-chat-app"                   off
      8 "  faustctf-2023-buerographie"               off
      7 "  faustctf-2022-docs-notebook"              off
      6 "  faustctf-2022-compiler60"                 off
      5 "  faustctf-2022-admincrashboard"            off
      4 "  faustctf-2022-notes-from-the-future"      off
      3 "  faustctf-2022-fittyfit"                   off
      2 "  faustctf-2021-pirate-birthday-planner"    off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Comprobando disponibilidad de docker-compose..."
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

        ;;

       22)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-lvm..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2024-lvm
          sudo docker-compose up -d

        ;;

       21)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-quickr-maps..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2024-quickr-maps
          sudo docker-compose up -d

        ;;

       20)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-floppcraft..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2024-floppcraft
          sudo docker-compose up -d

        ;;

       19)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-todo-list-service..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2024-todo-list-service
          sudo docker-compose up -d

        ;;

       18)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-faust-vault..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2024-faust-vault
          sudo docker-compose up -d

        ;;

       17)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-asm_chat..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2024-asm_chat
          sudo docker-compose up -d

        ;;

       16)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-secretchannel..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2024-secretchannel
          sudo docker-compose up -d

        ;;

       15)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-missions..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2024-missions
          sudo docker-compose up -d

        ;;

       14)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-rsa-mail..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2023-rsa-mail
          sudo docker-compose up -d

        ;;

       13)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-office-supplies..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2023-office-supplies
          sudo docker-compose up -d

        ;;

       12)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-image-galoisry..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2023-image-galoisry
          sudo docker-compose up -d

        ;;

       11)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-tic-tac-toe..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2023-tic-tac-toe
          sudo docker-compose up -d

        ;;

       10)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-jokes..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2023-jokes
          sudo docker-compose up -d

        ;;

        9)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-chat-app..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2023-chat-app
          sudo docker-compose up -d

        ;;

        8)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-buerographie..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2023-buerographie
          sudo docker-compose up -d

        ;;

        7)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-docs-notebook..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2022-docs-notebook
          sudo docker-compose up -d

        ;;

        6)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-compiler60..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2022-compiler60
          sudo docker-compose up -d

        ;;

        5)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-admincrashboard..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2022-admincrashboard
          sudo docker-compose up -d

        ;;

        4)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-notes-from-the-future..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2022-notes-from-the-future
          sudo docker-compose up -d

        ;;

        3)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-fittyfit..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2022-fittyfit
          sudo docker-compose up -d

        ;;

        2)

          echo ""
          echo "  Construyendo la imagen de faustctf-2021-pirate-birthday-planner..."
          echo ""
          cd /tmp/
          git clone https://github.com/fausecteam/faustctf-2021-pirate-birthday-planner
          cd faustctf-2021-pirate-birthday-planner/src/
          sudo docker-compose up -d

        ;;

    esac

done

