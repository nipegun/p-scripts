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

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}  Iniciando script de copia de seguridad interna de ProxmoxVE...${FinColor}"
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
  echo "  Haciendo copia de seguridad de la carpeta /etc/..."
  echo ""
  cp -L -r /etc/* /CopSegInt/$vFechaDeEjec/etc/

# Ejecutar copia de seguridad de /root/
  echo ""
  echo "  Haciendo copia de seguridad de la carpeta /root/..."
  echo ""
  cp -L -r /root/* /CopSegInt/$vFechaDeEjec/root/

# Ejecutar copia de seguridad de la base de datos
  echo ""
  echo "  Haciendo copia de seguridad de la base de datos..."
  echo ""
  vEstadoDeLaBaseDeDatosDePVE=$(sqlite3 /var/lib/pve-cluster/config.db "PRAGMA integrity_check;")
  if [ $vEstadoDeLaBaseDeDatosDePVE == "ok" ]; then
    echo ""
    echo "    El estado de la base de datos es consistente. Procediendo con la copia de seguridad..."
    echo ""
    rm -f /var/lib/pve-cluster/config.db.sql 2> /dev/null
    rm -f /var/lib/pve-cluster/config.db.bak 2> /dev/null
    sqlite3 /var/lib/pve-cluster/config.db ".dump" | sqlite3 /var/lib/pve-cluster/config.db.bak
    sqlite3 /var/lib/pve-cluster/config.db.bak ".mode insert" ".output /var/lib/pve-cluster/config.db.sql.tmp1" ".dump" | sqlite3 /var/lib/pve-cluster/config.db.bak
    # Comprobar si el paquete sqlformat está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s sqlformat 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  sqlformat no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install sqlformat
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
    echo "    El estado de la base de datos no es consistente. Intentando exportar lo que se pueda..."
    echo ""
    sqlite3 /var/lib/pve-cluster/config.db ".recover" | sqlite3 /var/lib/pve-cluster/config.db.recover
    sqlite3 /var/lib/pve-cluster/config.db ".dump" | sed -e 's|^ROLLBACK;\( -- due to errors\)*$|COMMIT;|g' | sqlite3 /var/lib/pve-cluster/config.db.dump-before-rollback
  fi

# Crear copia de seguridad del tree
  sqlite3 /var/lib/pve-cluster/config.db 'select * from tree;' > /CopSegInt/$vFechaDeEjec/BD/tree.txt


# Crear copia de seguridad de los archivos de dentro de la base de datos
  # /etc/pve/firewall/
    /etc/pve/firewall/cluster.fw                  # Firewall configuration applied to all nodes
    /etc/pve/firewall/*.fw                        # Firewall configuration for individual nodes
    /etc/pve/firewall/*.fw                        # Firewall configuration for VMs and containers
  # /etc/pve/ha/
    /etc/pve/ha/crm_commands                      # Displays HA operations that are currently being carried out by the CRM
    /etc/pve/ha/manager_status                    # JSON-formatted information regarding HA services on the cluster
    /etc/pve/ha/resources.cfg                     # Resources managed by high availability, and their current state
  # /etc/pve/local/       (Enlace simbólico a /etc/pve/nodes/<LOCAL_HOST_NAME>)
    #
  # /etc/pve/lxc/         (Enlace simbólico a /etc/pve/nodes/<LOCAL_HOST_NAME>/lxc/)
    #
  # /etc/pve/nodes/
    # Obtener el nombre del nodo
      vNombreNodo=$(ls /etc/pve/nodes/ | cut -d' ' -f1)
    /etc/pve/nodes/$vNombreNodo/lxc/*.conf              # VM configuration data for LXC containers
    /etc/pve/nodes/$vNombreNodo/openvz/*                # Prior to PVE 4.0, used for container configuration data (deprecated, removed soon)
    /etc/pve/nodes/$vNombreNodo/priv/*
    /etc/pve/nodes/$vNombreNodo/qemu-server/*.conf      # VM configuration data for KVM VMs
    /etc/pve/nodes/$vNombreNodo/pve-ssl.key             # Private SSL key for pve-ssl.pem
    /etc/pve/nodes/$vNombreNodo/pve-ssl.pem             # Public SSL certificate for web server (signed by cluster CA)
    /etc/pve/nodes/$vNombreNodo/pveproxy-ssl.key        # Private SSL key for pveproxy-ssl.pem (optional)
    /etc/pve/nodes/$vNombreNodo/pveproxy-ssl.pem        # Public SSL certificate (chain) for web server (optional override for pve-ssl.pem)
    /etc/pve/nodes/$vNombreNodo/config                  # Node-specific configuration
  # /etc/pve/openvz/      (Enlace simbólico a /etc/pve/nodes/<LOCAL_HOST_NAME>/openvz/ (deprecated, removed soon))
    #
  # /etc/pve/priv/
    /etc/pve/priv/acme/*
    /etc/pve/priv/lock/*                  # Lock files used by various services to ensure safe cluster-wide operations
    /etc/pve/priv/storage/*.pw            # Contains the password of a storage in plain text
    /etc/pve/priv/authkey.key             # Private key used by ticket system
    /etc/pve/priv/authorized_keys         # SSH keys of cluster members for authentication
    /etc/pve/priv/ceph*                   # Ceph authentication keys and associated capabilities
    /etc/pve/priv/known_hosts             # SSH keys of the cluster members for verification
    /etc/pve/priv/pve-root-ca.key         # Private key of cluster CA
    /etc/pve/priv/pve-root-ca.srl
    /etc/pve/priv/shadow.cfg              # Shadow password file for PVE Realm users
    /etc/pve/priv/token.cfg               # API token secrets of all tokens
    /etc/pve/priv/tfa.cfg                 # Base64-encoded two-factor authentication configuration
  # /etc/pve/qemu-server/ (Enlace simbólico a /etc/pve/nodes/<LOCAL_HOST_NAME>/qemu-server/)    
    #
  # /etc/pve/sdn/
    /etc/pve/sdn/*           # Shared configuration files for Software Defined Networking (SDN)
  # /etc/pve/virtual-guest/
    /etc/pve/virtual-guest/cpu-models.conf # For storing custom CPU models
  # /etc/pve/*
    /etc/pve/.clusterlog      # Cluster log (last 50 entries)
    /etc/pve/.debug
    /etc/pve/.members         # Info about cluster members
    /etc/pve/.rrd             # RRD data (most recent entries)
    /etc/pve/.version         # File versions (to detect file modifications)
    /etc/pve/.vmlist          # List of all VMs
    /etc/pve/authkey.pub      # Public key used by the ticket system
    /etc/pve/ceph.conf        # Ceph configuration file (note: /etc/ceph/ceph.conf is a symbolic link to this)
    /etc/pve/corosync.conf    # Corosync cluster configuration file (prior to Proxmox VE 4.x, this file was called cluster.conf)
    /etc/pve/datacenter.cfg   # Proxmox VE data center-wide configuration (keyboard layout, proxy, …)
    /etc/pve/domains.cfg      # Proxmox VE authentication domains
    /etc/pve/pve-root-ca.pem  # Public certificate of cluster CA
    /etc/pve/pve-www.key      # Private key used for generating CSRF tokens
    /etc/pve/status.cfg       # Proxmox VE external metrics server configuration
    /etc/pve/replication.conf
    /etc/pve/storage.cfg      # Proxmox VE storage configuration
    /etc/pve/user.cfg         # Proxmox VE access control configuration (users/groups/…)
    /etc/pve/vzdump.cron      # Cluster-wide vzdump backup-job schedule

