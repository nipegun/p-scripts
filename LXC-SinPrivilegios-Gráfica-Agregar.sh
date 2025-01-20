#!/bin/bash

vNumGrupoRenderDelContenedor="104"
vNumGrupoNamespaceDelContenedor=""

echo ""
echo "  Iniciando el script para pasar una tarjeta gráfica a un contenedor LXC de Proxmox..."
echo ""

# Encontrar el IDGroup de render (Normalmente 105)
  vNumGrupoRenderDelHost=$(cat /etc/group | grep ^render | cut -d':' -f3)

# Encontrar el IDGroup de video (Normalmente 44)
  vIDGrupoVideo=$(cat /etc/group | grep ^video | cut -d':' -f3)

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
    echo "Tarjeta,DispoRender,RutaPCI" > "$vArchivoCSV"

  # Combinar la información de los arrays en el archivo CSV
    for i in "${!aGPUs[@]}"; do
      tarjeta="${aGPUs[$i]}"
      rutaPCI="${aRutaPCITarjetas[$i]}"
      dispoRender="${aDispoRenderTarjetas[$i]}"
  
      # Escribir la fila en el archivo CSV
      echo "${tarjeta},${dispoRender},${rutaPCI}" >> "$vArchivoCSV"
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
    read -p "  Que tarjeta quieres pasar al contendor: " vNumTarjeta

    # Ejecutar comandos específicos dependiendo del número seleccionado
      case "$vNumTarjeta" in

        1)
          # Determinar el dispositivo de render correspondiente a la 1ra tarjeta:
            vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '2p' | cut -d',' -f2)
          # Determinar el numero del dispositivo de render correspondiente a la 1ra tarjeta:
            vNumeroDispRender=$(cat /tmp/GPUs.csv | sed -n '2p' | cut -d',' -f2 | cut -d'D' -f2)
          echo ""
          echo "    El texto que debes agregar al archivo .conf del contenedor LXC, después de la línea:"
          echo "      unprivileged: 1"
          echo "    ...es el siguiente:"
          echo ""
          echo "lxc.cgroup2.devices.allow: c 226:0 rwm"
          echo "lxc.cgroup2.devices.allow: c 226:$vNumeroDispRender rwm"
          echo "lxc.mount.entry: /dev/dri/$vNombreDispRender dev/dri/$vNombreDispRender none bind,optional,create=file"
          echo "lxc.idmap: u 0 100000 65536"
          echo "lxc.idmap: g 0 100000 $vIDGrupoVideo"
          echo "lxc.idmap: g $vIDGrupoVideo $vIDGrupoVideo 1"
          echo "lxc.idmap: g 45 100045 62"
          echo "lxc.idmap: g $vNumGrupoRenderDelContenedor $vNumGrupoRenderDelHost 1"
          echo "lxc.idmap: g 108 100108 65428"
          echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
          echo ""
          echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
          echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
          echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
          echo ""
        ;;

        2)
          # Determinar el dispositivo de render correspondiente a la 2da tarjeta:
            vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '3p' | cut -d',' -f2)
          # Determinar el numero del dispositivo de render correspondiente a la 2da tarjeta:
            vNumeroDispRender=$(cat /tmp/GPUs.csv | sed -n '3p' | cut -d',' -f2 | cut -d'D' -f2)
          echo ""
          echo "    El texto que debes agregar al archivo .conf del contenedor LXC, después de la línea:"
          echo "      unprivileged: 1"
          echo "    ...es el siguiente:"
          echo ""
          echo "lxc.cgroup2.devices.allow: c 226:0 rwm"
          echo "lxc.cgroup2.devices.allow: c 226:$vNumeroDispRender rwm"
          echo "lxc.mount.entry: /dev/dri/$vNombreDispRender dev/dri/$vNombreDispRender none bind,optional,create=file"
          echo "lxc.idmap: u 0 100000 65536"
          echo "lxc.idmap: g 0 100000 $vIDGrupoVideo"
          echo "lxc.idmap: g $vIDGrupoVideo $vIDGrupoVideo 1"
          echo "lxc.idmap: g 45 100045 62"
          echo "lxc.idmap: g $vNumGrupoRenderDelContenedor $vNumGrupoRenderDelHost 1"
          echo "lxc.idmap: g 108 100108 65428"
          echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
          echo ""
          echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
          echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
          echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
          echo ""
        ;;

        3)
          # Determinar el dispositivo de render correspondiente a la 3ra tarjeta:
            vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '4p' | cut -d',' -f2)
          # Determinar el numero del dispositivo de render correspondiente a la 3ra tarjeta:
            vNumeroDispRender=$(cat /tmp/GPUs.csv | sed -n '4p' | cut -d',' -f2 | cut -d'D' -f2)
          echo ""
          echo "    El texto que debes agregar al archivo .conf del contenedor LXC, después de la línea:"
          echo "      unprivileged: 1"
          echo "    ...es el siguiente:"
          echo ""
          echo "lxc.cgroup2.devices.allow: c 226:0 rwm"
          echo "lxc.cgroup2.devices.allow: c 226:$vNumeroDispRender rwm"
          echo "lxc.mount.entry: /dev/dri/$vNombreDispRender dev/dri/$vNombreDispRender none bind,optional,create=file"
          echo "lxc.idmap: u 0 100000 65536"
          echo "lxc.idmap: g 0 100000 $vIDGrupoVideo"
          echo "lxc.idmap: g $vIDGrupoVideo $vIDGrupoVideo 1"
          echo "lxc.idmap: g 45 100045 62"
          echo "lxc.idmap: g $vNumGrupoRenderDelContenedor $vNumGrupoRenderDelHost 1"
          echo "lxc.idmap: g 108 100108 65428"
          echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
          echo ""
          echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
          echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
          echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
          echo ""
        ;;

        4)
          # Determinar el dispositivo de render correspondiente a la 4ta tarjeta:
            vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '5p' | cut -d',' -f2)
          # Determinar el numero del dispositivo de render correspondiente a la 4ta tarjeta:
            vNumeroDispRender=$(cat /tmp/GPUs.csv | sed -n '5p' | cut -d',' -f2 | cut -d'D' -f2)
          echo ""
          echo "    El texto que debes agregar al archivo .conf del contenedor LXC, después de la línea:"
          echo "      unprivileged: 1"
          echo "    ...es el siguiente:"
          echo ""
          echo "lxc.cgroup2.devices.allow: c 226:0 rwm"
          echo "lxc.cgroup2.devices.allow: c 226:$vNumeroDispRender rwm"
          echo "lxc.mount.entry: /dev/dri/$vNombreDispRender dev/dri/$vNombreDispRender none bind,optional,create=file"
          echo "lxc.idmap: u 0 100000 65536"
          echo "lxc.idmap: g 0 100000 $vIDGrupoVideo"
          echo "lxc.idmap: g $vIDGrupoVideo $vIDGrupoVideo 1"
          echo "lxc.idmap: g 45 100045 62"
          echo "lxc.idmap: g $vNumGrupoRenderDelContenedor $vNumGrupoRenderDelHost 1"
          echo "lxc.idmap: g 108 100108 65428"
          echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
          echo ""
          echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
          echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
          echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
          echo ""
        ;;

        5)
          # Determinar el dispositivo de render correspondiente a la 5ta tarjeta:
            vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '6p' | cut -d',' -f2)
          # Determinar el numero del dispositivo de render correspondiente a la 5ta tarjeta:
            vNumeroDispRender=$(cat /tmp/GPUs.csv | sed -n '6p' | cut -d',' -f2 | cut -d'D' -f2)
          echo ""
          echo "    El texto que debes agregar al archivo .conf del contenedor LXC, después de la línea:"
          echo "      unprivileged: 1"
          echo "    ...es el siguiente:"
          echo ""
          echo "lxc.cgroup2.devices.allow: c 226:0 rwm"
          echo "lxc.cgroup2.devices.allow: c 226:$vNumeroDispRender rwm"
          echo "lxc.mount.entry: /dev/dri/$vNombreDispRender dev/dri/$vNombreDispRender none bind,optional,create=file"
          echo "lxc.idmap: u 0 100000 65536"
          echo "lxc.idmap: g 0 100000 $vIDGrupoVideo"
          echo "lxc.idmap: g $vIDGrupoVideo $vIDGrupoVideo 1"
          echo "lxc.idmap: g 45 100045 62"
          echo "lxc.idmap: g $vNumGrupoRenderDelContenedor $vNumGrupoRenderDelHost 1"
          echo "lxc.idmap: g 108 100108 65428"
          echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
          echo ""
          echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
          echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
          echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
          echo ""
        ;;

        6)
          # Determinar el dispositivo de render correspondiente a la 6ta tarjeta:
            vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '7p' | cut -d',' -f2)
          # Determinar el numero del dispositivo de render correspondiente a la 6ta tarjeta:
            vNumeroDispRender=$(cat /tmp/GPUs.csv | sed -n '7p' | cut -d',' -f2 | cut -d'D' -f2)
          echo ""
          echo "    El texto que debes agregar al archivo .conf del contenedor LXC, después de la línea:"
          echo "      unprivileged: 1"
          echo "    ...es el siguiente:"
          echo ""
          echo "lxc.cgroup2.devices.allow: c 226:0 rwm"
          echo "lxc.cgroup2.devices.allow: c 226:$vNumeroDispRender rwm"
          echo "lxc.mount.entry: /dev/dri/$vNombreDispRender dev/dri/$vNombreDispRender none bind,optional,create=file"
          echo "lxc.idmap: u 0 100000 65536"
          echo "lxc.idmap: g 0 100000 $vIDGrupoVideo"
          echo "lxc.idmap: g $vIDGrupoVideo $vIDGrupoVideo 1"
          echo "lxc.idmap: g 45 100045 62"
          echo "lxc.idmap: g $vNumGrupoRenderDelContenedor $vNumGrupoRenderDelHost 1"
          echo "lxc.idmap: g 108 100108 65428"
          echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
          echo ""
          echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
          echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
          echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
          echo ""
        ;;

        7)
          # Determinar el dispositivo de render correspondiente a la 7ma tarjeta:
            vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '8p' | cut -d',' -f2)
          # Determinar el numero del dispositivo de render correspondiente a la 7ma tarjeta:
            vNumeroDispRender=$(cat /tmp/GPUs.csv | sed -n '8p' | cut -d',' -f2 | cut -d'D' -f2)
          echo ""
          echo "    El texto que debes agregar al archivo .conf del contenedor LXC, después de la línea:"
          echo "      unprivileged: 1"
          echo "    ...es el siguiente:"
          echo ""
          echo "lxc.cgroup2.devices.allow: c 226:0 rwm"
          echo "lxc.cgroup2.devices.allow: c 226:$vNumeroDispRender rwm"
          echo "lxc.mount.entry: /dev/dri/$vNombreDispRender dev/dri/$vNombreDispRender none bind,optional,create=file"
          echo "lxc.idmap: u 0 100000 65536"
          echo "lxc.idmap: g 0 100000 $vIDGrupoVideo"
          echo "lxc.idmap: g $vIDGrupoVideo $vIDGrupoVideo 1"
          echo "lxc.idmap: g 45 100045 62"
          echo "lxc.idmap: g $vNumGrupoRenderDelContenedor $vNumGrupoRenderDelHost 1"
          echo "lxc.idmap: g 108 100108 65428"
          echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
          echo ""
          echo "  Recuerda instalar los controladores gráficos dentro del contenedor, dependiendo de la gráfica que se pase."
          echo "    Por ejemplo, si se pasa una gráfica Intel integrada:"
          echo "      apt-get -y update && apt-get -y install intel-media-va-driver"
          echo ""
        ;;

        8)
          # Determinar el dispositivo de render correspondiente a la 8va tarjeta:
            vNombreDispRender=$(cat /tmp/GPUs.csv | sed -n '9p' | cut -d',' -f2)
          # Determinar el numero del dispositivo de render correspondiente a la 8va tarjeta:
            vNumeroDispRender=$(cat /tmp/GPUs.csv | sed -n '9p' | cut -d',' -f2 | cut -d'D' -f2)
          echo ""
          echo "    El texto que debes agregar al archivo .conf del contenedor LXC, después de la línea:"
          echo "      unprivileged: 1"
          echo "    ...es el siguiente:"
          echo ""
          echo "lxc.cgroup2.devices.allow: c 226:0 rwm"
          echo "lxc.cgroup2.devices.allow: c 226:$vNumeroDispRender rwm"
          echo "lxc.mount.entry: /dev/dri/$vNombreDispRender dev/dri/$vNombreDispRender none bind,optional,create=file"
          echo "lxc.idmap: u 0 100000 65536"
          echo "lxc.idmap: g 0 100000 $vIDGrupoVideo"
          echo "lxc.idmap: g $vIDGrupoVideo $vIDGrupoVideo 1"
          echo "lxc.idmap: g 45 100045 62"
          echo "lxc.idmap: g $vNumGrupoRenderDelContenedor $vNumGrupoRenderDelHost 1"
          echo "lxc.idmap: g 108 100108 65428"
          echo "lxc.idmap: g 65534 165534 1" # esto es por si apt no funciona
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

dev0: /dev/dri/card0,gid=44,uid=0
dev1: /dev/dri/renderD128,gid=105,uid=0
