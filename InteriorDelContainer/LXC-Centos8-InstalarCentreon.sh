hostnamectl set-hostname centreon.asirtienda.ddns.net
yum -y install chrony
systemctl enable  chronyd
systemctl restart chronyd
dnf -y install dnf-plugins-core epel-release
dnf config-manager --set-enabled powertools
dnf module reset -y php
dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
dnf module install php:remi-8.0 -y
dnf -y install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json php-opcache
echo "date.timezone = Europe/Madrid" | tee -a /etc/php.d/50-centreon.ini
systemctl restart php-fpm
systemctl enable php-fpm
dnf -y install @mariadb:10.5
systemctl enable --now mariadb
mysql_secure_installation
dnf install -y https://yum.centreon.com/standard/22.04/el8/stable/noarch/RPMS/centreon-release-22.04-3.el8.noarch.rpm
dnf install centreon centreon-database



yum -y install hostname
curl -L -s https://raw.githubusercontent.com/centreon/centreon/master/unattended.sh | sh
