#!/bin/bash

echo "=> Setting CI_VERSION"
NOW="$(date)"
CI_VERSION="ENV CI_VERSION $1 @ $NOW"
sed -i -r "s/ENV CI_VERSION.*$/${CI_VERSION}/" Dockerfile



echo "=> Setting SYMFONY2_APP_URL_PREFIXER"
PREFIX="ENV SYMFONY2_APP_URL_PREFIXER $2"
sed -i -r "s/ENV SYMFONY2_APP_URL_PREFIXER.*$/${PREFIX}/" Dockerfile
 

cat Dockerfile
