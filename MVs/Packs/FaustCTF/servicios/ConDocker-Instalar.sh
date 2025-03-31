#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Dockers para atacar en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/servicios/ConDocker-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/servicios/ConDocker-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/servicios/ConDocker-Instalar.sh | nano -
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
      1 "Comprobar disponibilidad de docker-compose y git" on
     22 "  faustctf-2024-lvm"                              off
     21 "  faustctf-2024-quickr-maps"                      off
     20 "  faustctf-2024-floppcraft"                       off
     19 "  faustctf-2024-todo-list-service"                off
     18 "  faustctf-2024-faust-vault"                      off
     17 "  faustctf-2024-asm_chat"                         off
     16 "  faustctf-2024-secretchannel"                    off
     15 "  faustctf-2024-missions"                         off
     14 "  faustctf-2023-rsa-mail"                         off
     13 "  faustctf-2023-office-supplies"                  off
     12 "  faustctf-2023-image-galoisry"                   off
     11 "  faustctf-2023-tic-tac-toe"                      off
     10 "  faustctf-2023-jokes"                            off
      9 "  faustctf-2023-chat-app"                         off
      8 "  faustctf-2023-buerographie"                     off
      7 "  faustctf-2022-docs-notebook"                    off
      6 "  faustctf-2022-compiler60      (Corregir)"       off
      5 "  faustctf-2022-admincrashboard (Corregir)"       off
      4 "  faustctf-2022-notes-from-the-future"            off
      3 "  faustctf-2022-fittyfit"                         off
      2 "  faustctf-2021-pirate-birthday-planner"          off
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

       22)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-lvm..."
          echo ""
          cd ~/
          rm -rf faustctf-2024-lvm
          git clone https://github.com/fausecteam/faustctf-2024-lvm
          cd faustctf-2024-lvm
          sudo docker-compose up -d

        ;;

       21)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-quickr-maps..."
          echo ""
          cd ~/
          rm -rf faustctf-2024-quickr-maps
          git clone https://github.com/fausecteam/faustctf-2024-quickr-maps
          cd faustctf-2024-quickr-maps
          sudo docker-compose up -d

        ;;

       20)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-floppcraft..."
          echo ""
          cd ~/
          rm -rf faustctf-2024-floppcraft
          git clone https://github.com/fausecteam/faustctf-2024-floppcraft
          cd faustctf-2024-floppcraft
          sudo docker-compose up -d

        ;;

       19)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-todo-list-service..."
          echo ""
          cd ~/
          rm -rf faustctf-2024-todo-list-service
          git clone https://github.com/fausecteam/faustctf-2024-todo-list-service
          cd faustctf-2024-todo-list-service
          sudo docker-compose up -d

        ;;

       18)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-faust-vault..."
          echo ""
          cd ~/
          rm -rf faustctf-2024-faust-vault
          git clone https://github.com/fausecteam/faustctf-2024-faust-vault
          cd faustctf-2024-faust-vault
          sed -i -e 's|--mode no-install||g' ~/faustctf-2024-faust-vault/frontend/Dockerfile.deps
          sed -i -e 's|--mode no-install||g' ~/faustctf-2024-faust-vault/nginx/Dockerfile
          sed -i -e 's|--mode no-install||g' ~/faustctf-2024-faust-vault/nginx/Dockerfile.nodemodules
          sudo docker-compose up -d

        ;;

       17)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-asm_chat..."
          echo ""
          cd ~/
          rm -rf faustctf-2024-asm_chat
          git clone https://github.com/fausecteam/faustctf-2024-asm_chat
          cd faustctf-2024-asm_chat
          sudo docker-compose up -d

        ;;

       16)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-secretchannel..."
          echo ""
          cd ~/
          rm -rf faustctf-2024-secretchannel
          git clone https://github.com/fausecteam/faustctf-2024-secretchannel
          cd faustctf-2024-secretchannel
          sudo docker-compose up -d

        ;;

       15)

          echo ""
          echo "  Construyendo la imagen de faustctf-2024-missions..."
          echo ""
          cd ~/
          rm -rf faustctf-2024-missions
          git clone https://github.com/fausecteam/faustctf-2024-missions
          cd faustctf-2024-missions
          sudo docker-compose up -d

        ;;

       14)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-rsa-mail..."
          echo ""
          cd ~/
          rm -rf faustctf-2023-rsa-mail
          git clone https://github.com/fausecteam/faustctf-2023-rsa-mail
          cd faustctf-2023-rsa-mail
          echo 'FROM alpine:latest'                                                               > ~/faustctf-2023-rsa-mail/rsa-mail/Dockerfile.deps
          echo 'RUN apk add --update --no-cache python3 py3-virtualenv build-base'               >> ~/faustctf-2023-rsa-mail/rsa-mail/Dockerfile.deps
          echo 'RUN python3 -m venv /venv'                                                       >> ~/faustctf-2023-rsa-mail/rsa-mail/Dockerfile.deps
          echo 'COPY requirements.txt /tmp/requirements.txt'                                     >> ~/faustctf-2023-rsa-mail/rsa-mail/Dockerfile.deps
          echo 'RUN . /venv/bin/activate && pip install --no-cache-dir -r /tmp/requirements.txt' >> ~/faustctf-2023-rsa-mail/rsa-mail/Dockerfile.deps
          echo 'ENV PATH="/venv/bin:$PATH"'                                                      >> ~/faustctf-2023-rsa-mail/rsa-mail/Dockerfile.deps
          sudo docker-compose up -d

        ;;

       13)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-office-supplies..."
          echo ""
          cd ~/
          rm -rf faustctf-2023-office-supplies
          git clone https://github.com/fausecteam/faustctf-2023-office-supplies
          cd faustctf-2023-office-supplies
          sudo docker-compose up -d

        ;;

       12)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-image-galoisry..."
          echo ""
          cd ~/
          rm -rf faustctf-2023-image-galoisry
          git clone https://github.com/fausecteam/faustctf-2023-image-galoisry
          cd faustctf-2023-image-galoisry
          sed -i -e 's|FROM python:alpine3.18|FROM python:3.11-alpine|g' ~/faustctf-2023-image-galoisry/image-galoisry/Dockerfile.deps
          sudo docker-compose up -d

        ;;

       11)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-tic-tac-toe..."
          echo ""
          cd ~/
          rm -rf faustctf-2023-tic-tac-toe
          git clone https://github.com/fausecteam/faustctf-2023-tic-tac-toe
          cd faustctf-2023-tic-tac-toe
          sudo docker-compose up -d

        ;;

       10)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-jokes..."
          echo ""
          cd ~/
          rm -rf faustctf-2023-jokes
          git clone https://github.com/fausecteam/faustctf-2023-jokes
          cd faustctf-2023-jokes
          sudo docker-compose up -d

        ;;

        9)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-chat-app..."
          echo ""
          cd ~/
          rm -rf faustctf-2023-chat-app
          git clone https://github.com/fausecteam/faustctf-2023-chat-app
          cd faustctf-2023-chat-app
          sudo docker-compose up -d

        ;;

        8)

          echo ""
          echo "  Construyendo la imagen de faustctf-2023-buerographie..."
          echo ""
          cd ~/
          rm -rf faustctf-2023-buerographie
          git clone https://github.com/fausecteam/faustctf-2023-buerographie
          cd faustctf-2023-buerographie
          sudo docker-compose up -d

        ;;

        7)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-docs-notebook..."
          echo ""
          cd ~/
          rm -rf faustctf-2022-docs-notebook
          git clone https://github.com/fausecteam/faustctf-2022-docs-notebook
          cd faustctf-2022-docs-notebook
          sudo docker-compose up -d

        ;;

        6)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-compiler60..."
          echo ""
          cd ~/
          rm -rf faustctf-2022-compiler60
          git clone https://github.com/fausecteam/faustctf-2022-compiler60
          cd faustctf-2022-compiler60
          sudo docker-compose up -d

        ;;

        5)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-admincrashboard..."
          echo ""
          cd ~/
          rm -rf faustctf-2022-admincrashboard
          git clone https://github.com/fausecteam/faustctf-2022-admincrashboard
          cd faustctf-2022-admincrashboard
          sed -i -e 's|FROM python|FROM python:3.10|g' ~/faustctf-2022-admincrashboard/admincrashboard/Dockerfile.deps
          echo 'werkzeug==2.0.3'                    >> ~/faustctf-2022-admincrashboard/admincrashboard/requirements.txt
          sudo docker-compose up -d

        ;;

        4)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-notes-from-the-future..."
          echo ""
          cd ~/
          rm -rf faustctf-2022-notes-from-the-future
          git clone https://github.com/fausecteam/faustctf-2022-notes-from-the-future
          cd faustctf-2022-notes-from-the-future
          sudo docker-compose up -d

        ;;

        3)

          echo ""
          echo "  Construyendo la imagen de faustctf-2022-fittyfit..."
          echo ""
          cd ~/
          rm -rf faustctf-2022-fittyfit
          git clone https://github.com/fausecteam/faustctf-2022-fittyfit
          cd faustctf-2022-fittyfit/src/
          sudo docker-compose up -d

        ;;

        2)

          echo ""
          echo "  Construyendo la imagen de faustctf-2021-pirate-birthday-planner..."
          echo ""
          cd ~/
          rm -rf faustctf-2021-pirate-birthday-planner
          git clone https://github.com/fausecteam/faustctf-2021-pirate-birthday-planner
          cd faustctf-2021-pirate-birthday-planner/src/
          sudo docker-compose up -d

        ;;

    esac

done

