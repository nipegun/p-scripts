#!/bin/bash

# Instalar dependencias
  apt-get -y update
  apt-get -y install git
  apt-get -y install ansible
  apt-get -y install sudo

# Clonar repo de ansible de faust
  git clone https://github.com/fausecteam/ctf-gameserver-ansible.git

# Descargar archivos
  curl -L https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/gameserver/playbook.yml        -o ~/ctf-gameserver-ansible/playbook.yml
  curl -L https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/gameserver/prod_settings.py.j2 -o ~/ctf-gameserver-ansible/roles/web/templates/prod_settings.py.j2

# Instalar gameserver usando ansible
  cd ctf-gameserver-ansible
  curl -L https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/gameserver/ctf-gameserver_1.0_all.deb -o /tmp/ctf-gameserver_1.0_all.deb
  sudo ansible-playbook playbook.yml
  cd ..

# uwsgi
  sudo apt-get -y install uwsgi
  sudo apt-get -y install uwsgi-plugin-python3
  curl -L https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/gameserver/uwsgi.ini -o /etc/uwsgi/apps-available/ctf_gameserver.ini
  sudo ln -s /etc/uwsgi/apps-available/ctf_gameserver.ini /etc/uwsgi/apps-enabled/
  sudo systemctl restart uwsgi

# nginx
  sudo apt-get -y install nginx
  curl -L https://raw.githubusercontent.com/nipegun/p-scripts/refs/heads/master/MVs/Packs/FaustCTF/gameserver/nginx.conf -o /etc/nginx/sites-available/ctf_gameserver.conf
  sudo rm /etc/nginx/sites-enabled/default
  sudo ln -s /etc/nginx/sites-available/ctf_gameserver.conf /etc/nginx/sites-enabled/
  sudo systemctl restart nginx
