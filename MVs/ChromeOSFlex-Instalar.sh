#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear la máquina virtual de ChromeOS Flex en Proxmox
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/ChromeOSFlex-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota como root con parámetros (Para indicar almacenamiento específico e ID de máquina virtual deseado):
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/ChromeOSFlex-Instalar.sh | sed 's-sudo--g' | bash -s "NombreDelAlmacenamiento" "IDDeLaMV"
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/ChromeOSFlex-Instalar.sh | nano -
# ----------

# Definir el nombre del almacenamiento
  vAlmacenamiento="${1:-local-lvm}"
# Definir id de la nueva máquina virtual
  vIdDeLaNuevaMV="${2:-}"

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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de la máquina virtual de ChromeOSFlex en Proxmox...${cFinColor}"
  echo ""

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}    Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Crear un array con todas las IDs ocupadas del servidor
  aIDsOcupadas=$(qm list | awk '{print $1}' | grep ^[0-9])

# Generar un ID de máquina virtual que no esté ocupado
  # Crear la función para generar un IdDeMV aleatorio entre 100 y 999999
    fGenerarIdDeMVAleatorio() {
      echo $(( ( RANDOM * 32768 + RANDOM ) % 999900 + 100 ))
    }
  # Probar números generados hasta encontrar uno válido
    if [[ -n "${vIdDeLaNuevaMV}" ]]; then
      vIdDeLaNuevaMV="${vIdDeLaNuevaMV}"
    else
      while :; do
        vIdDeLaNuevaMV="$(fGenerarIdDeMVAleatorio)"
        echo "${aIDsOcupadas}" | grep -qw "${vIdDeLaNuevaMV}" || break
      done
    fi

# Crear la máquina virtual
  qm create $vIdDeLaNuevaMV       \
    --name ChromeOSFlex           \
    --machine q35                 \
    --bios ovmf                   \
    --ostype l26                  \
    --cpu host                    \
    --cores 2                     \
    --memory 4096                 \
    --balloon 2048                \
    --scsihw virtio-scsi-single   \
    --sata0 "$vAlmacenamiento":28 \
    --vga virtio-gl               \
    --net0 virtio,bridge=vmbr0    \
    --agent enabled=1
