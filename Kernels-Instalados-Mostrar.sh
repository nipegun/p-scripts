#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar los kernels instalados en ProxmoxVE
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/Kernels-Instalados-Mostrar.sh | bash
# ----------

# Determinar kernels instalados
  apt list --installed | grep pve-kernel | grep -v all | cut -d'/' -f1 &2> /tmp/KernelsInstalados.txt
  cat /tmp/KernelsInstalados.txt | grep pve-kernel > /tmp/KernelsInstalados.txt
# Mostrar los kernels instalados
  echo ""
  echo "  Kernels instalados en este servidor Proxmox:"
  echo ""
  cat /tmp/KernelsInstalados.txt
  echo ""

