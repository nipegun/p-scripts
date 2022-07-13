#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para hacer copia de seguridad interna de ProxmoxVE
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-CopSeg-SistemaOperativo.sh | bash
# ----------

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo "Este script está preparado para ejecutarse como root y no lo has ejecutado como root." >&2
    exit 1
  fi

ColorAzul="\033[0;34m"
ColorAzulClaro="\033[1;34m"
ColorVerde='\033[1;32m'
ColorRojo='\033[1;31m'
FinColor='\033[0m'

echo ""
echo -e "${ColorAzulClaro}  Iniciando script de copia de seguridad interna de ProxmoxVE...${FinColor}"
echo ""

# Definir la fecha de ejecución del script
  vFechaDeEjec=$(date +A%YM%mD%d@%T)

# Crear las carpetas de copias de seguridad interna (en caso de que no existan)
  mkdir -p /CopSegInt/$vFechaDeEjec/BD/ 2> /dev/null
  mkdir -p /CopSegInt/$vFechaDeEjec/etc/ 2> /dev/null
  mkdir -p /CopSegInt/$vFechaDeEjec/home/ 2> /dev/null
  mkdir -p /CopSegInt/$vFechaDeEjec/root/ 2> /dev/null

# Ejecutar copia de seguridad de /etc/
  echo ""
  echo "    Creando copia de seguridad de la carpeta /etc/..."
  echo ""
  cp -L -r /etc/* /CopSegInt/$vFechaDeEjec/etc/ 2> /dev/null

# Ejecutar copia de seguridad de /root/
  echo ""
  echo "    Creando copia de seguridad de la carpeta /root/..."
  echo ""
  cp -rL /root/* /CopSegInt/$vFechaDeEjec/root/ 2> /dev/null

# Ejecutar copia de seguridad de la base de datos
  echo ""
  echo "    Creando copia de seguridad de la base de datos Proxmox Cluster File System (pmxcfs)..."
  echo ""
  # https://hacks4geeks.com/entendiendo-el-sistema-de-archivos-del-culster-de-proxmox/
  # Comprobar si el paquete sqlite3 está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s sqlite3 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${ColorRojo}      sqlite3 no está instalado. Iniciando su instalación...${FinColor}"
      echo ""
      apt-get -y update > /dev/null && apt-get -y install sqlite3
      echo ""
    fi
  vEstadoDeLaBaseDeDatosDePVE=$(sqlite3 /var/lib/pve-cluster/config.db "PRAGMA integrity_check;")
  if [ $vEstadoDeLaBaseDeDatosDePVE == "ok" ]; then
    echo ""
    echo "      El estado de la base de datos es consistente. Procediendo con la copia de seguridad..."
    echo ""
    rm -f /var/lib/pve-cluster/config.db.sql 2> /dev/null
    rm -f /var/lib/pve-cluster/config.db.bak 2> /dev/null
    sqlite3 /var/lib/pve-cluster/config.db ".dump" | sqlite3 /var/lib/pve-cluster/config.db.bak
    sqlite3 /var/lib/pve-cluster/config.db.bak ".mode insert" ".output /var/lib/pve-cluster/config.db.sql.tmp1" ".dump" | sqlite3 /var/lib/pve-cluster/config.db.bak
    # Comprobar si el paquete sqlformat está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s sqlformat 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${ColorRojo}      sqlformat no está instalado. Iniciando su instalación...${FinColor}"
        echo ""
        apt-get -y update > /dev/null && apt-get -y install sqlformat
        echo ""
      fi
    sqlformat --keywords upper --identifiers lower /var/lib/pve-cluster/config.db.sql.tmp1 > /var/lib/pve-cluster/config.db.sql.tmp2
    cat /var/lib/pve-cluster/config.db.sql.tmp2 | sed 's/tree (/tree (\n/g' | sed 's/VALUES(/VALUES(\n  /g' | sed 's-,-,\n  -g'  | sed 's-);-\n);\n-g' | sed 's-    -  -g' > /var/lib/pve-cluster/config.db.sql
    rm -f /var/lib/pve-cluster/config.db.sql.tmp1 2> /dev/null
    rm -f /var/lib/pve-cluster/config.db.sql.tmp2 2> /dev/null
    mv /var/lib/pve-cluster/config.db.bak /CopSegInt/$vFechaDeEjec/BD/config.db
    mv /var/lib/pve-cluster/config.db.sql /CopSegInt/$vFechaDeEjec/BD/config.db.sql
    echo "El archivo config.db debe ubicarse en /var/lib/pve-cluster/" > /CopSegInt/$vFechaDeEjec/BD/UbicDelArchivoConfigDB.txt
  else
    echo ""
    echo -e "${ColorRojo}      El estado de la base de datos no es consistente. Intentando exportar lo que se pueda...${FinColor}"
    echo ""
    sqlite3 /var/lib/pve-cluster/config.db ".recover" | sqlite3 /var/lib/pve-cluster/config.db.recover
    sqlite3 /var/lib/pve-cluster/config.db ".dump" | sed -e 's|^ROLLBACK;\( -- due to errors\)*$|COMMIT;|g' | sqlite3 /var/lib/pve-cluster/config.db.dump-before-rollback
  fi

  # Crear copia de seguridad del tree
    echo ""
    echo "    Creando exportación de la tabla tree de la base de datos hacia el archivo tree.txt..."
    echo ""
    sqlite3 /var/lib/pve-cluster/config.db 'select * from tree;' > /CopSegInt/$vFechaDeEjec/BD/tree.txt

  # Crear copia de seguridad de los archivos de dentro de la base de datos
    echo ""
    echo "    Creando copia de seguridad de los archivos de dentro de la base de datos..."
    echo ""
    mkdir -p /CopSegInt/$vFechaDeEjec/BD/etc/pve/ 2> /dev/null
    cp -rfL /etc/pve/. /CopSegInt/$vFechaDeEjec/BD/etc/pve/
