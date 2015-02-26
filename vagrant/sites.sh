#!/usr/bin/env bash

echo ">>> Adding vhost"

# vhost form Vaprobash
# curl --silent -L https://raw.githubusercontent.com/fideloper/Vaprobash/master/helpers/vhost.sh > vhost
cd ~
cp /vagrant/vagrant/vhost.sh vhost
sudo chmod guo+x vhost
sudo mv vhost /usr/local/bin/

# add website in here with vhost command
# sudo vhost -s ServerName -d DocumentRoot

# Restart Apache2
sudo service apache2 reload
sudo service apache2 restart