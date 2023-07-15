#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para parchear el OVMF de Clover para que pueda usarse Clover BootLoader
# ----------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "$0 ${ColorVerde}Parcheando OVMF para ser utilizado por Clover...${FinColor}"
echo ""

# Agregar el locale que falta
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
export LC_ALL=en_US.UTF-8

# Agregar herramientas necesarias para compilar
apt update
apt -y install build-essential git lintian debhelper iasl nasm python uuid-dev gcc-aarch64-linux-gnu bc python3-distutils

# Clonar el repo
mkdir /root/CodFuente 2> /dev/null
cd /root/CodFuente
rm -rf /root/CodFuente/pve-edk2-firmware/
git clone -b macos-support-proxmox-6.1 https://github.com/thenickdude/pve-edk2-firmware.git

# Preparar paquete
cd pve-edk2-firmware
make

# Instalar
mv /root/pve-edk2-firmware/ /root/CodFuente/pve-edk2-firmware/
find /root/CodFuente/pve-edk2-firmware -type f -name pve-edk2-firmware*.deb -exec bash -c 'mv "$0" "/root/CodFuente/pve-edk2-firmware/OVMFCloverPatch.deb" ' {} \;
dpkg -i /root/CodFuente/pve-edk2-firmware/OVMFCloverPatch.deb

echo ""
echo "Ejecución del script, finalizada."
echo ""

