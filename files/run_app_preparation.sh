#!/bin/sh

cd /DATA

case "$APP_TYPE" in
  "Symfony2")

	composer self-update

	case "$ENV" in
		"production")
			echo "=> Executing Production stuff"

			#echo "=> Updating apache2 vhost"
			#sed -i -r "s/#DirectoryIndex.*$/DirectoryIndex app.php/" /etc/apache2/sites-enabled/000-virtual-host.conf
			#sed -i -r "s/#RewriteRule.*$/RewriteRule \^\(\.\*\)\\$ \/app.php\/\$1 [QSA,L]/" /etc/apache2/sites-enabled/000-virtual-host.conf
			# Deprecated
			#sed -i -r "s/#RewriteRule.*$/RewriteRule \^\(\.\*\)\\$ \/app.php\/"$SYMFONY2_APP_URL_PREFIXER"\/\$1 [QSA,L]/" /etc/apache2/sites-enabled/000-virtual-host.conf
			#echo "=> Done !"

			echo "=> Installing Symfony vendors"
			composer install --optimize-autoloader --prefer-dist
			echo "=> Done !"
			
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

			echo "=> Installing Symfony vendors"
			composer update
			echo "=> Done !"
			
			echo "=> Development Dumping assets"
			php app/console assets:install web
			php app/console assetic:dump --env=dev
			echo "=> Done !"

			echo "=> Development Cache clear"
			php app/console cache:clear --env=dev
			echo "=> Done !"


			case "$DB_LINKED" in
				"true")
					echo "=> Development Deleting DB"
					php app/console doctrine:database:drop --force --no-interaction
					echo "=> Done !"

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
		;;
	esac

	;;
esac
