#!/bin/bash

# Import env variables
export $(grep -v '^#' .env | xargs)

## Initial configuration
echo Initial configuration

echo - Create shared directory
mkdir -p $DOCKERDIR/shared
echo - Create appdata directory
mkdir -p $DOCKERDIR/appdata

echo - Create symbolic links for '.env'
for DIR in $(pwd)/services/*; do ln -s $(pwd)/.env $DIR/.env; done

## Traefik2
echo Traefik2 proxy
TRAEFIKDIR=$DOCKERDIR/services/traefik2

echo - Create acme directory
mkdir -p $TRAEFIKDIR/acme
echo - Create logs directory
mkdir -p $TRAEFIKDIR/logs

echo - Create acme.json file and set permissions to 600
touch $TRAEFIKDIR/acme/acme.json
chmod 600 $TRAEFIKDIR/acme/acme.json

echo - Create access.log
touch $TRAEFIKDIR/logs/access.log
echo - Create traefik.log
touch $TRAEFIKDIR/logs/traefik.log
