#!/bin/sh

docker run -u $(id -u):$(id -g) \
           --rm -it \
           -v $(pwd):/work \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -e DISPLAY=$DISPLAY \
           rebble $@

