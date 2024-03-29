#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para activar el autologueo del usuario minerocrp en un contenedor LXC de Debian
#
# Ejecución con curl:
#  curl --silent https://raw.githubusercontent.com/nipegun/p-scripts/master/InteriorDelContainer/LXC-Debian-Usuarios-AutoLogueo-minerocrp-Activar.sh | bash
#
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Proxmox
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de activación de autologueo en modo texto"
  echo "  del usuario minerocrp en el contenedor LXC de Debian 7..."
  echo ""

  echo ""
  echo "  Comandos para el contenedor LXC de Debian 7 todavía no preparados."
  echo "  Prueba ejecutar el script en otro contenedor LXC con otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de activación de autologueo en modo texto"
  echo "  del usuario minerocrp en el contenedor LXC de Debian 8..."
  echo ""

  echo ""
  echo "  Comandos para el contenedor LXC de Debian 8 todavía no preparados."
  echo "  Prueba ejecutar el script en otro contenedor LXC con otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de activación de autologueo en modo texto"
  echo "  del usuario minerocrp en el contenedor LXC de Debian 9..."
  echo ""

  echo ""
  echo "  Comandos para el contenedor LXC de Debian 9 todavía no preparados."
  echo "  Prueba ejecutar el script en otro contenedor LXC con otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de activación de autologueo en modo texto"
  echo "  del usuario minerocrp en el contenedor LXC de Debian 10..."
  echo ""

  echo ""
  echo "  Comandos para el contenedor LXC de Debian 10 todavía no preparados."
  echo "  Prueba ejecutar el script en otro contenedor LXC con otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de activación de autologueo en modo texto"
  echo "  del usuario minerocrp en el contenedor LXC de Debian 11..."
  echo ""

  # Se debe reemplazar la línea
  # ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear --keep-baud tty%I 115200,38400,9600 $TERM
  # por
  # ExecStart=-/sbin/agetty --noclear -a minerocrp --keep-baud tty%I 115200,38400,9600 $TERM
  # en el archivo
  # /lib/systemd/system/container-getty@.service
  #
  # Nota:
  # -o '-p -- \\u' es para que pida el password

  # Esta solución es temporal y puede que se revierta en alguna actualización del sistema

  # Borrar la línea que empieza por ExecStart
     sed -i '/^ExecStart/d' /lib/systemd/system/container-getty@.service
  # Reemplazar la línea Type=idle por la línea de ejecucion, un saldo de línea y nuevamente type idle
     sed -i -e 's|Type=idle|ExecStart=-/sbin/agetty --noclear -a minerocrp --keep-baud tty%I 115200,38400,9600 $TERM\nType=idle|g' /lib/systemd/system/container-getty@.service

fi

