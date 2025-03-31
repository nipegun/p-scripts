#!/bin/bash

# Instalar dependencias
  apt-get -y update
  apt-get -y install git
  apt-get -y install ansible

# Clonar repo de ansible de faust
  git clone https://github.com/fausecteam/ctf-gameserver-ansible.git


mv playbook.yml ctf-gameserver-ansible/
mv prod_settings.py.j2 ctf-gameserver-ansible/roles/web/templates -f

#Install Gameserver with ansible
cd ctf-gameserver-ansible
sudo ansible-playbook playbook.yml
cd ..

#uwsgi
#sudo apt install python3-dev python3-pip gcc # python3-venv -y #errepasatu ea venv beahr den
sudo apt install uwsgi uwsgi-plugin-python3 -y
sudo uwsgi.ini /etc/uwsgi/apps-available/ctf_gameserver.ini
sudo ln -s /etc/uwsgi/apps-available/ctf_gameserver.ini /etc/uwsgi/apps-enabled/
sudo systemctl restart uwsgi

#nginx
sudo apt install nginx -y
sudo mv nginx.conf /etc/nginx/sites-available/ctf_gameserver.conf
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/ctf_gameserver.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx

#corrections
#/etc/ctf-gameserver/web/prod_settings.py fitxategian ALLOWED_HOSTS = ['*']
