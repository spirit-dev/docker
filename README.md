How to run Spirit-Dev / MariaDB container

docker pull spiritdev/mariadb:latest

docker run -d --name spiritdev_mariadb -p 3307:3306 -v /tmp/mariadb:/data spiritdev/mariadb