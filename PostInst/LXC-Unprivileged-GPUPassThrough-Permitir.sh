#!/bin/bash

echo ""
echo "  Iniciando el script para permitir pasar tarjetas gráficas a un contendor LXC sin privilegios de Proxmox..."
echo ""

# Comprobar si el root ya forma parte de los grupos de video y render

  # Función para agregar un usuario a un grupo
    agregar_a_grupo() {
      local usuario="$1"
      local grupo="$2"
      if grep -q "^$grupo:" /etc/group; then
        usermod -aG "$grupo" "$usuario"
        echo "El usuario '$usuario' ha sido agregado al grupo '$grupo'."
      else
        echo "El grupo '$grupo' no existe. Creándolo..."
        groupadd "$grupo"
        usermod -aG "$grupo" "$usuario"
        echo "El grupo '$grupo' fue creado y el usuario '$usuario' agregado."
      fi
    }

  # Verificar si root pertenece a ambos grupos
    pertenece_video=$(id -nG root | grep -qw "video" && echo "si" || echo "no")
    pertenece_render=$(id -nG root | grep -qw "render" && echo "si" || echo "no")

  # Lógica para verificar y agregar a los grupos
    if [[ "$pertenece_video" == "si" && "$pertenece_render" == "si" ]]; then
      echo "El usuario 'root' ya pertenece a los grupos 'video' y 'render'."
    elif [[ "$pertenece_video" == "no" && "$pertenece_render" == "no" ]]; then
      echo "El usuario 'root' no pertenece a los grupos 'video' ni 'render'. Agregándolo a ambos..."
      agregar_a_grupo root video
      agregar_a_grupo root render
    elif [[ "$pertenece_video" == "si" ]]; then
      echo "El usuario 'root' pertenece al grupo 'video' pero no a 'render'. Agregándolo a 'render'..."
      agregar_a_grupo root render
    elif [[ "$pertenece_render" == "si" ]]; then
      echo "El usuario 'root' pertenece al grupo 'render' pero no a 'video'. Agregándolo a 'video'..."
      agregar_a_grupo root video
    fi

echo "Comprobación y ajustes completados."


# Comprobar si el root ya ha mapeado los grupos render y video al subgrupo 1

  # Encontrar el IDGroup de render (Normalmente 105)
    vIDGrupoRender=$(cat /etc/group | grep ^render | cut -d':' -f3)

  # Encontrar el IDGroup de video (Normalmente 44)
    vIDGrupoVideo=$(cat /etc/group | grep ^video | cut -d':' -f3)

  # Grupo video
    if ! grep -q "^root:$vIDGrupoVideo:1$" /etc/subgid; then
      echo ""
      echo "  La línea:"
      echo "    root:$vIDGrupoVideo:1"
      echo "  no existe en /etc/subgid. Procediendo a agregarla..."
      echo ""
      echo "root:$vIDGrupoVideo:1" >> /etc/subgid
    fi

  # Grupo render
    if ! grep -q "^root:$vIDGrupoRender:1$" /etc/subgid; then
      echo ""
      echo "  La línea:"
      echo "    root:$vIDGrupoRender:1"
      echo "  no existe en /etc/subgid. Procediendo a agregarla..."
      echo ""
      echo "root:$vIDGrupoRender:1" >> /etc/subgid
    fi

