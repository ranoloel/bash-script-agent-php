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
    local APPLICATION_ENV=$3

    #local INI_SCAN_DIR_CLI = `/etc/php/$1/fpm/conf.d/`
    if (is_64bit); then
        echo 'Installing 64 bit'
        EXTENSION_FILE="${MAIN_INSTALL_PHP_APM_DIR}/linux_64/stackify-${PHP_VERSION}.so"
    fi
    echo "Installing into $EXTENSION_DIR : $EXTENSION_FILE : $MAIN_INSTALL_PHP_APM_DIR"
    if [ -f "$EXTENSION_FILE" ]; then
        echo "Uninstall into test $EXTENSION_DIR"
        unlink ${EXTENSION_DIR}/stackify.so > /dev/null 2>&1
        # echo "unlink ${EXTENSION_FILE} ${EXTENSION_DIR}/stackify.so > /dev/null 2>&1"
        unlink ${EXTENSION_DIR}/Stackify.php > /dev/null 2>&1
        # echo "unlink ${EXTENSION_DIR}/Stackify.php > /dev/null 2>&1"

        echo "Installing into test $EXTENSION_DIR"
        ln -s ${EXTENSION_FILE} ${EXTENSION_DIR}/stackify.so > /dev/null 2>&1
        # echo "ln -s ${EXTENSION_FILE} ${EXTENSION_DIR}/stackify.so > /dev/null 2>&1"
        ln -s ${MAIN_INSTALL_PHP_APM_DIR}/Stackify.php ${EXTENSION_DIR}/Stackify.php > /dev/null 2>&1
        # echo "ln -s ${MAIN_INSTALL_PHP_APM_DIR}/Stackify.php ${EXTENSION_DIR}/Stackify.php > /dev/null 2>&1"

        # Add stackify block on
        sed -i '/stackify/d' "$PHP_FPM_INI"
        echo "Stackify - fpm - setup"
block_fpm="[stackify]
extension=stackify.so
stackify.application_name=Test FPM $APPLICATION_DESC $PHP_VERSION
stackify.environment_name=$APPLICATION_ENV"   
        echo "$block_fpm" >> "$PHP_FPM_INI"
    
        sed -i '/stackify/d' "$PHP_APACHE2_INI"
        echo "Stackify - apache 2 - setup"
block_apache="[stackify]
extension=stackify.so
stackify.application_name=Test Apache $APPLICATION_DESC $PHP_VERSION
stackify.environment_name=$APPLICATION_ENV"
        echo "$block_apache" >> "$PHP_APACHE2_INI"
    fi  
}

echo "Install PHP profiler extensions"
for item in ${PHP_VERSIONS[*]}
do
    LOCAL_PHP="php$item"
    if [ -x "$(command -v $LOCAL_PHP)" ]; then
        echo "Adding profiler $LOCAL_PHP"
        update_php_apm_links "$item" "$1" "$2"
    else
        echo "No php $LOCAL_PHP"
    fi
done;

# Return good status? :D 
exit 0