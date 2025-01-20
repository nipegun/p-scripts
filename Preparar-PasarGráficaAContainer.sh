#!/bin/bash

# listar los dispositivos relacionados con el Direct Rendering Infrastructure (DRI)
  ls -l /dev/dri

# Encontrar el IDGroup de render (Normalmente 105)
  vIDGrupoRender=$(cat /etc/group | grep ^render | cut -d':' -f3)

# Encontrar el IDGroup de video (Normalmente 44)
  vIDGrupoVideo=$(cat /etc/group | grep ^video | cut -d':' -f3)

# Agregar los números de los grupos al a subgid
  echo "root:$vIDGrupoVideo:1" >> /etc/subgid
  echo "root:$vIDGrupoRender:1" >> /etc/subgid
  
