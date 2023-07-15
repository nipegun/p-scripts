#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar todos los entornos de escritorio de Proxmox
# ----------

# XRDP
  systemctl stop xrdp.service
  apt-get -y purge xrdp
  apt-get -y autoremove
  tasksel remove desktop

# cinnamon
  tasksel remove cinnamon-desktop
  apt-get -y purge cinnamon-session
  apt-get -y autoremove --purge cinnamon*
  apt-get -y autoremove

# gnome
  tasksel remove gnome-desktop
  apt-get -y purge gnome-session
  apt-get -y autoremove --purge gnome*
  apt-get -y autoremove

# kde
  tasksel remove kde-desktop
  apt-get -y purge kde-plasma-desktop
  apt-get -y autoremove --purge kde*
  apt-get -y autoremove --purge plasma*
  apt-get -y autoremove

# lxde
  tasksel remove lxde-desktop
  apt-get -y autoremove --purge lxde*
  apt-get -y autoremove

# lxqt
  tasksel remove lxqt-desktop
  apt-get -y purge lxqt-session
  apt-get -y autoremove --purge lxqt*
  apt-get -y autoremove

# mate
  tasksel remove mate-desktop
  apt-get -y purge mate-session-manager
  apt-get -y autoremove --purge mate*
  apt-get -y autoremove

# xfce
  tasksel remove xfce-desktop
  apt-get -y autoremove --purge xfce*

# Gestores de ventanas
  apt-get -y purge gdm3

# Re-Instalar lo necesario
  tasksel install mate-desktop
  apt-get -y install xrdp

# Otras cosas a borrar
  apt-get -y remove akregator
  apt-get -y remove ark
  apt-get -y remove dolphin
  apt-get -y remove dragonplayer
  apt-get -y remove gedit
  apt-get -y remove gwenview
  apt-get -y remove imagemagick
  apt-get -y remove inkscape
  apt-get -y remove juk
  apt-get -y remove k3b
  apt-get -y remove kcalc
  apt-get -y remove konqueror
  apt-get -y remove konsole
  apt-get -y remove kwalletmanager
  apt-get -y remove lxterminal
  apt-get -y remove nautilus
  apt-get -y remove okular
  apt-get -y remove pidgin
  apt-get -y remove rhythmbox
  apt-get -y remove sound-juicer
  apt-get -y remove sweeper
  apt-get -y remove xterm
  apt-get -y autoremove

