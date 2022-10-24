#!/bin/bash
set -e
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi
echo "      Welcome to KoolSetup Script"
echo "With this script you can setup your server"
echo "         On your ubuntu server"
echo "    Copyright 2022 KoolKidDevelopment"
read -p "Press any key to start installing ..."
cd /etc/ssh
rm sshd_config
curl -o sshd_config https://raw.githubusercontent.com/KoolKid-Development/Easy-Setup/main/Files/sshd_config
systemctl restart ssh
systemctl restart sshd
echo "We enabled root login and password auth"
echo "Lets setup a password!"
sudo passwd
apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
add-apt-repository ppa:redislabs/redis -y
apt-add-repository universe
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} nginx certbot python3-certbot-nginx iptables mariadb-server tar unzip git iptables-persistent
sudo apt update
sudo apt -y upgrade
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
iptables-save > /etc/iptables/rules.v4
cd /etc/nginx/sites-available
rm default
cd /etc/nginx/sites-enabled
rm default
cd /etc/nginx/sites-available
curl -o website.conf https://raw.githubusercontent.com/KoolKid-Development/Easy-Setup/main/Files/website.conf
sudo ln -s /etc/nginx/sites-available/website.conf /etc/nginx/sites-enabled/website.conf
mkdir /var/www/website
cd /var/www/website
curl -o index.php https://raw.githubusercontent.com/KoolKid-Development/Easy-Setup/main/Files/index.php
curl -o style.css https://raw.githubusercontent.com/KoolKid-Development/Easy-Setup/main/Files/style.css
systemctl stop nginx
nano /etc/nginx/sites-available/website.conf
echo "No the only thing left is the certificate and to start nginx"
echo "Use: certbot certonly --standalone -d yourdomain.com"
echo "And after that systemctl start nginx"
echo "And you are done!"
