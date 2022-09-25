reset
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

# check for curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi
echo "  Welcome to KoolCDN Installer Script"
echo "With this script you can install KoolCDN"
echo "         On your ubuntu server"
echo "    Copyright 2022 KoolKidDevelopment"
read -p "Press any key to start installing ..."
cd /etc/ssh
rm sshd_config
curl -o sshd_config https://raw.githubusercontent.com/KoolKid-Development/KoolCDN-InstallScript/main/Files/sshd_config
systemctl restart ssh
systemctl restart sshd
sudo passwd
apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
add-apt-repository ppa:redislabs/redis -y
apt-add-repository universe
apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} nginx 
sudo apt install -y certbot
sudo apt install -y python3-certbot-nginx
sudo apt update && sudo apt upgrade
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
cd /etc/nginx/sites-available
rm default
cd /etc/nginx/sites-enabled
rm default
cd /etc/nginx/sites-available
curl -o cdn.conf https://raw.githubusercontent.com/KoolKid-Development/KoolCDN-InstallScript/main/Files/cdn.conf
sudo ln -s /etc/nginx/sites-available/cdn.conf /etc/nginx/sites-enabled/cdn.conf
mkdir /var/www/cdn
systemctl stop nginx
nano /etc/nginx/sites-available/cdn.conf
echo "No the only thing left is the certificate and to start nginx"
echo "Use: certbot certonly --standalone -d cdn.yourdomain.com"
echo "And after that systemctl start nginx"
echo "And you are done!"
