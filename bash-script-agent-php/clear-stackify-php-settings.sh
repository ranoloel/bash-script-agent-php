#!/bin/bash
readonly MAIN_INSTALL_DIR="/usr/local/stackify"
readonly MAIN_INSTALL_PHP_APM_DIR="${MAIN_INSTALL_DIR}/stackify-php-apm"
readonly PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2")

is_64bit() {
    # this will check if the machine is 64bit and if so return true
    if [ "`uname -m`" == "x86_64" ]; then
        return 0
    else
        return 1
    fi
}

update_php_apm_links() {
    local PHP_VERSION=$1;

    local EXTENSION_DIR=`/usr/bin/php$1 -r 'echo ini_get("extension_dir");'`
    local EXTENSION_FILE="${MAIN_INSTALL_PHP_APM_DIR}/linux_32/stackify-${PHP_VERSION}.so"

    local PHP_DIR_FPM="/etc/php/$1/fpm"
    local PHP_DIR_APACHE2="/etc/php/$1/apache2"
    local PHP_FPM_INI="$PHP_DIR_FPM/php.ini"
    local PHP_APACHE2_INI="$PHP_DIR_APACHE2/php.ini"

    local APPLICATION_DESC=$2

    echo "Uninstall into test $EXTENSION_DIR"
    sed -i '/stackify/d' "$PHP_FPM_INI"
    sed -i '/stackify/d' "$PHP_APACHE2_INI"
}

echo "Remove PHP profiler extensions"
for item in ${PHP_VERSIONS[*]}
do
    LOCAL_PHP="php$item"
    if [ -x "$(command -v $LOCAL_PHP)" ]; then
        echo "Removing profiler settings - $LOCAL_PHP"
        update_php_apm_links "$item"
    else
        echo "No php $LOCAL_PHP"
    fi
done;

# Return good status? :D 
exit 0