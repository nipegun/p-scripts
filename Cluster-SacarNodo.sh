#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------
#  Script de NiPeGun para borrar el cluster de Proxmox
#-------------------------------------------------------

## Detener el servicio de cluster
   systemctl stop pve-cluster

## x
   pmxcfs -l

## Borrar archivos de configuración del cluster existente
   rm -f /etc/pve/cluster.conf
   rm -f /etc/pve/corosync.conf
   rm -f /etc/cluster/cluster.conf
   rm -f /etc/corosync/corosync.conf

## Borrar el archivo x
   rm /var/lib/pve-cluster/.pmxcfs.lockfile

## Borrar la clave de autenticación
   rm -f /etc/corosync/authkey

#sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/GNUstep/gdomap_probes
#sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/hosts
#sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/issue
#sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/pve/.members
#sed -i -e 's|192.168.0.10|192.168.1.200|g' /etc/pve/priv/known_hosts

## Arrancar el servicio del cluster
   systemctl start pve-cluster

