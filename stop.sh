#!/bin/bash

PROXYNAME=traefik2
INITDIR=$(pwd)
TARGETDIR=$(pwd)/services/$1

if [ "$1" = "all" ]; then
  # Stop all other services
  for DIR in $(pwd)/services/*; do
    if [ "$(basename $DIR)" != "$PROXYNAME" ]; then
      echo Stop $(basename $DIR) service
      cd $DIR
      docker compose down
      cd $INITDIR
    fi
    # Stop the proxy as last step
    echo Stop $traefik2 proxy
    cd services/$PROXYNAME
    docker compose down
    cd $INITDIR
  done
# Specified service does not exist
elif [ -d "$TARGETDIR" ]; then
  cd $TARGETDIR
  docker compose down
  cd $INITDIR
else
  echo "Service '$1' does not exist."
fi
