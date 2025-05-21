#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para importar las diferentes máquinas virtuales de Forti en Proxmox
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Forti-Instalar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Forti-Instalar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Forti-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Determinar la versión de Proxmox
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Proxmox sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/Proxmox_version ]; then       # Para versiones viejas de Proxmox.
    cNomSO=Proxmox
    cVerSO=$(cat /etc/Proxmox_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Proxmox detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación de máquinas virtuales de Forti para Proxmox 9...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Proxmox 9 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación de máquinas virtuales de Forti para Proxmox 8...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          apt-get -y update
          apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "FortiADC"      off
          2 "FortiAnalyzer" off
          3 "FortiFirewall" off
          4 "FortiGate"     off
          5 "FortiManager"  off
          6 "FortiWeb"      off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              vUltVersFortiADC="7.6.3"
              echo ""
              echo "  Importando la máquina virtual de FortiADC v$vUltVersFortiADC..."
              echo ""

              # Crear la máquina virtual
                qm create 4001 \
                  --name FortiADC \
                  --machine q35 \
                  --numa 0 \
                  --sockets 1 \
                  --cpu x86-64-v2-AES \
                  --cores 2 \
                  --memory 4096 \
                  --balloon 0 \
                  --net0 virtio,bridge=vmbr0,firewall=1 \
                  --net1 virtio=00:af:aa:e1:40:01,bridge=vmbr0,firewall=1 \
                  --net2 virtio=00:af:aa:e2:40:01,bridge=vmbr1,firewall=1 \
                  --boot order=virtio0 \
                  --scsihw virtio-scsi-single \
                  --ostype l26 \
                  --agent 1

              # Descargar los archivos de disco duro
                curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Forti/FortiADC763boot.qcow2 -o /tmp/FortiADC763boot.qcow2
                curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Forti/FortiADC763data.qcow2 -o /tmp/FortiADC763data.qcow2
              # Convertir los archivos a RAW
#                qemu-img convert -O raw /tmp/FortiADC763boot-temp.qcow2 /tmp/FortiADC763boot.raw
#                qemu-img convert -O raw /tmp/FortiADC763data-temp.qcow2 /tmp/FortiADC763data.raw
              # Truncar las imágenes a múltiplo de 512 bytes
#                vTamArchivo=$(stat -c %s /tmp/FortiADC763boot.raw)
#                vTamAlineado=$(( vTamArchivo - (filesize % 512) ))
#                truncate -s "$vTamAlineado" /tmp/FortiADC763boot.raw
#                vTamArchivo=$(stat -c %s /tmp/FortiADC763data.raw)
#                vTamAlineado=$(( vTamArchivo - (filesize % 512) ))
#                truncate -s "$vTamAlineado" /tmp/FortiADC763data.raw
              # Importar los discos
                qm importdisk 4001 /tmp/FortiADC763boot.qcow2 "$vAlmacenamiento" && rm -f /tmp/FortiADC763boot.qcow2
                qm importdisk 4001 /tmp/FortiADC763data.qcow2 "$vAlmacenamiento" && rm -f /tmp/FortiADC763data.qcow2
              # Asignar los discos a la máquina virtual
                vRutaAlDisco=$(qm config 4001 | grep unused | cut -d' ' -f2 | head -n1)
                qm set 4001 --virtio0 "$vRutaAlDisco",format=raw,cache=writeback,aio=threads
                vRutaAlDisco=$(qm config 4001 | grep unused | cut -d' ' -f2 | head -n1)
                qm set 4001 --virtio1 "$vRutaAlDisco",format=raw,cache=writeback,aio=threads

              # Crear la nota para la máquina virtual
                sed -i '1i#<p>Usuario: admin</p><p>Contraseña: vacía</p><br><p>En el primer inicio de sesión pedirá que se asigne una nueva contraseña.</p>' /etc/pve/qemu-server/4001.conf

            ;;

            2)

              vUltVersFortiAnalyzer="7.6.3"
              echo ""
              echo "  Importando la máquina virtual de FortiAnalyzer v$vUltVersFortiAnalyzer..."
              echo ""

              # Crear la máquina virtual
                qm create 4002 \
                  --name FortiAnalyzer \
                  --machine q35 \
                  --numa 0 \
                  --sockets 1 \
                  --cpu x86-64-v2-AES \
                  --cores 2 \
                  --memory 2048 \
                  --balloon 0 \
                  --net0 virtio,bridge=vmbr0,firewall=1 \
                  --net1 virtio=00:af:aa:e1:40:02,bridge=vmbr0,firewall=1 \
                  --net2 virtio=00:af:aa:e2:40:02,bridge=vmbr50,firewall=1 \
                  --boot order=virtio0 \
                  --scsihw virtio-scsi-single \
                  --ostype l26 \
                  --agent 1

              # Descargar el archivo de disco duro
                curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Forti/FortiAnalyzer763.qcow2 -o /tmp/FortiAnalyzer763.qcow2
              # Importar el disco
                qm importdisk 4002 /tmp/FortiAnalyzer763.qcow2 "$vAlmacenamiento" && rm -f /tmp/FortiAnalyzer763.qcow2
              # Asignar los discos a la máquina virtual
                vRutaAlDisco=$(qm config 4002 | grep unused | cut -d' ' -f2 | head -n1)
                qm set 4002 --virtio0 "$vRutaAlDisco",format=raw,cache=writeback,aio=threads

            ;;

            3)

              vUltVersFortiFirewall="7.6.3"
              echo ""
              echo "  Importando la máquina virtual de FortiFirewall v$vUltVersFortiFirewall..."
              echo ""

              # Crear la máquina virtual
                qm create 4003 \
                  --name FortiFirewall \
                  --machine q35 \
                  --numa 0 \
                  --sockets 1 \
                  --cpu x86-64-v2-AES \
                  --cores 2 \
                  --memory 2048 \
                  --balloon 0 \
                  --net0 virtio,bridge=vmbr0,firewall=1 \
                  --net1 virtio=00:af:aa:e1:40:03,bridge=vmbr0,firewall=1 \
                  --net2 virtio=00:af:aa:e2:40:03,bridge=vmbr1,firewall=1 \
                  --boot order=virtio0 \
                  --scsihw virtio-scsi-single \
                  --ostype l26 \
                  --agent 1

              # Descargar el archivo de disco duro
                curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Forti/FortiFirewall763.qcow2 -o /tmp/FortiFirewall763.qcow2
              # Importar el disco
                qm importdisk 4003 /tmp/FortiFirewall763.qcow2 "$vAlmacenamiento" && rm -f /tmp/FortiFirewall763.qcow2
              # Asignar los discos a la máquina virtual
                vRutaAlDisco=$(qm config 4003 | grep unused | cut -d' ' -f2 | head -n1)
                qm set 4003 --virtio0 "$vRutaAlDisco",format=raw,cache=writeback,aio=threads

            ;;

            4)

              vUltVersFortiGate="7.6.3"
              echo ""
              echo "  Importando la máquina virtual de FortiGate v$vUltVersFortiGate..."
              echo ""

              # Crear la máquina virtual
                qm create 4004 \
                  --name FortiGate \
                  --machine q35 \
                  --numa 0 \
                  --sockets 1 \
                  --cpu x86-64-v2-AES \
                  --cores 2 \
                  --memory 2048 \
                  --balloon 0 \
                  --net0 virtio,bridge=vmbr0,firewall=1 \
                  --net1 virtio=00:af:aa:e1:40:04,bridge=vmbr0,firewall=1 \
                  --net2 virtio=00:af:aa:e2:40:04,bridge=vmbr1,firewall=1 \
                  --boot order=virtio0 \
                  --scsihw virtio-scsi-single \
                  --ostype l26 \
                  --agent 1

              # Descargar el archivo de disco duro
                curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Forti/FortiGate763.qcow2 -o /tmp/FortiGate763.qcow2
              # Importar el disco
                qm importdisk 4004 /tmp/FortiGate763.qcow2 "$vAlmacenamiento" && rm -f /tmp/FortiGate763.qcow2
              # Asignar los discos a la máquina virtual
                vRutaAlDisco=$(qm config 4004 | grep unused | cut -d' ' -f2 | head -n1)
                qm set 4004 --virtio0 "$vRutaAlDisco",format=raw,cache=writeback,aio=threads

            ;;

            5)

              vUltVersFortiManager="7.6.3"
              echo ""
              echo "  Importando la máquina virtual de FortiManager v$vUltVersFortiManager..."
              echo ""

              # Crear la máquina virtual
                qm create 4005 \
                  --name FortiManager \
                  --machine q35 \
                  --numa 0 \
                  --sockets 1 \
                  --cpu x86-64-v2-AES \
                  --cores 2 \
                  --memory 2048 \
                  --balloon 0 \
                  --net0 virtio,bridge=vmbr0,firewall=1 \
                  --net1 virtio=00:af:aa:e1:40:05,bridge=vmbr0,firewall=1 \
                  --net2 virtio=00:af:aa:e2:40:05,bridge=vmbr1,firewall=1 \
                  --boot order=virtio0 \
                  --scsihw virtio-scsi-single \
                  --ostype l26 \
                  --agent 1

              # Descargar el archivo de disco duro
                curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Forti/FortiManager763.qcow2 -o /tmp/FortiManager763.qcow2
              # Importar el disco
                qm importdisk 4005 /tmp/FortiManager763.qcow2 "$vAlmacenamiento" && rm -f /tmp/FortiManager763.qcow2
              # Asignar los discos a la máquina virtual
                vRutaAlDisco=$(qm config 4005 | grep unused | cut -d' ' -f2 | head -n1)
                qm set 4005 --virtio0 "$vRutaAlDisco",format=raw,cache=writeback,aio=threads

            ;;

            6)

              vUltVersFortiWeb="7.6.3"
              echo ""
              echo "  Importando la máquina virtual de FortiWeb v$vUltVersFortiWeb..."
              echo ""

              # Crear la máquina virtual
                qm create 4006 \
                  --name FortiWeb \
                  --machine q35 \
                  --numa 0 \
                  --sockets 1 \
                  --cpu x86-64-v2-AES \
                  --cores 2 \
                  --memory 2048 \
                  --balloon 0 \
                  --net0 virtio,bridge=vmbr0,firewall=1 \
                  --net1 virtio=00:af:aa:e1:40:06,bridge=vmbr0,firewall=1 \
                  --net2 virtio=00:af:aa:e2:40:06,bridge=vmbr1,firewall=1 \
                  --boot order=virtio0 \
                  --scsihw virtio-scsi-single \
                  --ostype l26 \
                  --agent 1

              # Descargar los archivos de disco duro
                curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Forti/FortiWeb763boot.qcow2    -o /tmp/FortiWeb763boot.qcow2
                curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Forti/FortiWeb763boot_2g.qcow2 -o /tmp/FortiWeb763boot_2g.qcow2
                curl -L http://hacks4geeks.com/_/descargas/MVs/Discos/Forti/FortiWeb763log.qcow2     -o /tmp/FortiWeb763log.qcow2
              # Importar los discos
                qm importdisk 4006 /tmp/FortiWeb763boot.qcow2    "$vAlmacenamiento" && rm -f /tmp/FortiWeb763boot.qcow2
                qm importdisk 4006 /tmp/FortiWeb763boot_2g.qcow2 "$vAlmacenamiento" && rm -f /tmp/FortiWeb763boot_2g.qcow2
                qm importdisk 4006 /tmp/FortiWeb763log.qcow2     "$vAlmacenamiento" && rm -f /tmp/FortiWeb763log.qcow2
              # Asignar los discos a la máquina virtual
                vRutaAlDisco=$(qm config 4006 | grep unused | cut -d' ' -f2 | head -n1)
                qm set 4006 --virtio0 "$vRutaAlDisco",format=raw,cache=writeback,aio=threads
                vRutaAlDisco=$(qm config 4006 | grep unused | cut -d' ' -f2 | head -n1)
                qm set 4006 --virtio1 "$vRutaAlDisco",format=raw,cache=writeback,aio=threads
                vRutaAlDisco=$(qm config 4006 | grep unused | cut -d' ' -f2 | head -n1)
                qm set 4006 --virtio2 "$vRutaAlDisco",format=raw,cache=writeback,aio=threads

            ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación de máquinas virtuales de Forti para Proxmox 7...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Proxmox 7 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación de máquinas virtuales de Forti para Proxmox 6...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Proxmox 6 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación de máquinas virtuales de Forti para Proxmox 5...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Proxmox 5 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación de máquinas virtuales de Forti para Proxmox 4...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Proxmox 4 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación de máquinas virtuales de Forti para Proxmox 3...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Proxmox 3 todavía no preparados. Prueba ejecutarlo en otra versión de Proxmox.${cFinColor}"
    echo ""

  fi
