#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para hacer copia de seguridad interna de los ISOs de ProxmoxVE
#
#  Ejecución remota:
#    curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-CopSeg-ISOs.sh | bash
# ----------

vCarpetaCopSeg="/CopSegInt" # No debe acabar c on /

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo "Este script está preparado para ejecutarse como root y no lo has ejecutado como root." >&2
    exit 1
  fi

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

echo ""
echo -e "${vColorAzulClaro}  Iniciando script de copia de seguridad de ISOs de ProxmoxVE...${vFinColor}"
echo ""

# Definir la fecha de ejecución del script
  vFechaDeEjec=$(date +A%YM%mD%d@%T)

# Ejecutar copia de seguridad de /var/lib/vz/template/iso/
  echo ""
  echo "    Creando copia de seguridad de la carpeta /var/lib/vz/template/iso/..."
  echo ""
  mkdir -p                            "$vCarpetaCopSeg/ISOs/$vFechaDeEjec/var/lib/vz/template/iso/"
  cp -L -r /var/lib/vz/template/iso/* "$vCarpetaCopSeg/ISOs/$vFechaDeEjec/var/lib/vz/template/iso/" 2> /dev/null

# Ejecutar copia de seguridad de /var/lib/pve/local-btrfs/template/iso/
  echo ""
  echo "    Creando copia de seguridad de la carpeta /var/lib/pve/local-btrfs/template/iso/..."
  echo ""
  mkdir -p                                         "$vCarpetaCopSeg/ISOs/$vFechaDeEjec/var/lib/pve/local-btrfs/template/iso/"
  cp -L -r /var/lib/pve/local-btrfs/template/iso/* "$vCarpetaCopSeg/ISOs/$vFechaDeEjec/var/lib/pve/local-btrfs/template/iso/" 2> /dev/null

# Loguear el trabajo
  echo "$vFechaDeEjec - Terminada la copia de seguridad de los ISOs de ProxmoxVE." >> /var/log/CopiasDeSeguridad.log

echo ""
echo -e "${vColorVerde}    Ejecución del script, finalizada.${vFinColor}"
echo ""

