#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar el nombre de un servidor Proxmox
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-Host-Nombre-Cambiar.sh | bash -s NombreNuevo
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-Host-Nombre-Cambiar.sh | bash -s NombreNuevo
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
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

cCantArgumEsperados=1

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de nombre del host Proxmox...${cFinColor}"
  echo ""

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 NombreNuevo"
    echo ""
    echo "Ejemplo:"
    echo "$0 perro gato"
    echo "##################################################"
    echo ""
    exit
  else
    # Obtener el nombre actual del host
      vNombreActualDelHost=$(hostname)
    # Notificar del cambio y pedir aceptar
      echo ""
      echo "    Se intentará cambiar el nombre del host de $vNombreActualDelHost a $1..."
      echo ""
      read -p "      Presiona cualquier tecla para continuar o CTRL+C para cancelar"

    # Proceder con el cambio
      echo ""
      echo "    Procediendo..."
      echo ""
      find /bin        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /boot       -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /dev        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /etc        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /home       -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /lib        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /lib64      -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /lost+found -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /media      -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /mnt        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /opt        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /root       -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /run        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /sbin       -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /srv        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /tmp        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /usr        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      find /var        -type f -exec sed -i -e "s|$vNombreActualDelHost|$1|g" {} \;
      echo ""
fi

