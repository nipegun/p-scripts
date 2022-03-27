#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para importar una copia de seguridad de contenedor LXC
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/LXC-ExpandirDiscoAl100x100.sh | bash
#------------------------------------------------------------------------------------------------------------

# Determinar sistema de archivos
  SistArch=$(df -Th | grep "/dev/loop0" | tr -s ' ' | cut -d' ' -f2)
  if [[ $SistArch == "ext4" ]]; then
    echo "El sistema de archivo es ext4"
  fi

