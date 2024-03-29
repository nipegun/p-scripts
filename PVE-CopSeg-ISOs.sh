#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer copia de seguridad interna de los ISOs de ProxmoxVE
#
# Ejecución remota:
#    curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-CopSeg-ISOs.sh | bash
# ----------

# Definir carpeta de copia de seguridad
  vCarpetaCopSeg="/CopSegInt" # No debe acabar c on /

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo "Este script está preparado para ejecutarse como root y no lo has ejecutado como root." >&2
    exit 1
  fi

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando script de copia de seguridad de ISOs de ProxmoxVE...${cFinColor}"
  echo ""

# Definir la fecha de ejecución del script
  cFechaEjecScript=$(date +A%YM%mD%d@%T)

# Ejecutar copia de seguridad de /var/lib/vz/template/iso/
  echo ""
  echo "    Creando copia de seguridad de la carpeta /var/lib/vz/template/iso/..."
  echo ""
  mkdir -p                            "$vCarpetaCopSeg/ISOs/$cFechaEjecScript/var/lib/vz/template/iso/"
  cp -L -r /var/lib/vz/template/iso/* "$vCarpetaCopSeg/ISOs/$cFechaEjecScript/var/lib/vz/template/iso/" 2> /dev/null

# Ejecutar copia de seguridad de /var/lib/pve/local-btrfs/template/iso/
  echo ""
  echo "    Creando copia de seguridad de la carpeta /var/lib/pve/local-btrfs/template/iso/..."
  echo ""
  mkdir -p                                         "$vCarpetaCopSeg/ISOs/$cFechaEjecScript/var/lib/pve/local-btrfs/template/iso/"
  cp -L -r /var/lib/pve/local-btrfs/template/iso/* "$vCarpetaCopSeg/ISOs/$cFechaEjecScript/var/lib/pve/local-btrfs/template/iso/" 2> /dev/null

# Apuntar fecha en el log
  touch /var/log/CopiasDeSeguridad.log 2> /dev/null
  echo "$cFechaEjecScript - Terminada la copia de seguridad de los ISOs de ProxmoxVE." >> /var/log/CopiasDeSeguridad.log

# Notificar fin del script
  echo ""
  echo -e "${cColorVerde}    Ejecución del script, finalizada.${cFinColor}"
  echo ""

