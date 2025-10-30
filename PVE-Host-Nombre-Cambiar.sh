#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar el nombre de un servidor Proxmox
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/PVE-Host-Nombre-Cambiar.sh | bash -s NombreNuevo
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/PVE-Host-Nombre-Cambiar.sh | bash -s NombreNuevo
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

cCantArgumEsperados=1

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de nombre del host Proxmox...${cFinColor}"
  echo ""

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 NombreNuevo"
    echo ""
    echo "Ejemplo:"
    echo "$0 perro gato"
    echo "##################################################"
    echo ""
    exit
  else
      # Obtener el nombre actual del host
        vNombreActual=$(hostname)
      # Guardar en una variable el nombre que se ha pasado por parámetro
        vNombreNuevo="$1"
        
      # Verificar si el nodo está en un cluster

      # Si está en un cluster, sacar el nodo del cluster
        pvecm delnode <nombre_antiguo>

      # Luego unirse nuevamente al cluster usando el nuevo nombre
          pvecm add <ip-del-master>)

      # Si estás en cluster
        pvecm nodes

    # Notificar

      echo ""
      echo "    Cambiando el nombre del host de $vNombreActual a $vNombreNuevo..."
      echo "    Dependiendo de la velocidad del procesador y de la unidad donde está instalado Proxmox, la operación puede tardar más de 10 minutos..."
      echo "    Al finalizar, se le preguntará al usuario si quiere reiniciar PVE. Es aconsejado hacerlo."
      echo ""

      # Parar servicios
        systemctl stop pveproxy && systemctl stop pvedaemon && systemctl stop pve-cluster && systemctl stop corosync

      # Hacer copia de seguridad de la base de datos
        cp -fv /var/lib/pve-cluster/config.db /root/config.db.bak

      # Modificar la base de datos
        sqlite3 /var/lib/pve-cluster/config.db "UPDATE tree SET data = REPLACE(data, '$vNombreActual', '$vNombreNuevo');"
        sqlite3 /var/lib/pve-cluster/config.db "UPDATE tree SET name = REPLACE(name, '$vNombreActual', '$vNombreNuevo');"

      # Listar la modificación
        sqlite3 /var/lib/pve-cluster/config.db "SELECT* FROM tree;"

      # Modificar /etc/hosts
        sed -i "s|$vNombreActual|$vNombreNuevo|g" /etc/hosts

      # Cambiar el hostname
        hostnamectl set-hostname "$vNombreNuevo"
  
      # Reiniciar servicios
        systemctl start corosync && systemctl start pve-cluster && systemctl start pvedaemon && systemctl start pveproxy
  
      # Comprobar que el nodo se haya levantado con el nuevo nombre y proseguir con el renombrado del resto de archivos del sistema
        if [ -d /etc/pve/nodes/"$vNombreNuevo"  ]; then
          echo ""
          echo "  La carpeta /etc/pve/nodes/"$vNombreNuevo" existe. El nodo se ha renombrado correctamente!"
          echo ""
          echo "    Iniciando el reemplazo de la cadena $vNombreActual por la cadena $vNombreNuevo en todos los archivos del sistema..."
          echo ""
          find /bin        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /boot       -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /dev        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /etc        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /home       -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /lib        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /lib64      -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /lost+found -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /media      -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /mnt        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /opt        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /root       -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /run        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /sbin       -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /srv        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /tmp        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /usr        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          find /var        -type f -exec sed -i -e "s|$vNombreActual|$vNombreNuevo|g" {} \;
          echo ""
          # Notificar del cambio y pedir aceptar
            echo ""
            echo "    Se reemplazó el texto $vNombreActual por $vNombreNuevo en todos los archivos del sistema."
            echo ""
            read -p "      Presiona cualquier tecla reiniciar el sistema o presiona CTRL+C para saltar a la terminal"
            shutdown -r now
        fi

fi

