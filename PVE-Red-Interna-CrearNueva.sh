#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para crear una red interna en Proxmox (host-only bridge)
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-RedInterna-CrearNueva.sh | bash
# ----------

echo ""                           >> /etc/network/interfaces
echo "auto vmbr20"                >> /etc/network/interfaces
echo "  iface vmbr20 inet static" >> /etc/network/interfaces
echo "  bridge_ports none"        >> /etc/network/interfaces
echo "  bridge_stp off"           >> /etc/network/interfaces
echo "  bridge_fd 0"              >> /etc/network/interfaces
echo "#RedInterna"                >> /etc/network/interfaces
systemctl restart networking

