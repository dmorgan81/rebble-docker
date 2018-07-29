This is a docker image based off of Ubuntu 18.04 that contains a working build environment for Pebble projects. A Pebble SDK is installed and configured. Host-guest file permissions are handled by [fixuid](https://github.com/boxboat/fixuid/).

## Tags

The image tag is the version of the SDK that is installed. dmorgan81/rebble:latest will get you the 4.3 SDK since that was the last version of the SDK that was released.

## Running

rebble.sh should live somewhere in your PATH on your host machine. Now any pebble-tool command, other than SDK related commands, will be sent to the image and executed as though they were executed on the host machine. For example:

    rebble.sh clean && rebble.sh build

rebble.sh defaults to latest but you can specify a tag version instead:

    rebble.sh -v 4.2.2 build

## Emulator support

The QEMU emulator works as well with a few limitations.

1. You'll need to install with logs if you want the emulator to keep running, i.e. `rebble install --emulator basalt --logs`
2. The other emulator commands don't quite work because you need an emulator running but multiple instances of the container can't talk to an emulator running in one.

To workaround these limitations you can use the repl contained in the image.

### rebble shell

The image contains a repl based on [shrepl](https://github.com/imomaliev/bash-repl/blob/master/bin/shrepl) and [rlwrap](https://github.com/hanslub42/rlwrap). The repl wraps the pebble-tool command. `rebble.sh shell` will run the shell. Ctrl-C will stop it and return to the host.

The main advantage of rebble shell is that you can install to an emulator and then run other emulator commands. This also means the edit-build-install loop is possible using this image.
