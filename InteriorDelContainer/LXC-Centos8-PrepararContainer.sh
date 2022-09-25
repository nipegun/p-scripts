sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*
echo "vm.swappiness=0" >> /etc/sysctl.d/swappiness.conf
yum -y update
yum -y upgrade


