#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para pasar una tarjeta gráfica a un contendor del proxmox
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/LXC-GPUPassThrough-ActivarEnContainer.sh | bash -s [IDDelContenedorLXC]
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/LXC-GPUPassThrough-ActivarEnContainer.sh | sed 's-sudo--g' | bash -s [IDDelContenedorLXC]
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/LXC-GPUPassThrough-ActivarEnContainer.sh | nano -
# ----------

vNumGrupoVideoDeDentroDelLXC="44"
vNumGrupoRenderDeDentroDelLXC="104"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir la cantidad de argumentos esperados
  cCantParamEsperados=1

# Encontrar el IDGroup de video (Normalmente 44)
  vNumGrupoVideoDelHost=$(cat /etc/group | grep ^video | cut -d':' -f3)

# Encontrar el IDGroup de render (Normalmente 105)
  vNumGrupoRenderDelHost=$(cat /etc/group | grep ^render | cut -d':' -f3)

# Comprobar que se hayan pasado la cantidad de parámetros correctos y proceder
  if [ $# -ne $cCantParamEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo "    $0 [IDDelContainer]"
      echo ""
      echo "  Ejemplo:"
      echo "    $0 '103'"
      echo ""
      exit
    else
      echo ""
      echo ""
      echo ""

      # Comprobar que el contenedor exista. Si no existe, abortar el script
        if [ ! -f /etc/pve/lxc/$1.conf ]; then
          echo ""
          echo -e "${cColorRojo}    El contenedor $1 no existe. Abortando... ${cFinColor}"
          echo ""
          exit 1
        fi

      # Crear el archivo .csv donde guardar la información de las tarjetas gráficas disponibles

        # Determinar la cantidad de gráficas que hay en el sistema
          aGPUs=($(ls -l /dev/dri | grep card | cut -d' ' -f13))
          # Imprimir el contenido del array
            #for vTarjeta in "${aGPUs[@]}"; do
            #  echo "$vTarjeta"
            #done

        # Determinar la ruta PCI de cada una de las tarjetas
          aRutaPCITarjetas=($(ls -l /dev/dri/by-path/ | grep card | cut -d' ' -f10 | cut -d'-' -f2))
          # Imprimir el contenido del array
            #for vRuta in "${aRutaPCITarjetas[@]}"; do
            #  echo "$vRuta"
            #done

        # Determinar el dispositivo de render que le corresponde a cada una de las tarjetas
          aDispoRenderTarjetas=($(ls -l /dev/dri/by-path/ | grep render | cut -d'/' -f2))
          # Imprimir el contenido del array
            #for vDispoRender in "${aDispoRenderTarjetas[@]}"; do
            #  echo "$vDispoRender"
           #done

        # Crear el archivo .csv y escribir el encabezado
          vArchivoCSV='/tmp/GPUs.csv'
          echo "Tarjeta,DispoRender,RutaPCI,Vendor,Device" > "$vArchivoCSV"

        # Combinar la información de los arrays en el archivo CSV
          for i in "${!aGPUs[@]}"; do
            tarjeta="${aGPUs[$i]}"
            rutaPCI="${aRutaPCITarjetas[$i]}"
            dispoRender="${aDispoRenderTarjetas[$i]}"
            vVendor=$(cat /sys/bus/pci/devices/$rutaPCI/vendor)
            vDevice=$(cat /sys/bus/pci/devices/$rutaPCI/device)
            # Escribir la fila en el archivo CSV
            echo "${tarjeta},${dispoRender},${rutaPCI},${vVendor},${vDevice}" >> "$vArchivoCSV"
          done

      # Salir si no se encuentra ninguna tarjeta gráfica
        vCantTarjetas=$(($(wc -l < "$vArchivoCSV") - 1))
        if [[ "$vCantTarjetas" -le 0 ]]; then
          echo ""
          echo "  No hay ninguna tarjeta gráfica disponible para pasar al contenedor."
          echo ""
          exit 1
        fi

      # Crear el menú

        # Mostrar el contenido del archivo (excluyendo la cabecera) en un menú
          echo ""
          echo "    Tarjetas encontradas:"
          echo ""
          tail -n +2 "$vArchivoCSV" | nl -v 1

        # Leer todas las líneas del archivo (excluyendo la cabecera) y guardarlas en un array
          tail -n +2 "$vArchivoCSV" | while IFS= read -r linea; do
            lineas+=("$linea")
          done

        # Pedir al usuario que seleccione una línea
          echo ""
          read -p "    Que tarjeta quieres pasar al contendor (Ingresa el número y presiona Enter): " vNumTarjeta < /dev/tty

          # Ejecutar comandos específicos dependiendo del número seleccionado
            case "$vNumTarjeta" in

              1)
                # Determinar que card corresponde a la 1ra tarjeta:
                  vNombreCard=$(cat /tmp/GPUs.csv | sed -n '2p' | cut -d',' -f1)
                # Determinar el dispositivo de render correspondiente a la 1ra tarjeta:
                  vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '2p' | cut -d',' -f2)
                # Agregar los dispositivos al archivo de configuración del container
                  echo "dev0: /dev/dri/$vNombreCard,gid=$vNumGrupoVideoDeDentroDelLXC,uid=0"        >> /etc/pve/lxc/$1.conf
                  echo "dev1: /dev/dri/$vNombreDispRender,gid=$vNumGrupoRenderDeDentroDelLXC,uid=0" >> /etc/pve/lxc/$1.conf

             
                  #echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
                  echo ""
                  echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
                  echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
                  echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
                  echo ""
                ;;

                2)
                # Determinar que card corresponde a la 2da tarjeta:
                  vNombreCard=$(cat /tmp/GPUs.csv | sed -n '3p' | cut -d',' -f1)
                # Determinar el dispositivo de render correspondiente a la 2da tarjeta:
                  vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '3p' | cut -d',' -f2)
                # Agregar los dispositivos al archivo de configuración del container
                  echo "dev0: /dev/dri/$vNombreCard,gid=$vNumGrupoVideoDeDentroDelLXC,uid=0"        >> /etc/pve/lxc/$1.conf
                  echo "dev1: /dev/dri/$vNombreDispRender,gid=$vNumGrupoRenderDeDentroDelLXC,uid=0" >> /etc/pve/lxc/$1.conf
             
                  #echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
                  echo ""
                  echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
                  echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
                  echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
                  echo ""
                ;;

                3)
                # Determinar que card corresponde a la 3ra tarjeta:
                  vNombreCard=$(cat /tmp/GPUs.csv | sed -n '4p' | cut -d',' -f1)
                # Determinar el dispositivo de render correspondiente a la 3ra tarjeta:
                  vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '4p' | cut -d',' -f2)
                # Agregar los dispositivos al archivo de configuración del container
                  echo "dev0: /dev/dri/$vNombreCard,gid=$vNumGrupoVideoDeDentroDelLXC,uid=0"        >> /etc/pve/lxc/$1.conf
                  echo "dev1: /dev/dri/$vNombreDispRender,gid=$vNumGrupoRenderDeDentroDelLXC,uid=0" >> /etc/pve/lxc/$1.conf
             
                  #echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
                  echo ""
                  echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
                  echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
                  echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
                  echo ""
                ;;

                4)
                # Determinar que card corresponde a la 4ta tarjeta:
                  vNombreCard=$(cat /tmp/GPUs.csv | sed -n '5p' | cut -d',' -f1)
                # Determinar el dispositivo de render correspondiente a la 4ta tarjeta:
                  vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '5p' | cut -d',' -f2)
                # Agregar los dispositivos al archivo de configuración del container
                  echo "dev0: /dev/dri/$vNombreCard,gid=$vNumGrupoVideoDeDentroDelLXC,uid=0"        >> /etc/pve/lxc/$1.conf
                  echo "dev1: /dev/dri/$vNombreDispRender,gid=$vNumGrupoRenderDeDentroDelLXC,uid=0" >> /etc/pve/lxc/$1.conf
             
                  #echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
                  echo ""
                  echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
                  echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
                  echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
                  echo ""
                ;;

                5)
                # Determinar que card corresponde a la 5ta tarjeta:
                  vNombreCard=$(cat /tmp/GPUs.csv | sed -n '6p' | cut -d',' -f1)
                # Determinar el dispositivo de render correspondiente a la 5ta tarjeta:
                  vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '6p' | cut -d',' -f2)
                # Agregar los dispositivos al archivo de configuración del container
                  echo "dev0: /dev/dri/$vNombreCard,gid=$vNumGrupoVideoDeDentroDelLXC,uid=0"        >> /etc/pve/lxc/$1.conf
                  echo "dev1: /dev/dri/$vNombreDispRender,gid=$vNumGrupoRenderDeDentroDelLXC,uid=0" >> /etc/pve/lxc/$1.conf
             
                  #echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
                  echo ""
                  echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
                  echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
                  echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
                  echo ""
                ;;

                6)
                # Determinar que card corresponde a la 6ta tarjeta:
                  vNombreCard=$(cat /tmp/GPUs.csv | sed -n '7p' | cut -d',' -f1)
                # Determinar el dispositivo de render correspondiente a la 6ta tarjeta:
                  vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '7p' | cut -d',' -f2)
                # Agregar los dispositivos al archivo de configuración del container
                  echo "dev0: /dev/dri/$vNombreCard,gid=$vNumGrupoVideoDeDentroDelLXC,uid=0"        >> /etc/pve/lxc/$1.conf
                  echo "dev1: /dev/dri/$vNombreDispRender,gid=$vNumGrupoRenderDeDentroDelLXC,uid=0" >> /etc/pve/lxc/$1.conf
             
                  #echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
                  echo ""
                  echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
                  echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
                  echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
                  echo ""
                ;;

                7)
                # Determinar que card corresponde a la 7ma tarjeta:
                  vNombreCard=$(cat /tmp/GPUs.csv | sed -n '8p' | cut -d',' -f1)
                # Determinar el dispositivo de render correspondiente a la 7ma tarjeta:
                  vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '8p' | cut -d',' -f2)
                # Agregar los dispositivos al archivo de configuración del container
                  echo "dev0: /dev/dri/$vNombreCard,gid=$vNumGrupoVideoDeDentroDelLXC,uid=0"        >> /etc/pve/lxc/$1.conf
                  echo "dev1: /dev/dri/$vNombreDispRender,gid=$vNumGrupoRenderDeDentroDelLXC,uid=0" >> /etc/pve/lxc/$1.conf
             
                  #echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
                  echo ""
                  echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
                  echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
                  echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
                  echo ""
                ;;

                8)
                # Determinar que card corresponde a la 8va tarjeta:
                  vNombreCard=$(cat /tmp/GPUs.csv | sed -n '9p' | cut -d',' -f1)
                # Determinar el dispositivo de render correspondiente a la 8va tarjeta:
                  vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '9p' | cut -d',' -f2)
                # Agregar los dispositivos al archivo de configuración del container
                  echo "dev0: /dev/dri/$vNombreCard,gid=$vNumGrupoVideoDeDentroDelLXC,uid=0"        >> /etc/pve/lxc/$1.conf
                  echo "dev1: /dev/dri/$vNombreDispRender,gid=$vNumGrupoRenderDeDentroDelLXC,uid=0" >> /etc/pve/lxc/$1.conf
             
                  #echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
                  echo ""
                  echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
                  echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
                  echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
                  echo ""
                ;;

                *)
                  echo "Acción no especificada para este número."
                ;;

          esac

  fi

