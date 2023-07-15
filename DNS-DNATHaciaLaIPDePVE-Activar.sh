#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para activar el reenvio de todo el tráfico DNS hacia la IP de Proxmox
# ----------

cColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
ColorFin='\033[0m'

RangoDeIPsDeLasMVs="192.168.0.201-192.168.0.254"
IPDePVE="127.0.0.1"

echo ""
echo -e "${cColorVerde}Activando el reenvio del tráfico DNS hacia la IP del puente (vmbr0)...${ColorFin}"
echo ""

# Comprobar si el paquete nftables está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s nftables 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "nftables no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install nftables
fi

# Borrar reenvío previo, si es que existe.
/root/scripts/p-scripts/DNS-DNATHaciaLaIPDePVE-Desactivar.sh

# Crear el archivo con las reglas
echo "table NAT {"                                                         > /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo ""                                                                   >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "  chain prerouting {"                                               >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "    type nat hook prerouting priority 0"                            >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "    tcp dport   53 ip saddr $RangoDeIPsDeLasMVs dnat $IPDePVE:53"   >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "    udp dport   53 ip saddr $RangoDeIPsDeLasMVs dnat $IPDePVE:53"   >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "    tcp dport  853 ip saddr $RangoDeIPsDeLasMVs dnat $IPDePVE:853"  >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "    udp dport  853 ip saddr $RangoDeIPsDeLasMVs dnat $IPDePVE:853"  >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "    tcp dport 5353 ip saddr $RangoDeIPsDeLasMVs dnat $IPDePVE:5353" >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "    udp dport 5353 ip saddr $RangoDeIPsDeLasMVs dnat $IPDePVE:5353" >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "  }"                                                                >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo ""                                                                   >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft
echo "}"                                                                  >> /root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft

# Incluir el archivo con las reglas en el archivo de configuración de NFTables
sed -i '/^flush ruleset/a include "/root/scripts/NFTables-DNS-DNATHaciaLaIPDePVE.nft"' /etc/nftables.conf
sed -i -e 's|flush ruleset|flush ruleset\n|g' /etc/nftables.conf

# Recargar NFTables
nft --file /etc/nftables.conf

