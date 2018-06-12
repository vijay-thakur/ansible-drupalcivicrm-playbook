#!/bin/bash
set -xe
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get -y install php-apc php-pear php5-cli php5-common php5-curl php5-fpm php5-gd php5-mysql php-soap nginx git drush
echo "Installed php-5, drush and supported packages"
drush dl drupal-7
echo "Installed drupal-7"
cp -rf drupal-7.56/ drupal
sudo mv drupal /usr/share/nginx/html/
sudo sed -i -e 's@^listen = /var/run/php5-fpm.sock@listen = 127.0.0.1:9000@' /etc/php5/fpm/pool.d/www.conf
sudo sed -i -e 's/localhost/staplegroup.co.nz www.staplegroup.co.nz' /etc/nginx/sites-available/default
sudo /etc/init.d/php5-fpm restart
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update && sudo apt-get install python-certbot-nginx -y
echo "Installed certbot package"
echo "2" |sudo certbot --nginx --renew-by-default --agree-tos -d staplegroup.co.nz -d www.staplegroup.co.nz --email vijay.thakur0909@gmail.com
sudo mv /home/ubuntu/civicrmdrupal.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/civicrmdrupal.conf /etc/nginx/sites-enabled/
echo "Installed letsencrypt certificate"
sudo rm -f /etc/nginx/sites-enabled/default
sudo /etc/init.d/nginx restart
echo "Nginx Restarted"
sudo mkdir -p /etc/nginx/ssl
sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
mysql_password=$(date +%s | sha256sum | base64 | head -c 15 ; echo)
echo $mysql_password > '/home/ubuntu/.mysqlpassword'
echo "mysql-server-5.5 mysql-server/root_password select $mysql_password" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again select $mysql_password" | sudo debconf-set-selections
echo "Install mysql-server-5.5 package"
sudo apt-get -y install mysql-server-5.5
echo "*************Mysql Server Installed*****************"
sleep 3
mysql -u root -p$(cat /home/ubuntu/.mysqlpassword) -e 'create database drupaldb;'
mysql -u root -p$(cat /home/ubuntu/.mysqlpassword) -e 'create database civicrmdb;'
mysql -u root -p$(cat /home/ubuntu/.mysqlpassword) -e "CREATE USER 'drupaluser'@'localhost' IDENTIFIED BY '#8090pure100#';"
mysql -u root -p$(cat /home/ubuntu/.mysqlpassword) -e "CREATE USER 'civicrmuser'@'localhost' IDENTIFIED BY '#8090pure100#';"
mysql -u root -p$(cat /home/ubuntu/.mysqlpassword) -e "GRANT ALL privileges ON drupaldb.* to drupaluser@'%' IDENTIFIED BY '#8090pure100#';"
mysql -u root -p$(cat /home/ubuntu/.mysqlpassword) -e "GRANT ALL privileges ON civicrmdb.* TO civicrmuser@'%' IDENTIFIED BY '#8090pure100#';"
mysql -u root -p$(cat /home/ubuntu/.mysqlpassword) -e "grant SELECT on civicrmdb.* to drupaluser@localhost identified by '#8090pure100#';"

echo "Databases Created"
cd /usr/share/nginx/html/drupal
sudo mkdir -p sites/default/files
