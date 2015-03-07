# DOCKER-VERSION 0.3.4
FROM    spiritdev/apache2
MAINTAINER Jean Bordat <bordat.jean@gmail.com>

# Install more packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php5-imagick php5-gd php5-intl php5-mcrypt php5-apcu php5-curl php5-mysql

# Add our virtual-host.conf
ADD ./virtual-host.conf /etc/apache2/sites-enabled/000-virtual-host.conf
RUN a2enmod headers

# Add our initialisation script
ADD ./run.sh /tmp/run.sh
RUN chmod 755 /tmp/run.sh

# Add our symfony application
ADD ./Symfony2APP /var/www

ENV ENV Development
#ENV ENV Production

ENV CI_VERSION AgoraLink-iLinkYou-API - - dev-0.0.0.23 @ Sun Mar  1 13:12:54 CET 2015

#EXPOSE 80

# Commands we need in order to say BOOM
#ENTRYPOINT [ "/bin/bash", "/tmp/run.sh" ]
