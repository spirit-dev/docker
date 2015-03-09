#!/bin/bash
REPLACEMENT="ENV SYMFONY2_APP_URL_PREFIXER $1"
#echo "$REPLACEMENT"
#sed -e 's/ENV CI_VERSION to_be_defined/`"$REPLACEMENT"`/g' Dockerfile.ref | tee Dockerfile
sed -e "s/ENV SYMFONY2_APP_URL_PREFIXER to_be_defined/${REPLACEMENT}/g" Dockerfile.tmp | tee Dockerfile
#cat Dockerfile.ref | awk '{ sub(/ENV CI_VERSION to_be_defined/,"ENV CI_VERSION /"$1"/ @ /"$NOW"/");print}' > Dockerfile
cat Dockerfile
