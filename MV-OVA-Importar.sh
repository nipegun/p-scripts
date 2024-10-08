#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para importar una máquina virtual .OVA en Proxmox
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-OVA-Importar.sh | bash -s Parámetro1 Parámetro2 Parámetro3
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/MV-OVA-Importar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Definir la cantidad de argumentos esperados
  cCantArgumEsperados=3

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
    echo "    $0 [RutaAlArchivoOVA] [ID] [Almacenamiento]"
    echo ""
    echo "  Ejemplo:"
    echo "    $0 '/tmp/vm123.ova' '123' 'local-lvm'"
    echo ""
    exit
  else
    echo ""
    echo ""
    echo ""

    vID="$1"
    vAlmacenamiento="$3"
    vArchivoOVA="$1"

    # Descomprimir
      mkdir -p /tmp/OVAdeMV/ 2> /dev/null
      rm -rf /tmp/OVAdeMV/*
      # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          apt-get -y update && apt-get -y install tar
          echo ""
        fi
        tar xvf "$vArchivoOVA" -C /tmp/OVAdeMV

    # Determinar el archivo .ovf
    
      vArchivoOVF=$(find /tmp/OVAdeMV/ -type f -name *.ovf)

    # Importar
      qm importovf $vID $vArchivoOVF $vAlmacenamiento

fi
