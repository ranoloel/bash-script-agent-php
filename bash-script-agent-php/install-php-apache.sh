#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
sudo service nginx stop
apt-get update
apt-get install -y apache2 libapache2-mod-php"$1"

# Assume user wants mode_rewrite support
sudo a2enmod rewrite

# Turn on HTTPS support
sudo a2enmod ssl

# Turn on headers support
sudo a2enmod headers

service apache2 restart

if [ $? == 0 ]
then
    service apache2 reload
fi

# apt-get install -y libapache2-mod-php5.6
# apt-get install -y libapache2-mod-php7.0
# apt-get install -y libapache2-mod-php7.1
# apt-get install -y libapache2-mod-php7.2

# # Assume user wants mode_rewrite support
# a2enmod rewrite

# # Turn on HTTPS support
# a2enmod ssl

# # Turn on headers support
# a2enmod headers

# # Restart Apache
# service apache2 restart

# # If restart returns an error, try reloading the config
# service apache2 reload