#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para importar una copia de seguridad de contenedor LXC
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/LXC-ExpandirPartRootAlMax.sh | bash -s NumContainer
#--------------------------------------------------------------------------------------------------------------------------

# Determinar sistema de archivos
#  SistArch=$(df -Th | grep "/dev/loop0" | tr -s ' ' | cut -d' ' -f2)
#  if [[ $SistArch == "ext4" ]]; then
#    echo "  Expandiendo /dev/loop0 con sistema de archivoms ext4 al 100% de la capacidad disponible."
#    
#    df -Th
#  fi

vNombreAlmacenamiento=$(cat /etc/pve/lxc/$1.conf | grep rootfs | sed 's- --g' | cut -d':' -f2)
vArchivoDeDisco=$(cat /etc/pve/lxc/$1.conf | grep rootfs | cut -d'/' -f2 | cut -d',' -f1)
vCarpetaAlmacenamiento=$(cat /etc/pve/storage.cfg | grep -m2 $vNombreAlmacenamiento | tail -n1 | sed 's- --g' | cut -d'h' -f2)

echo "vNombreAlmacenamiento = $vNombreAlmacenamiento"
echo "vArchivoDeDisco = $vArchivoDeDisco"
echo "vCarpetaAlmacenamiento = $vCarpetaAlmacenamiento"

ls -l  $vCarpetaAlmacenamiento/images/$1/$vArchivoDeDisco
# umount /media/root/26d50c38-9af5-4bb0-a749-751d6f4fbca4
# tune2fs -f -E clear_mmp /PVE/images/201/vm-201-disk-0.raw
# e2fsck -f /PVE/images/201/vm-201-disk-0.raw
# resize2fs /PVE/images/201/vm-201-disk-0.raw
