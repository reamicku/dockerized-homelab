#!/bin/bash

INITDIR=$(pwd)
TARGETDIR=$(pwd)/services/$1

if [ "$1" = "all" ];
then
  for DIR in $(pwd)/services/*; do cd $DIR; docker compose up -d; docker compose down; cd $INITDIR; done
elif [ -d "$TARGETDIR" ];
then
  cd $TARGETDIR
  docker compose down
  docker compose up -d
  cd $INITDIR
else
  echo "Service '$1' does not exist."
fi