#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras># Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para apagar todas las máquinas virtuales
# ----------

lxcini=100
lxcfin=199

for vmid in $(seq $lxcini $lxcfin);
  do
    echo ""
    echo "  Apagando el contenedor LXC $vmid..."
    pct shutdown $vmid
    echo "  Estado del contenedor LXC $vmid:"
    pct status $vmid
  done

