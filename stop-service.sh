#!/bin/bash

INITDIR=$(pwd)
TARGETDIR=$(pwd)/services/$1

if [ -d "$TARGETDIR" ];
then
  cd $TARGETDIR
  docker compose down
  cd $INITDIR
else
  echo "Service '$1' does not exist."
fi