#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para permitir pasar tarjetas gráficas a contenedores LXC sin privilegios de proxmox
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL x | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL x | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
# ----------

echo ""
echo "  Iniciando el script para permitir pasar tarjetas gráficas a un contendor LXC sin privilegios de Proxmox..."
echo ""

# Comprobar si el root ya forma parte de los grupos de video y render

  # Verificar si root pertenece a ambos grupos
    vPerteneceAVideo=$(id -nG root | grep -qw "video" && echo "si" || echo "no")
    vPerteneceARender=$(id -nG root | grep -qw "render" && echo "si" || echo "no")

  # Lógica para verificar y agregar a los grupos
    if [[ "$vPerteneceAVideo" == "si" && "$vPerteneceARender" == "si" ]]; then
      echo ""
      echo "  El usuario 'root' ya pertenece a los grupos 'video' y 'render'."
      echo ""
    elif [[ "$vPerteneceAVideo" == "no" && "$vPerteneceARender" == "no" ]]; then
      echo ""
      echo "  El usuario 'root' no pertenece a los grupos 'video' ni 'render'. Agregándolo a ambos..."
      echo ""
      usermod -aG video,render root
    elif [[ "$vPerteneceAVideo" == "si" ]]; then
      echo ""
      echo "  El usuario 'root' pertenece al grupo 'video' pero no a 'render'. Agregándolo a 'render'..."
      echo ""
      usermod -aG render root
    elif [[ "$vPerteneceARender" == "si" ]]; then
      echo ""
      echo "  El usuario 'root' pertenece al grupo 'render' pero no a 'video'. Agregándolo a 'video'..."
      echo ""
      usermod -aG video root
    fi

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

