#!/bin/bash
sudo apt-get update
sudo apt-get -y upgrade

sudo add-apt-repository -y ppa:nginx/development
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update

# Basics
sudo apt-get install -y git vim curl wget zip unzip htop

# Install PHP Stuffs
# Current PHP
sudo apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.2-cli php7.2-dev \
php7.2-pgsql php7.2-sqlite3 php7.2-gd \
php7.2-curl php7.2-memcached \
php7.2-imap php7.2-mysql php7.2-mbstring \
php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap \
php7.2-intl php7.2-readline \
php7.2-mongodb

# PHP 7.1
sudo apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.1-cli php7.1-dev \
php7.1-pgsql php7.1-sqlite3 php7.1-gd \
php7.1-curl php7.1-memcached \
php7.1-imap php7.1-mysql php7.1-mbstring \
php7.1-xml php7.1-zip php7.1-bcmath php7.1-soap \
php7.1-intl php7.1-readline php7.1-mongodb

# PHP 7.0
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.0-cli php7.0-dev \
php7.0-pgsql php7.0-sqlite3 php7.0-gd \
php7.0-curl php7.0-memcached \
php7.0-imap php7.0-mysql php7.0-mbstring \
php7.0-xml php7.0-zip php7.0-bcmath php7.0-soap \
php7.0-intl php7.0-readline php7.0-mongodb

# PHP 5.6
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php5.6-cli php5.6-dev \
php5.6-pgsql php5.6-sqlite3 php5.6-gd \
php5.6-curl php5.6-memcached \
php5.6-imap php5.6-mysql php5.6-mbstring \
php5.6-xml php5.6-zip php5.6-bcmath php5.6-soap \
php5.6-intl php5.6-readline php5.6-mcrypt php5.6-mongo

# Install composer
sudo php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer

# Set default php for CLI usage (check php -v to validate after setting)
sudo update-alternatives --set php /usr/bin/php7.2

# Install PHP FPM and NGINX
sudo apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
nginx php5.6-fpm php7.0-fpm php7.1-fpm php7.2-fpm

# Disable XDebug On The CLI
sudo phpdismod -s cli xdebug

# Disable XDebug On The FPM
sudo phpdismod -s fpm xdebug

service php7.2-fpm stop
service php7.1-fpm stop
service php7.0-fpm stop
service php5.6-fpm stop