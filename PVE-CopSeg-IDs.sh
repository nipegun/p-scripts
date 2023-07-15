#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer copia de seguridad de todos los contenedores y las máquinas virtuales de Proxmox
#
# Ejecución remota:
#    curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-CopSeg-IDs.sh | bash
#    curl -sL https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-CopSeg-IDs.sh | sed "s|vCarpetaCopSeg='/CopSegInt/'|vCarpetaCopSeg='/OtraCarpeta/'" | sed "s|vIdIni=100|vIdIni=202|g" | sed "s|vIdFin=999999999|vIdIni=207|g" | bash
# ----------

# Modificar sólo esto antes de ejecutar el script
vCarpetaCopSeg='/CopSegInt/' # La ubicación de la carpeta para las copias debe acabar con /
vIdIni=100
vIdFin=999999999

cFechaEjecScript=$(date +A%YM%mD%d@%T)

ccColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Iniciando copia de seguridad de todos los contenedores y máquinas virtuales...${cFinColor}"
echo ""

# Abortar script si no existe la carpeta de copias de seguridad
  if [ -d "$vCarpetaCopSeg" ]; then
    echo ""
  else
    echo ""
    echo -e "${cColorRojo}    No se ha encontrado la carpeta de copias de seguridad indicada en el script.${cFinColor}"
    echo -e "${cColorRojo}    Copia de seguridad abortada.${cFinColor}"
    echo ""
    exit 1
  fi

# Recorrer todas las ids
  for vId in $(seq $vIdIni $vIdFin);
    do
      # Determinar si es máquina virtual o contenedor
        if [ -f /etc/pve/lxc/$vId.conf ]; then # Si es contenedor
          echo "    Ejecutando copia de seguridad del contenedor $vId..."
          echo ""
          # Determinar el estado actual del contenedor
            vEstadoLXC=$(pct status $vId | sed 's- --g' | cut -d':' -f2)
            if [ $vEstadoLXC == "running" ]; then
              echo ""
              echo "      El contenedor está actualmente encendido."
              echo "      Se procederá a apagarlo para realizar la copia y se volverá a encender al finalizar el proceso."
              echo ""
              pct shutdown $vId
              mkdir -p "$vCarpetaCopSeg$vId" 2> /dev/null
              vzdump $vId --mode stop --compress gzip --dumpdir "$vCarpetaCopSeg$vId"/
              # Cambiar de nombre la carpeta de la copia
                vNombreDelContenedor=$(find "$vCarpetaCopSeg$vId" -maxdepth 1 -type f -name *.log -exec grep "CT Name" {} \; | cut -d' ' -f6)
                if [ -d "$vCarpetaCopSeg$vId"-lxc-"$vNombreDelContenedor" ]; then                                                   # Si ya existe una carpeta con el nombre completo
                  mv "$vCarpetaCopSeg$vId"/* "$vCarpetaCopSeg$vId"-lxc-"$vNombreDelContenedor"/                                     # mover todos los archivos a ella
                  rm -rf "$vCarpetaCopSeg$vId"                                                                                      # y borrar la carpeta que sólo tiene el id del contenedor.
                else                                                                                                                # Si no existe una carpeta con el mismo nombre
                  find $vCarpetaCopSeg -depth -type d -name "$vId" -exec mv {} "$vCarpetaCopSeg$vId"-lxc-"$vNombreDelContenedor" \; # mover la carpeta de sólo número a una carpeta con nombre completo.
                fi
              echo ""
              echo -e "${cColorVerde}      Copia de seguridad realizada. Encendiendo nuevamente el contenedor...${cFinColor}"
              echo ""
              pct start $vId
            elif [ $vEstadoLXC == "stopped" ]; then
              mkdir -p "$vCarpetaCopSeg$vId" 2> /dev/null
              vzdump $vId --mode stop --compress gzip --dumpdir "$vCarpetaCopSeg$vId"/
              # Cambiar de nombre la carpeta de la copia
                vNombreDelContenedor=$(find "$vCarpetaCopSeg$vId" -maxdepth 1 -type f -name *.log -exec grep "CT Name" {} \; | cut -d' ' -f6)
                if [ -d "$vCarpetaCopSeg$vId"-lxc-"$vNombreDelContenedor" ]; then                                                   # Si ya existe una carpeta con el nombre completo
                  mv "$vCarpetaCopSeg$vId"/* "$vCarpetaCopSeg$vId"-lxc-"$vNombreDelContenedor"/                                     # mover todos los archivos a ella
                  rm -rf "$vCarpetaCopSeg$vId"                                                                                      # y borrar la carpeta que sólo tiene el id del contenedor.
                else                                                                                                                # Si no existe una carpeta con el mismo nombre
                  find $vCarpetaCopSeg -depth -type d -name "$vId" -exec mv {} "$vCarpetaCopSeg$vId"-lxc-"$vNombreDelContenedor" \; # mover la carpeta de sólo número a una carpeta con nombre completo.
                fi
              echo ""
              echo -e "${cColorVerde}      Copia de seguridad realizada.${cFinColor}"
              echo ""
            else # No se puede determinar si está apagado o encendido
              echo ""
              echo -e "${cColorRojo}      No se ha podido determinar si el contenedor $vId está apagado o encendido.${cFinColor}"
              echo -e "${cColorRojo}      Se aborta su copia de seguridad.${cFinColor}"
              echo ""
            fi
        elif [ -f /etc/pve/qemu-server/$vId.conf ]; then # Si es máquina virtual
          echo "    Ejecutando copia de seguridad de la máquina virtual $vId..."
          echo ""
          # Determinar el estado actual de la máquina virtual
            vEstadoMV=$(qm status $vId | sed 's- --g' | cut -d':' -f2)
            if [ $vEstadoMV == "running" ]; then
              echo ""
              echo "    La máquina virtual está actualmente encendida."
              echo "    Se procederá a apagarla para realizar la copia y se volverá a encender al finalizar el proceso."
              echo ""
              qm shutdown $vId
              mkdir -p "$vCarpetaCopSeg$vId" 2> /dev/null
              vzdump $vId --mode stop --compress gzip --dumpdir "$vCarpetaCopSeg$vId"/
              # Cambiar de nombre la carpeta de la copia
                vNombreDeLaMV=$(find "$vCarpetaCopSeg$vId" -maxdepth 1 -type f -name *.log -exec grep "VM Name" {} \; | cut -d' ' -f6)
                if [ -d "$vCarpetaCopSeg$vId"-mv-"$vNombreDeLaMV" ]; then                                                   # Si ya existe una carpeta con el nombre completo
                  mv "$vCarpetaCopSeg$vId"/* "$vCarpetaCopSeg$vId"-mv-"$vNombreDeLaMV"/                                     # mover todos los archivos a ella
                  rm -rf "$vCarpetaCopSeg$vId"                                                                              # y borrar la carpeta que sólo tiene el id de la MV.
                else                                                                                                        # Si no existe una carpeta con el mismo nombre
                  find $vCarpetaCopSeg -depth -type d -name "$vId" -exec mv {} "$vCarpetaCopSeg$vId"-mv-"$vNombreDeLaMV" \; # mover la carpeta de sólo número a una carpeta con nombre completo.
                fi
              echo ""
              echo -e "${cColorVerde}      Copia de seguridad realizada. Encendiendo nuevamente la máquina virtual...${cFinColor}"
              echo ""
              qm start $vId
            elif [ $vEstadoMV == "stopped" ]; then
              mkdir -p "$vCarpetaCopSeg$vId" 2> /dev/null
              vzdump $vId --mode stop --compress gzip --dumpdir "$vCarpetaCopSeg$vId"/
              # Cambiar de nombre la carpeta de la copia
                vNombreDeLaMV=$(find "$vCarpetaCopSeg$vId" -maxdepth 1 -type f -name *.log -exec grep "VM Name" {} \; | cut -d' ' -f6)
                if [ -d "$vCarpetaCopSeg$vId"-mv-"$vNombreDeLaMV" ]; then                                                   # Si ya existe una carpeta con el nombre completo
                  mv "$vCarpetaCopSeg$vId"/* "$vCarpetaCopSeg$vId"-mv-"$vNombreDeLaMV"/                                     # mover todos los archivos a ella
                  rm -rf "$vCarpetaCopSeg$vId"                                                                              # y borrar la carpeta que sólo tiene el id de la MV.
                else                                                                                                        # Si no existe una carpeta con el mismo nombre
                  find $vCarpetaCopSeg -depth -type d -name "$vId" -exec mv {} "$vCarpetaCopSeg$vId"-mv-"$vNombreDeLaMV" \; # mover la carpeta de sólo número a una carpeta con nombre completo.
                fi
              echo ""
              echo -e "${cColorVerde}      Copia de seguridad realizada.${cFinColor}"
              echo ""
            else # No se puede determinar si está apagado o encendido
              echo ""
              echo -e "${cColorRojo}      No se ha podido determinar si la máquina virtual $vId está apagada o encendida.${cFinColor}"
              echo -e "${cColorRojo}      Se aborta su copia de seguridad.${cFinColor}"
              echo ""
            fi
        #else
        #  echo ""
        #  echo "  No hay ningún contenedor LXC o máquina virtual con la id $vId."
        #  echo ""
        fi
  done

# Borrar las carpetas vacías
#find $CarpetaCopSeg -type d -empty -delete

# Apuntar fecha en el log
  touch /var/log/CopiasDeSeguridad.log 2> /dev/null
  echo "$cFechaEjecScript - Terminada la copia de seguridad de todas las IDs de Promxox." >> /var/log/CopiasDeSeguridad.log

# Notificar fin del script
  echo ""
  echo -e "${cColorVerde}    Ejecución del script, finalizada.${cFinColor}"
  echo ""

