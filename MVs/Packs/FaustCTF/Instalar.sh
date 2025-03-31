#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar FaustCTF en proxmox
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/Instalar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/Instalar.sh | nano -

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación/reinstalación/actualización del simulador del PLC 1214c de Zubiri...${cFinColor}"

# Borrar posible carpeta previa
  cd ~/
  rm -rf ~/p-scripts

# Clonar el repositorio
  echo ""
  echo "    Clonando el repositorio..."
  echo ""
  # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}      El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install git
      echo ""
    fi
  git clone https://github.com/nipegun/p-scripts.git

# Mover carpeta
  mv ~/p-scripts/MVs/Packs/FaustCTFGameServer/ ~/

