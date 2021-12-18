#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para mostrar los kernels instalados en ProxmoxVE
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/Kernel-MostrarInstalados.sh | bash
#
#-------------------------------------------------------------------------------------------------------

echo ""
echo "  Kernels instalados en este servidor Proxmox:"
echo ""
dpkg-query -l | grep pve-kernel | cut -d ' ' -f3 | grep -v firmware | grep -v helper

