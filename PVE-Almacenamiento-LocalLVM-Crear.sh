#!/bin/bash



vIdUnidad='/dev/nvme1n1x'
vGigas='300G'


# Borrar las particiones
  wipefs -a "$vIdUnidad"

# Crear la PV:
  pvcreate "$vIdUnidad"

# Crear el VG llamado pve 
  vgcreate pve "$vIdUnidad"

# Crear el LV para usarlo como almacenamiento Proxmox (por ejemplo 300 GB):
  lvcreate -L "$vGigas" -n data pve

# Formatear el LV como LVM-Thin, que es lo que usa Proxmox para local-lvm:
  lvconvert --type thin-pool pve/data

# Crear el storage en Proxmox, usando la herramienta de PVE:
  pvesm add lvmthin local-lvm --vgname pve --thinpool data

# Notificar fin del script
  echo ""
  echo "  Almacenamiento local-lvm creado. Ya debería aparecer en la web para ser usado como almacenamiento local-lvm tradicional.
  echo ""
