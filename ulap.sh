########################################################################################
# Install Apache, MariaDB, and PHP
#
apt-get install apache2 mariadb-server php libapache2-mod-php php-mysql php-intl php-curl php-json php-gd php-xml php-mbstring php-zip -y
#
# Apache and MariaDB service
#
systemctl start apache2
systemctl start mariadb
systemctl enable apache2
systemctl enable mariadb
#
## CONFIGURE APACHE2 FOR OWNCLOUD
#
echo "" >> /etc/apache2/sites-available/owncloud.conf
echo "Alias / "/var/www/owncloud/"" >> /etc/apache2/sites-available/owncloud.conf
echo "" >> /etc/apache2/sites-available/owncloud.conf
echo "<Directory /var/www/owncloud/>" >> /etc/apache2/sites-available/owncloud.conf
echo "Options +FollowSymlinks" >> /etc/apache2/sites-available/owncloud.conf
echo "AllowOverride All" >> /etc/apache2/sites-available/owncloud.conf
echo "" >> /etc/apache2/sites-available/owncloud.conf
echo "</Directory>" >> /etc/apache2/sites-available/owncloud.conf
echo "<IfModule mod_dav.c>" >> /etc/apache2/sites-available/owncloud.conf
echo "Dav off" >> /etc/apache2/sites-available/owncloud.conf
echo "</IfModule>" >> /etc/apache2/sites-available/owncloud.conf
#
# Install OwnCloud on Debian 11
#
apt-get install curl gnupg2 -y
echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/server:/10/Debian_11/ /' > /etc/apt/sources.list.d/owncloud.list
curl -fsSL https://download.opensuse.org/repositories/isv:ownCloud:server:10/Debian_11/Release.key | gpg --dearmor > /etc/apt/trusted.gpg.d/owncloud.gpg
apt-get update -y
apt-get install owncloud-complete-files -y
#

# APACHE2 {Modules}
a2ensite owncloud
a2dissite 000-default.conf
a2enmod rewrite mime unique_id
systemctl restart apache2
echo 'mysql'
echo 'MariaDB [(none)]> create database ownclouddb;'
echo 'MariaDB [(none)]> grant all on ownclouddb.* to owncloud@localhost identified by "password";'
echo 'MariaDB [(none)]> flush privileges;'
echo 'MariaDB [(none)]> exit;'
#
########################################################################################


