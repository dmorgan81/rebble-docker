#!/bin/sh

VERSIONS=(3.0 3.1 3.10 3.10.1 3.11 3.11.1 3.12 3.13 3.13.1 3.14 3.2.1 3.3 3.4 3.6.2 3.7 3.8 3.8.1 3.8.2 3.9 3.9.2 4.0.1 4.1 4.1.1 4.1.2 4.1.4 4.2 4.2.1 4.2.2 4.3)

for version in "${VERSIONS[@]}"; do
    docker build -t dmorgan81/rebble:$version --build-arg SDK_VERSION=$version .
    docker push dmorgan81/rebble:$version
done

docker tag dmorgan81/rebble:4.3 dmorgan81/rebble:latest
docker push dmorgan81/rebble:latest
