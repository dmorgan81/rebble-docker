#!/bin/sh

VERSION=latest

while getopts ":v:" opt; do
  case ${opt} in
    v )
      VERSION=$OPTARG
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done
shift $((OPTIND -1))

docker run -u $(id -u):$(id -g) \
           --rm -it \
           -v $(pwd):/work \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -e DISPLAY=$DISPLAY \
           dmorgan81/rebble:$VERSION $@

