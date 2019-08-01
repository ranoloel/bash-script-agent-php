#!/bin/bash

# Stop nginx 
service nginx stop

# Disable current php module enabled
a2dismod "php*"

# Enable php desired (5.6, 7.0, 7.1, 7.2)
a2enmod "php$1"

# Restart apache
service apache2 restart