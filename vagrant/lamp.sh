#!/usr/bin/env bash

PHP_VERSION=$1
MYSQL_VERSION=$2
MYSQL_ROOT_PASSWORD=$3


[[ -z "$MYSQL_ROOT_PASSWORD" ]] && { echo "!!! MySQL root password not set. Check the Vagrant file."; exit 1; }

# ======================
# echo ">>> Installing PHP $PHP_VERSION"
echo ">>> Installing PHP"

# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C

# if [ $PHP_VERSION == "5.5" ]; then
#     # Add repo for PHP 5.5
#     sudo add-apt-repository -y ppa:ondrej/php5
# else
#     # Add repo for PHP 5.6
#     sudo add-apt-repository -y ppa:ondrej/php5-5.6
# fi

# # Update Again
# sudo apt-key update
# sudo apt-get update

# Install PHP
# -qq implies -y --force-yes
sudo apt-get install -qq php5 php5-cli php5-fpm php5-mysql php5-mcrypt php5-gd php5-imagick php5-xdebug

# Set PHP FPM to listen on TCP instead of Socket
# sudo sed -i "s/listen =.*/listen = 127.0.0.1:9000/" /etc/php5/fpm/pool.d/www.conf

# Set PHP FPM allowed clients IP address
# sudo sed -i "s/;listen.allowed_clients/listen.allowed_clients/" /etc/php5/fpm/pool.d/www.conf

# Set run-as user for PHP5-FPM processes to user/group "vagrant"
# to avoid permission errors from apps writing to files
# sudo sed -i "s/user = www-data/user = vagrant/" /etc/php5/fpm/pool.d/www.conf
# sudo sed -i "s/group = www-data/group = vagrant/" /etc/php5/fpm/pool.d/www.conf

# sudo sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php5/fpm/pool.d/www.conf
# sudo sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php5/fpm/pool.d/www.conf
# sudo sed -i "s/listen\.mode.*/listen.mode = 0666/" /etc/php5/fpm/pool.d/www.conf

echo ">>> Configuring PHP"

# xdebug Config
#cat > $(find /etc/php5 -name xdebug.ini) << EOF
#zend_extension=$(find /usr/lib/php5 -name xdebug.so)
cat > $(find /etc/php5 -name xdebug.ini) << EOF
zend_extension=$(find /usr/lib/php5 -name xdebug.so)
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.remote_port = 9000
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1

; var_dump display
xdebug.var_display_max_depth = 5
xdebug.var_display_max_children = 256
xdebug.var_display_max_data = 1024
EOF

# PHP Configuration
sudo sed -i 's/short_open_tag = .*/short_open_tag = On/' /etc/php5/fpm/php.ini

# PHP Error Reporting Config
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

# PHP Date Timezone

sudo service php5-fpm restart

# ======================

echo ">>> Installing Apache Server"

# sudo add-apt-repository ppa:ondrej/apache2

# Update Again
# sudo apt-key update
# sudo apt-get update

# Install Apache
sudo apt-get install -qq apache2 libapache2-mod-fastcgi apache2-mpm-event

echo ">>> Configuring Apache"
# Add vagrant user to www-data group
# sudo usermod -a -G www-data vagrant

# Create php5-fpm.conf
cat > /etc/apache2/conf-available/php5-fpm.conf << EOF
<IfModule mod_fastcgi.c>
    AddHandler php5-fcgi .php
    Action php5-fcgi /php5-fcgi
    Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
    FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization

    <Directory /usr/lib/cgi-bin>
        Require all granted
    </Directory>

</IfModule>
EOF

# PHP Config for Apache
sudo a2enmod actions fastcgi alias
sudo a2dismod mpm_prefork php5
sudo a2enconf php5-fpm
sudo a2enmod mpm_event

# Rewrite mod
sudo a2enmod rewrite

# Restart Apache2
sudo service apache2 reload
sudo service apache2 restart

# ======================
# echo ">>> Installing MySQL Server $MYSQL_VERSION"
echo ">>> Installing MySQL Server"

MYSQL_PACKAGE=mysql-server

# if [ $MYSQL_VERSION == "5.6" ]; then
# 	# Add repo for MySQL 5.6
#     sudo add-apt-repository -y ppa:ondrej/mysql-5.6

#     # Update Again
#     sudo apt-get update

#     # Change package
#     mysql_package=mysql-server-5.6
# fi

# Install MySQL without password prompt
# Set username and password to 'root'
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

# Install MySQL Server
# -qq implies -y --force-yes
sudo apt-get install -qq $MYSQL_PACKAGE