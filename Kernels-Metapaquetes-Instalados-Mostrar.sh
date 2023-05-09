#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar los metapaquetes de kernels instalados en ProxmoxVE
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/Kernels-Metapaquetes-Instalados-Mostrar.sh | bash
# ----------

# Determinar metapaquetes de kernels instalados
  apt list --installed 2> /dev/null | grep pve-kernel | grep all | cut -d'/' -f1 > /tmp/KernelsMetapaquetesInstalados.txt
# Mostrar los metapaquetes de kernels instalados
  echo ""
  echo "  Kernels instalados en este servidor Proxmox:"
  echo ""
  cat /tmp/KernelsMetapaquetesInstalados.txt
  echo ""
