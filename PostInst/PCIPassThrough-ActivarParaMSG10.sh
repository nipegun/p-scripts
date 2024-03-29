#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para activar PCI passthrough en el MicroServer Gen10 
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'


sed -i -e 's|GRUB_CMDLINE_LINUX_DEFAULT="quiet"|GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt pcie_acs_override=downstream"|g' /etc/default/grub
update-grub

echo "vfio"             >> /etc/modules
echo "vfio_iommu_type1" >> /etc/modules
echo "vfio_pci"         >> /etc/modules
echo "vfio_virqfd"      >> /etc/modules

echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/pci-passthrough.conf
update-initramfs -u -k all

echo ""
echo -e "${cColorVerde}PCI Passthrough estará disponible a partir del próximo reinicio.${cFinColor}"
echo -e "${cColorVerde}Si quieres reiniciar el sistema ahora, ejecuta: shutdown -r now.${cFinColor}"
echo ""

