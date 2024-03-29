#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para permitir los puertos comunes en el cortafuegos del cluster de Proxmox
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PostInst/Cluster-Cortafuegos-CrearReglasPorDefecto.sh | bash
# ----------

# Esto se hace para no dejar el cluster enjaulado si cambiamos sin querer la política de entrada a drop
# Antes debes activar el firewall

echo ""
echo "  Creando reglas por defecto para el cluster..."
echo ""

if [ -f /etc/pve/firewall/cluster.fw ]; then
  echo "[OPTIONS]"                                > /etc/pve/firewall/cluster.fw
  echo ""                                        >> /etc/pve/firewall/cluster.fw
  echo "policy_in: ACCEPT"                       >> /etc/pve/firewall/cluster.fw
  echo "enable: 1"                               >> /etc/pve/firewall/cluster.fw
  echo ""                                        >> /etc/pve/firewall/cluster.fw
  echo "[RULES]"                                 >> /etc/pve/firewall/cluster.fw
  echo ""                                        >> /etc/pve/firewall/cluster.fw
  echo "IN ACCEPT -p tcp -dport 8006 -log nolog" >> /etc/pve/firewall/cluster.fw
  echo "IN SSH(ACCEPT) -log nolog"               >> /etc/pve/firewall/cluster.fw
  echo "IN RDP(ACCEPT) -log nolog"               >> /etc/pve/firewall/cluster.fw
  echo "OUT DNS(ACCEPT) -log nolog"              >> /etc/pve/firewall/cluster.fw
  echo "IN DNS(ACCEPT) -log nolog"               >> /etc/pve/firewall/cluster.fw
  echo "OUT Ping(ACCEPT) -log nolog"             >> /etc/pve/firewall/cluster.fw
  echo "IN Ping(ACCEPT) -log nolog"              >> /etc/pve/firewall/cluster.fw
  echo "OUT Web(ACCEPT) -log nolog"              >> /etc/pve/firewall/cluster.fw
  echo "IN Web(ACCEPT) -log nolog"               >> /etc/pve/firewall/cluster.fw
  echo "IN SMB(ACCEPT) -log nolog"               >> /etc/pve/firewall/cluster.fw
else
  echo ""
  echo "  Todavía no has activado el cortafuegos del centro de datos."
  echo "  Ve a la interfaz web de Proxmox >> Centro de Datos >> Cortafuego >> Opciones,"
  echo "  pon cortafuego en SI y vuelve a ejecutar este script."
  echo ""
fi

