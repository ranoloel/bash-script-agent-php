#!/bin/bash

# Setup Some PHP-FPM Options
sed -i '/xdebug.remote_enable.*/d' "/etc/php/7.2/mods-available/xdebug.ini"
sed -i '/xdebug.remote_connect_back.*/d' "/etc/php/7.2/mods-available/xdebug.ini"
sed -i '/xdebug.remote_port.*/d' "/etc/php/7.2/mods-available/xdebug.ini"
sed -i '/xdebug.max_nesting_level.*/d' "/etc/php/7.2/mods-available/xdebug.ini"
sed -i '/xdebug.profiler_enable.*/d' "/etc/php/7.2/mods-available/xdebug.ini"
sed -i '/xdebug.profiler_enable_trigger.*/d' "/etc/php/7.2/mods-available/xdebug.ini"

echo "xdebug.remote_enable = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.profiler_enable = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.profiler_enable_trigger = 1" >> /etc/php/7.2/mods-available/xdebug.ini