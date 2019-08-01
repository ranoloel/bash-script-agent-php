#!/bin/bash

sudo mkdir -p /tmp/stackify-php-apm
sudo unzip -o $1 -d /tmp/stackify-php-apm
sudo chown -R stackify:stackify /tmp/stackify-php-apm
sudo cp -R /tmp/stackify-php-apm /usr/local/stackify/
sudo rm -rf /tmp/stackify-php-apm