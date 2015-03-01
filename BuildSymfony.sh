#!/bin/sh

# Launching MariaDB
#docker pull spiritdev/mariadb:latest
#docker stop mariadb && docker rm mariadb
#docker run -d --name mariadb -p 3307:3306 -v /tmp/mariadb:/data spiritdev/mariadb
#
#read -p "Wait 1 minute before continuing"
#docker logs mariadb
#echo "Go configure mysql user !"
#read -p "Continue ?"

# Building Symfony
#cd /Users/Dropbox/MyDocuments/Docker/Symfony2Test
./setRevisionViaSymfonyParam.sh "app - 1234"
./setRevisionViaDockerfile.sh "app - 1234"
docker build -t agoralink/ilinkyou_api .
# Launching Symfony
docker stop ilinkyou_api && docker rm ilinkyou_api
#docker run -d -p 44250:80 --name ilinkyou_api --link prod_mariadb:prod_mariadb agoralink/ilinkyou_api /bin/bash
docker run -ti -p 44250:80 --name ilinkyou_api --link prod_mariadb:prod_mariadb agoralink/ilinkyou_api /bin/bash