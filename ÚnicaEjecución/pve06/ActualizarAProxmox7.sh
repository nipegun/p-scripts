#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------
#  Script de NiPeGun para actualizar Proxmox 6 a Proxmox 7
#-----------------------------------------------------------

MVIni=1
MVFin=9999

echo ""
echo "--------------------------------------------------------------------"
echo "  Iniciando el script de actualización de Proxmox 6 a Proxmox 7..."
echo "--------------------------------------------------------------------"
echo ""

if [ ! -f "/root/ActPVE6a7.txt" ]; then
  echo ""
  echo "  Actualizando Proxmox 6 a la última versión antes de actualizar a Proxmox 7..."
  echo ""
  apt-get -y update
  apt-get -y dist upgrade
  apt-get -y autoremove
fi

echo ""
echo "  Apagando todas las máquinas virtuales y contenedores..."
echo ""
for IdMV in $(seq $MVIni $MVFin);
  do
    qm shutdown $IdMV
  done

if [ ! -f "/root/ActPVE6a7.txt" ]; then
  echo ""
  echo "  Reiniciando el sistema..."
  echo ""
  touch /root/ActPVE6a7.txt
  shutdown -r now
fi

echo ""
echo "  Modificando repositorios..."
echo ""
sed -i -e 's|buster\/updates|bullseye-security|g' /etc/apt/sources.list
sed -i -e 's|buster|bullseye|g' /etc/apt/sources.list
sed -i -e 's|buster|bullseye|g' /etc/apt/sources.list.d/pve-enterprise.list
sed -i -e 's|buster|bullseye|g' /etc/apt/sources.list.d/pve-no-subscription.list
sed -i -e 's|buster|bullseye|g' /etc/apt/sources.list.d/pve-no-sub.list

""
"  Actualizando a la versión 7..."
""
apt-get -y update
apt-get -y dist-upgrade

