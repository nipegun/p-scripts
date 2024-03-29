#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear una Autoridad Certificadora en el host de ProxmoxVE 5
# ----------

wget --no-check-certificate -P /root/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz
tar xvf /root/EasyRSA-unix-v3.0.6.tgz -C /root/
mv /root/EasyRSA-v3.0.6 /root/EasyRSA
cp /root/EasyRSA/vars.example /root/EasyRSA/vars
sed -i -e 's|#set_var EASYRSA_REQ_COUNTRY    "US"|set_var EASYRSA_REQ_COUNTRY                          "ES"|g' /root/EasyRSA/vars
sed -i -e 's|#set_var EASYRSA_REQ_PROVINCE   "California"|set_var EASYRSA_REQ_PROVINCE             "Madrid"|g' /root/EasyRSA/vars
sed -i -e 's|#set_var EASYRSA_REQ_CITY       "San Francisco"|set_var EASYRSA_REQ_CITY              "Madrid"|g' /root/EasyRSA/vars
sed -i -e 's|#set_var EASYRSA_REQ_ORG        "Copyleft Certificate Co"|set_var EASYRSA_REQ_ORG    "Empresa"|g' /root/EasyRSA/vars
sed -i -e 's|#set_var EASYRSA_REQ_EMAIL      "me@example.net"|set_var EASYRSA_REQ_EMAIL  "mail@empresa.com"|g' /root/EasyRSA/vars
sed -i -e 's|#set_var EASYRSA_REQ_OU         "My Organizational Unit"|set_var EASYRSA_REQ_OU "Departamento"|g' /root/EasyRSA/vars
cd /root/EasyRSA/
/root/EasyRSA/easyrsa init-pki
/root/EasyRSA/easyrsa build-ca nopass
mkdir /root/EasyRSA/imported/

