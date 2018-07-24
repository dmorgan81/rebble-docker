This is a docker image based off of Ubuntu 18.04 that contains a working build environment for Pebble projects. It contains the Pebble 4.3 SDK installed and configured. Host-guest file permissions are handled by [fixuid](https://github.com/boxboat/fixuid/).

## Running

rebble.sh should live somewhere in your PATH on your host machine. Now any pebble-tool command, other than SDK related commands, will be sent to the image and executed as though they were executed on the host machine. For example:

    rebble.sh clean && rebble.sh build

## Emulator support

The QEMU emulator works as well with a few limitations.

1. You'll need to install with logs if you want the emulator to keep running, i.e. `rebble install --emulator basalt --logs`
2. The other emulator commands don't quite work because you need an emulator running but multiple instances of the container can't talk to an emulator running in one.

To workaround these limitations you can always change the image's entrypoint and work within the image as though you were working with just pebble-tool

    docker run -it --rm --entrypoint /bin/bash -v $(pwd):/work -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY rebble
