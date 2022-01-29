#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------
#  Script de NiPeGun para hacer copia de seguridad interna de ProxmoxVE
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-CopSegInt.sh | bash
#----------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}-----------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando script de copia de seguridad internade ProxmoxVE...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------------------${FinColor}"
echo ""

## Definir la fecha de ejecución del script
   FechaDeEjec=$(date +A%YM%mD%d@%T)

## Crear las carpetas de copias de seguridad interna (en caso de que no existan)
   mkdir -p /CopSegInt/$FechaDeEjec/BD/ 2> /dev/null
   mkdir -p /CopSegInt/$FechaDeEjec/etc/ 2> /dev/null
   mkdir -p /CopSegInt/$FechaDeEjec/home/ 2> /dev/null
   mkdir -p /CopSegInt/$FechaDeEjec/root/ 2> /dev/null

## Ejecutar copia de seguridad de la base de datos
   echo ""
   echo "  Haciendo copia de seguridad de la base de datos..."
   echo ""
   EstadoDeLaBaseDeDatosDePVE=$(sqlite3 /var/lib/pve-cluster/config.db "PRAGMA integrity_check;")
   if [ $EstadoDeLaBaseDeDatosDePVE == "ok" ]; then
     echo ""
     echo "  El estado de la base de datos es consistente. Procediendo con la copia de seguridad..."
     echo ""
     rm -f /var/lib/pve-cluster/config.db.sql 2> /dev/null
     rm -f /var/lib/pve-cluster/config.db.bak 2> /dev/null
     sqlite3 /var/lib/pve-cluster/config.db ".dump" | sqlite3 /var/lib/pve-cluster/config.db.bak
     sqlite3 /var/lib/pve-cluster/config.db.bak ".mode insert" ".output /var/lib/pve-cluster/config.db.sql.tmp1" ".dump" | sqlite3 /var/lib/pve-cluster/config.db.bak
     sqlformat --keywords upper --identifiers lower /var/lib/pve-cluster/config.db.sql.tmp1 > /var/lib/pve-cluster/config.db.sql.tmp2
     cat /var/lib/pve-cluster/config.db.sql.tmp2 | sed 's/tree (/tree (\n/g' | sed 's/VALUES(/VALUES(\n  /g' | sed 's-,-,\n  -g'  | sed 's-);-\n);\n-g' | sed 's-    -  -g' > /var/lib/pve-cluster/config.db.sql
     rm -f /var/lib/pve-cluster/config.db.sql.tmp1 2> /dev/null
     rm -f /var/lib/pve-cluster/config.db.sql.tmp2 2> /dev/null
     mv /var/lib/pve-cluster/config.db.bak /CopSegInt/$FechaDeEjec/BD/config.db
     mv /var/lib/pve-cluster/config.db.sql /CopSegInt/$FechaDeEjec/BD/config.db.sql
     echo "Este archivo debe ubicarse en /var/lib/pve-cluster/" > /CopSegInt/$FechaDeEjec/BD/UbicDelArchivoConfigDB.txt
   else
     echo ""
     echo "  El estado de la base de datos no es consistente. Intentando exportar lo que se pueda..."
     echo ""
     sqlite3 /var/lib/pve-cluster/config.db ".recover" | sqlite3 /var/lib/pve-cluster/config.db.recover
     sqlite3 /var/lib/pve-cluster/config.db ".dump" | sed -e 's|^ROLLBACK;\( -- due to errors\)*$|COMMIT;|g' | sqlite3 /var/lib/pve-cluster/config.db.dump-before-rollback
   fi

