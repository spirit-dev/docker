#!/bin/sh
##

# Change to web-root
cd /var/www

#echo "=> Exporting Mysql Host Address"
#export SYMFONY__DATABASE__HOST=$MARIADB_PORT_3306_TCP_ADDR
#echo "=> Done !"

echo "=> Prepare Symfony Env"
#cp /var/www/app/config/config_dock.yml /var/www/app/config/config.yml
cp /var/www/app/config/routing_dev_dock.yml /var/www/app/config/routing_dev.yml
cp /var/www/app/config/parameters.yml.dock /var/www/app/config/parameters.yml
echo "=> Done !"

echo "=> Rewriting Parameters.yml"
sed -i -r "s/ci_version: defined_by_jenkins/ci_version: \"${CI_VERSION}\"/" /var/www/app/config/parameters.yml
sed -i -r "s/database_host.*$/database_host: '"$PROD_MARIADB_PORT_3306_TCP_ADDR"'/" /var/www/app/config/parameters.yml
echo "=> Done !"

echo "=> Disactivating Dev Web Profiler"
sed -i -r "s/base_url.*$/base_url: '"$BASE_URL"'/" /var/www/app/config/config.yml

sed -i -r "s/web_profiler.*$/#web_profiler:/" /var/www/app/config/config_dev.yml
sed -i -r "s/toolbar.*$/#toolbar: true/" /var/www/app/config/config_dev.yml
sed -i -r "s/intercept_redirects.*$/#intercept_redirects: false/" /var/www/app/config/config_dev.yml

sed -i -r "s/^WebProfilerBundle/\/\//" /var/www/app/AppKernel.php
echo "=> Done !"

# Download and run Composer
#echo "=> Downloading Composer ..."
#wget http://getcomposer.org/composer.phar -O composer.phar
#echo "=> Done !"
#
echo "=> Installing Symfony vendors"
php composer.phar install --optimize-autoloader --prefer-dist
echo "=> Done !"

echo "=> Installing Symfony assets hard copy"
#php app/console assets:install web --symlink
php app/console assets:install web
echo "=> Done !"

case "$ENV" in
  "Production")
    echo "=> Executing Production stuff"

    echo "=> Updating apache2 vhost"
    sed -i -r "s/#DirectoryIndex.*$/DirectoryIndex app.php/" /etc/apache2/sites-enabled/000-virtual-host.conf
    sed -i -r "s/#RewriteRule.*$/RewriteRule \^\(\.\*\)\\$ \/app.php\/"$SYMFONY2_APP_URL_PREFIXER"\/\$1 [QSA,L]/" /etc/apache2/sites-enabled/000-virtual-host.conf
    #sed -i -r "s/#RewriteRule \^\/\_wdt\/\$.*$/RewriteRule \^\/\_wdt\/\$ \/app.php\/"$SYMFONY2_APP_URL_PREFIXER"\/\$1 [QSA,L]/" /etc/apache2/sites-enabled/000-virtual-host.conf
    echo "=> Done !"

    #echo "=> Installing Symfony vendors"
    #php composer.phar install --optimize-autoloader --prefer-dist
    #echo "=> Done !"
    
    echo "=> Production Dumping assets"
    php app/console assetic:dump --env=prod
    echo "=> Done !"

    echo "=> Production Cache clear"
    php app/console cache:clear --env=prod
    echo "=> Done !"

    #echo "=> Production DB Migration"
    #php app/console doctrine:migrations:migrate --env=prod --no-interaction
    #echo "=> Done !"
    ;;

  "Development" | "Staging")
    echo "=> Executing Development stuff"

    echo "=> Updating apache2 vhost"
    #sed -i -r "s/#DirectoryIndex.*$/DirectoryIndex app.php/" /etc/apache2/sites-enabled/000-virtual-host.conf
    #sed -i -r "s/#RewriteRule.*$/RewriteRule \^\(\.\*\)\\$ \/app.php\/"$SYMFONY2_APP_URL_PREFIXER"\/\$1 [QSA,L]/" /etc/apache2/sites-enabled/000-virtual-host.conf
    sed -i -r "s/#DirectoryIndex.*$/DirectoryIndex app_dev.php/" /etc/apache2/sites-enabled/000-virtual-host.conf
    sed -i -r "s/#RewriteRule.*$/RewriteRule \^\(\.\*\)\\$ \/app_dev.php\/"$SYMFONY2_APP_URL_PREFIXER"\/\$1 [QSA,L]/" /etc/apache2/sites-enabled/000-virtual-host.conf
    #sed -i -r "s/#RewriteRule \^\/\_wdt\/\$.*$/RewriteRule \^\/\_wdt\/\$ \/app_dev.php\/"$SYMFONY2_APP_URL_PREFIXER"\/\$1 [QSA,L]/" /etc/apache2/sites-enabled/000-virtual-host.conf
    echo "=> Done !"

    #echo "=> Installing Symfony vendors"
    #php composer.phar update
    #echo "=> Done !"
    
    echo "=> Development Dumping assets"
    #php app/console assetic:dump --env=prod
    php app/console assetic:dump --env=dev
    echo "=> Done !"

    echo "=> Development Cache clear"
    #php app/console cache:clear --env=prod
    php app/console cache:clear --env=dev
    echo "=> Done !"

    echo "=> Development Deleting DB"
    php app/console doctrine:database:drop --force --no-interaction
    echo "=> Done !"

    echo "=> Development Creating DB"
    #php app/console doctrine:database:create --env=prod --no-interaction
    php app/console doctrine:database:create --env=dev --no-interaction
    echo "=> Done !"

    echo "=> Development Update schema"
    #php app/console doctrine:schema:update --force --env=prod --no-interaction
    php app/console doctrine:schema:update --force --env=dev --no-interaction
    echo "=> Done !"

    echo "=> Development Create fixtures"
    php app/console doctrine:fixtures:load --no-interaction
    echo "=> Done !"
    ;;
esac

# Get rid of nasty root permissions
chown -R www-data:root /var/www

# Run Apache2
/usr/sbin/apache2ctl -D FOREGROUND