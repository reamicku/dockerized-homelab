#!/bin/bash

PROXYNAME=traefik2
INITDIR=$(pwd)
TARGETDIR=$(pwd)/services/$1

if [ "$1" = "all" ]; then
  # Start up the proxy first
  cd services/$PROXYNAME
  docker compose up -d
  cd $INITDIR
  # Then enable rest of the services
  for DIR in $(pwd)/services/*; do
    if [ "$(basename $DIR)" != "$PROXYNAME" ]; then
      cd $DIR
      docker compose up -d
      cd $INITDIR
    fi
  done
# Specified service does not exist
elif [ -d "$TARGETDIR" ]; then
  cd $TARGETDIR
  docker compose up -d
  cd $INITDIR
else
  echo "Service '$1' does not exist."
fi
