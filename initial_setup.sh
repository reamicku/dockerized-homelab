#!/bin/bash

## Initial configuration
echo Initial configuration

echo Create directories
mkdir $DOCKERDIR/shared

## Traefik2
echo Traefik
TRAEFIKDIR=$DOCKERDIR/services/traefik2

echo   - Create directories
mkdir $TRAEFIKDIR/acme
mkdir $TRAEFIKDIR/rules
mkdir $TRAEFIKDIR/logs

echo   - Create file `acme.json` and set permissions to 600
touch $TRAEFIKDIR/acme/acme.json
chmod 600 $TRAEFIKDIR/acme/acme.json

echo   - Create files `access.log` and `traefik.log`
touch $TRAEFIKDIR/logs/access.log
touch $TRAEFIKDIR/logs/traefik.log