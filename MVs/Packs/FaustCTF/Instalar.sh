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

pct stop 1000
pct stop 1001
pct stop 1002
pct stop 1003
pct stop 1004
pct stop 1005
pct stop 1500
pct stop 1501
pct stop 1502
pct stop 1503
pct stop 1504
pct stop 1505
pct stop 1990
pct stop 1999

pct destroy 1000
pct destroy 1001
pct destroy 1002
pct destroy 1003
pct destroy 1004
pct destroy 1005
pct destroy 1500
pct destroy 1501
pct destroy 1502
pct destroy 1503
pct destroy 1504
pct destroy 1505
pct destroy 1990
pct destroy 1999

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
  rm -rf ~/FaustCTF/
  mv ~/p-scripts/MVs/Packs/FaustCTF/ ~/
  rm -rf ~/p-scripts/

# Instalar terraform
  apt-get -y update
  apt-get -y install gnupg
  apt-get -y install software-properties-common
  apt-get -y install curl
  curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
  apt-get -y update
  apt-get -y install terraform

#Crear el puente vmbr999
  echo 'auto vmbr999'              >> /etc/network/interfaces
  echo 'iface vmbr999 inet manual' >> /etc/network/interfaces
  echo '  bridge_ports none'       >> /etc/network/interfaces
  echo '  bridge_stp off'          >> /etc/network/interfaces
  echo '  bridge_fd 0'             >> /etc/network/interfaces
  echo '  bridge_vlan_aware yes'   >> /etc/network/interfaces
  systemctl restart networking

#
  cd ~/FaustCTF/
  rm -rf ~/.terraform.d/
  terraform init
  terraform apply -auto-approve -var team-count=5 -var-file=proxmox.tfvars -compact-warnings


