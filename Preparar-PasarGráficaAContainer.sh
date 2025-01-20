#!/bin/bash

# Determinar la cantidad de gráficas que hay en el sistema
  declare -a aTarjetas
  aGPUs=$(ls -l /dev/dri | grep card | cut -d' ' -f13)

  # Imprimir el contenido del array
    for vTarjeta in "${aGPUs[@]}"; do
      echo "$vTarjeta"
    done

# Determinar la ruta PCI de cada una de las tarjetas
  aRutaPCITarjetas=($(ls -l /dev/dri/by-path/ | grep card | cut -d' ' -f10 | cut -d'-' -f2))

  # Imprimir el contenido del array
    for vRuta in "${aRutaPCITarjetas[@]}"; do
      echo "$vRuta"
    done

# Determinar el dispositivo de render que le corresponde a cada una de las tarjetas
  aDispoRenderTarjetas=($(ls -l /dev/dri/by-path/ | grep render | cut -d'/' -f2))

  # Imprimir el contenido del array
    for vDispoRender in "${aDispoRenderTarjetas[@]}"; do
      echo "$vDispoRender"
    done

# Crear el archivo .csv y escribir el encabezado
  vArchivoCSV='/tmp/GPUs.csv'
  echo "Tarjeta,DispoRender,RutaPCI" > $vArchivoCSV

# Combinar la información de los arrays en el archivo CSV
  for i in "${!aGPUs[@]}"; do
    vTarjeta="${aGPUs[$i]}"
    vRutaPCI="${aRutaPCITarjetas[$i]}"
    vDispoRender="${aDispoRenderTarjetas[$i]}"
  
    # Escribir la fila en el archivo CSV
    echo "${vTarjeta},${vDispoRender},${vRutaPCI}" >> "$vArchivoCSV"
  done


# Permitir al root mapear los grupos video y render

  # Encontrar el IDGroup de render (Normalmente 105)
    vIDGrupoRender=$(cat /etc/group | grep ^render | cut -d':' -f3)

  # Encontrar el IDGroup de video (Normalmente 44)
    vIDGrupoVideo=$(cat /etc/group | grep ^video | cut -d':' -f3)

  # Permitir al root mapear ambos grupos a nuevos groupsids
    echo "root:$vIDGrupoVideo:1"  >> /etc/subgid
    echo "root:$vIDGrupoRender:1" >> /etc/subgid

# Determinar cual es la GPU integrada y cual la pinchada
  declare -a aGPUs
  aGPUs=$(ls -l /dev/dri)

# listar los dispositivos relacionados con el Direct Rendering Infrastructure (DRI)
  ls -l /dev/dri

unprivileged: 1
lxc.cgroup2.devices.allow: c 226:0 rwm
lxc.cgroup2.devices.allow: c 226:128 rwm
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
lxc.idmap: u 0 100000 65536
lxc.idmap: g 0 100000 $vIDGrupoVideo
lxc.idmap: g $vIDGrupoVideo $vIDGrupoVideo 1
lxc.idmap: g 45 100045 62
lxc.idmap: g 107 $vIDGrupoRender 1
lxc.idmap: g 108 100108 65428

# Permitir al usuario root del contenedor acceder a los dispositivos render y video del host
  usermod -aG render,video root

