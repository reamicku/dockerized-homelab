#!/bin/bash

# Import env variables
export $(grep -v '^#' .env | xargs)

## Initial configuration
echo Initial configuration

echo   - Create directories
mkdir -p $DOCKERDIR/shared

echo   - Create symbolic links for '.env'
for DIR in $(pwd)/services/*; do ln -s $(pwd)/.env $DIR/.env; done

## Traefik2
echo Traefik
TRAEFIKDIR=$DOCKERDIR/services/traefik2

echo   - Create directories
mkdir -p $TRAEFIKDIR/acme
mkdir -p $TRAEFIKDIR/rules
mkdir -p $TRAEFIKDIR/logs

echo   - Create file 'acme.json' and set permissions to 600
touch $TRAEFIKDIR/acme/acme.json
chmod 600 $TRAEFIKDIR/acme/acme.json

echo   - Create files 'access.log' and 'traefik.log'
touch $TRAEFIKDIR/logs/access.log
touch $TRAEFIKDIR/logs/traefik.log