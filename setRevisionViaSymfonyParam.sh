#!/bin/bash
NOW="$(date)"
REPLACEMENT="$1 @ $NOW"
#echo "$REPLACEMENT"
#sed -e 's/ENV CI_VERSION to_be_defined/`"$REPLACEMENT"`/g' Dockerfile.ref | tee Dockerfile
sed -e "s/ci_version: defined_by_jenkins/ci_version: \"${REPLACEMENT}\"/g" Symfony2APP/app/config/parameters.yml.dock | tee Symfony2APP/app/config/parameters.yml
#cat Dockerfile.ref | awk '{ sub(/ENV CI_VERSION to_be_defined/,"ENV CI_VERSION /"$1"/ @ /"$NOW"/");print}' > Dockerfile
cat Symfony2APP/app/config/parameters.yml
