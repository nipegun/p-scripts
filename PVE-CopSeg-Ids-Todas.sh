#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para hacer copia de seguridad de todos los contenedores y las máquinas virtuales de Proxmox
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/p-scripts/master/PVE-CopSeg-Ids-Todas.sh | bash
# ----------

# Modificar sólo esto antes de ejecutar el script
vCarpetaCopSeg="/Particiones/CopSeg/" # La ubicación de la carpeta para las copias debe acabar con /
vIdIni=205
vIdFin=223

vFechaDeEjec=$(date +A%YM%mD%d@%T)

ColorAzul="\033[0;34m"
ColorAzulClaro="\033[1;34m"
ColorVerde='\033[1;32m'
ColorRojo='\033[1;31m'
FinColor='\033[0m'

echo ""
echo -e "${ColorAzul}  Iniciando copia de seguridad de todos los contenedores y máquinas virtuales...${FinColor}"
echo ""

# Abortar script si no existe la carpeta de copias de seguridad
  if [ -d "$vCarpetaCopSeg" ]; then
    echo ""
  else
    echo ""
    echo -e "${ColorRojo}    No se ha encontrado la carpeta de copias de seguridad indicada en el script.${FinColor}"
    echo -e "${ColorRojo}    Copia de seguridad abortada.${FinColor}"
    echo ""
    exit 1
  fi

# Recorrer todas las ids
  for vId in $(seq $vIdIni $vIdFin);
    do
      # Determinar si es máquina virtual o contenedor
        if [ -f /etc/pve/lxc/$vId.conf ]; then # Si es contenedor
          echo -e "${ColorAzul}    Ejecutando copia de seguridad del contenedor $vId...${FinColor}"
          # Determinar el estado actual del contenedor
            vEstadoLXC=$(pct status $vId | sed 's- --g' | cut -d':' -f2)
            if [ $vEstadoLXC == "running" ]; then
              echo ""
              echo "      El contenedor está actualmente encendido."
              echo "      Se procederá a apagarlo para realizar la copia y se volverá a encender al finalizar el proceso."
              echo ""
              pct shutdown $vId
              mkdir -p $vCarpetaCopSeg$vId 2> /dev/null
              vzdump $vId --mode stop --compress gzip --dumpdir $vCarpetaCopSeg$vId/
              # Cambiar de nombre la carpeta de la copia
                vNombreDelContenedor=$(find $vCarpetaCopSeg$vId -maxdepth 1 -type f -name *.log -exec grep "VM Name" {} \; | cut -d' ' -f6)
                if [ -d $vCarpetaCopSeg$vId"-"$vNombreDelContenedor ]; then                                                          # Si ya existe una carpeta con el nombre completo
                  mv $vCarpetaCopSeg$vId/* $vCarpetaCopSeg$vId"-"$vNombreDelContenedor/                                              # mover todos los archivos a ella
                  rm -rf $vCarpetaCopSeg$vId                                                                                         # y borrar la carpeta que sólo tiene el id del contenedor.
                else                                                                                                                 # Si no existe una carpeta con el mismo nombre
                  find $vCarpetaCopSeg -depth -type d -name "$vId" -print -exec mv {} $vCarpetaCopSeg$vId"-"$vNombreDelContenedor \; # mover la carpeta de sólo número a una carpeta con nombre completo.
                fi
              echo ""
              echo -e "${ColorVerde}      Copia de seguridad realizada. Encendiendo nuevamente el contenedor...${FinColor}"
              echo ""
              pct start $vId
            elif [ $vEstadoLXC == "stopped" ]; then
              mkdir -p $vCarpetaCopSeg$vId 2> /dev/null
              vzdump $vId --mode stop --compress gzip --dumpdir $vCarpetaCopSeg$vId/
              # Cambiar de nombre la carpeta de la copia
                vNombreDelContenedor=$(find $vCarpetaCopSeg$vId -maxdepth 1 -type f -name *.log -exec grep "VM Name" {} \; | cut -d' ' -f6)
                if [ -d $vCarpetaCopSeg$vId"-"$vNombreDelContenedor ]; then                                                          # Si ya existe una carpeta con el nombre completo
                  mv $vCarpetaCopSeg$vId/* $vCarpetaCopSeg$vId"-"$vNombreDelContenedor/                                              # mover todos los archivos a ella
                  rm -rf $vCarpetaCopSeg$vId                                                                                         # y borrar la carpeta que sólo tiene el id del contenedor.
                else                                                                                                                 # Si no existe una carpeta con el mismo nombre
                  find $vCarpetaCopSeg -depth -type d -name "$vId" -print -exec mv {} $vCarpetaCopSeg$vId"-"$vNombreDelContenedor \; # mover la carpeta de sólo número a una carpeta con nombre completo.
                fi
              echo ""
              echo -e "${ColorVerde}      Copia de seguridad realizada.${FinColor}"
              echo ""
            else # No se puede determinar si está apagado o encendido
              echo ""
              echo -e "${ColorRojo}      No se ha podido determinar si el contenedor $vId está apagado o encendido.${FinColor}"
              echo -e "${ColorRojo}      Se aborta su copia de seguridad.${FinColor}"
              echo ""
            fi
        elif [ -f /etc/pve/qemu-server/$vId.conf ]; then # Si es máquina virtual
          echo -e "${ColorAzul}  Ejecutando copia de seguridad de la máquina virtual $vId...${FinColor}"
          # Determinar el estado actual de la máquina virtual
            vEstadoMV=$(qm status $vId | sed 's- --g' | cut -d':' -f2)
            if [ $vEstadoMV == "running" ]; then
              echo ""
              echo "    La máquina virtual está actualmente encendida."
              echo "    Se procederá a apagarla para realizar la copia y se volverá a encender al finalizar el proceso."
              echo ""
              qm shutdown $vId
              mkdir -p $vCarpetaCopSeg$vId 2> /dev/null
              vzdump $vId --mode stop --compress gzip --dumpdir $vCarpetaCopSeg$vId/
              # Cambiar de nombre la carpeta de la copia
                vNombreDeLaMV=$(find $vCarpetaCopSeg$vId -maxdepth 1 -type f -name *.log -exec grep "VM Name" {} \; | cut -d' ' -f6)
                if [ -d $vCarpetaCopSeg$vId"-"$vNombreDeLaMV ]; then                                                          # Si ya existe una carpeta con el nombre completo
                  mv $vCarpetaCopSeg$vId/* $vCarpetaCopSeg$vId"-"$vNombreDeLaMV/                                              # mover todos los archivos a ella
                  rm -rf $vCarpetaCopSeg$vId                                                                                  # y borrar la carpeta que sólo tiene el id de la MV.
                else                                                                                                          # Si no existe una carpeta con el mismo nombre
                  find $vCarpetaCopSeg -depth -type d -name "$vId" -print -exec mv {} $vCarpetaCopSeg$vId"-"$vNombreDeLaMV \; # mover la carpeta de sólo número a una carpeta con nombre completo.
                fi
              echo ""
              echo -e "${ColorVerde}      Copia de seguridad realizada. Encendiendo nuevamente la máquina virtual...${FinColor}"
              echo ""
              qm start $vId
            elif [ $vEstadoMV == "stopped" ]; then
              mkdir -p $vCarpetaCopSeg$vId 2> /dev/null
              vzdump $vId --mode stop --compress gzip --dumpdir $vCarpetaCopSeg$vId/
              # Cambiar de nombre la carpeta de la copia
                vNombreDeLaMV=$(find $vCarpetaCopSeg$vId -maxdepth 1 -type f -name *.log -exec grep "VM Name" {} \; | cut -d' ' -f6)
                if [ -d $vCarpetaCopSeg$vId"-"$vNombreDeLaMV ]; then                                                          # Si ya existe una carpeta con el nombre completo
                  mv $vCarpetaCopSeg$vId/* $vCarpetaCopSeg$vId"-"$vNombreDeLaMV/                                              # mover todos los archivos a ella
                  rm -rf $vCarpetaCopSeg$vId                                                                                  # y borrar la carpeta que sólo tiene el id de la MV.
                else                                                                                                          # Si no existe una carpeta con el mismo nombre
                  find $vCarpetaCopSeg -depth -type d -name "$vId" -print -exec mv {} $vCarpetaCopSeg$vId"-"$vNombreDeLaMV \; # mover la carpeta de sólo número a una carpeta con nombre completo.
                fi
              echo ""
              echo -e "${ColorVerde}      Copia de seguridad realizada.${FinColor}"
              echo ""
            else # No se puede determinar si está apagado o encendido
              echo ""
              echo -e "${ColorRojo}      No se ha podido determinar si la máquina virtual $vId está apagada o encendida.${FinColor}"
              echo -e "${ColorRojo}      Se aborta su copia de seguridad.${FinColor}"
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

# Reemplazar los nombres de las carpetas de las copias de cada máquina virtual por el nombre completo
#echo ""
#echo "  Reemplazando el nombre de las carpetas por nombres completos de las máquinas virtuales"
#echo ""
#for IdMV in $(seq $MVIni $MVFin);
#  do
#    NombreDeLaMV=$(find $Carpeta$IdMV -maxdepth 1 -type f -name *.log -exec grep "VM Name" {} \; | cut -d' ' -f6)
#    if [ -d $Carpeta$IdMV"-"$NombreDeLaMV ]; then                                                    # Si ya existe una carpeta con el nombre completo
#      mv $Carpeta$IdMV/* $Carpeta$IdMV"-"$NombreDeLaMV/                                              # mover todos los archivos a ella
#      rm -rf $Carpeta$IdMV                                                                           # y borrar la carpeta que sólo tiene el número de la MV
#    else                                                                                             # Si no existe una carpeta con el mismo nombre
#      find $Carpeta -depth -type d -name "$IdMV" -print -exec mv {} $Carpeta$IdMV"-"$NombreDeLaMV \; # mover la carpeta de sólo número a una carpeta con nombre completo
#    fi
#  done


# Apuntar fecha en el log
  touch /var/log/CopiasDeSeguridad.log
  echo "$vFechaDeEjec - Terminada la copia de seguridad de todas las máquinas virtuales." >> /var/log/CopiasDeSeguridad.log

# Notificar fin del script
  echo ""
  echo -e "${ColorVerde}  Ejecución del script, finalizada.${FinColor}"
  echo ""
