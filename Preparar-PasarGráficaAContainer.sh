#!/bin/bash

# Permitir al root mapear los grupos video y render
  # Encontrar el IDGroup de render (Normalmente 105)
    vIDGrupoRender=$(cat /etc/group | grep ^render | cut -d':' -f3)
  # Encontrar el IDGroup de video (Normalmente 44)
    vIDGrupoVideo=$(cat /etc/group | grep ^video | cut -d':' -f3)
  # Permitir al root mapear ambos grupos a nuevos groupsids
    echo "root:$vIDGrupoVideo:1"  >> /etc/subgid
    echo "root:$vIDGrupoRender:1" >> /etc/subgid


# listar los dispositivos relacionados con el Direct Rendering Infrastructure (DRI)
  ls -l /dev/dri
