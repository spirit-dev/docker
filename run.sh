#!/bin/sh
##

# Change to web-root
cd /var/www

#echo "=> Exporting Mysql Host Address"
#export SYMFONY__DATABASE__HOST=$MARIADB_PORT_3306_TCP_ADDR
#echo "=> Done !"

echo "=> Rewriting Parameters.yml"
sed -i -r "s/database_host.*$/database_host: '"$PROD_MARIADB_PORT_3306_TCP_ADDR"'/" /var/www/app/config/parameters.yml
echo "=> Done !"

# Download and run Composer
#echo "=> Downloading Composer ..."
#wget http://getcomposer.org/composer.phar -O composer.phar
#echo "=> Done !"
echo "=> Installing Symfony vendors"
php composer.phar install --optimize-autoloader --prefer-dist
echo "=> Done !"

# Symfony2 actions
#php app/console assets:install web --symlink
echo "=> Installing Symfony assets hard copy"
php app/console assets:install web
echo "=> Done !"

case "$ENV" in
  "Production")
    echo "=> Executing Production stuff"
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
    #echo "=> Installing Symfony vendors"
    #php composer.phar update
    #echo "=> Done !"
    echo "=> Development Dumping assets"
    php app/console assetic:dump --env=dev
    echo "=> Done !"
    echo "=> Development Cache clear"
    php app/console cache:clear --env=dev
    echo "=> Done !"
    echo "=> Development Deleting DB"
    php app/console doctrine:database:drop --force --no-interaction
    echo "=> Development Creating DB"
    php app/console doctrine:database:create --env=dev --no-interaction
    echo "=> Done !"
    echo "=> Development Update schema"
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
