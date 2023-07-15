#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar el cluster de Proxmox
# ----------

# Detener el servicio de cluster
  echo ""
  echo "  Deteniendo el servicio de clúster..."
  echo ""
  systemctl stop pve-cluster

# Mostrar información de los servicios de configuración distribuida
  echo ""
  echo "  Mostrando información de los servicios de configuración distribuida..."
  echo ""
  pmxcfs -l

# Borrar archivos de configuración del cluster existente
  echo ""
  echo "  Borrando archivos de configuración del cluster existente..."
  echo ""
  rm -f /etc/pve/cluster.conf
  rm -f /etc/pve/corosync.conf
  rm -f /etc/cluster/cluster.conf
  rm -f /etc/corosync/corosync.conf

# Borrar el archivo de bloqueo
  echo ""
  echo "  Borrando el archivo de bloqueo..."
  echo ""
  rm /var/lib/pve-cluster/.pmxcfs.lockfile

# Borrar la clave de autenticación de CoroSync
  echo ""
  echo "  Borrando la clave de autenticación de CoroSync..."
  echo ""
  rm -f /etc/corosync/authkey

# Borrar referencias a la IP
  #sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/GNUstep/gdomap_probes
  #sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/hosts
  #sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/issue
  #sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/pve/.members
  #sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/pve/priv/known_hosts

# Volver a iniciar el servicio del clúster
  echo ""
  echo "  Volviendo a iniciar el servicio del cúster..."
  echo ""
  systemctl start pve-cluster

