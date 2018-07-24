FROM ubuntu:18.04

RUN apt-get update && \
        apt-get install -y wget python-pip python2.7-dev libsdl1.2debian libfdt1 libpixman-1-0 nodejs npm libfreetype6 libx11-6 && \
        pip install virtualenv

RUN addgroup --gid 1000 rebble && \
        adduser --uid 1000 --ingroup rebble --home /sdk --disabled-password rebble

RUN wget -q -O - https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | \
        tar xz -C /usr/local/bin && \
        chmod 4755 /usr/local/bin/fixuid && \
        mkdir -p /etc/fixuid

COPY config.yml /etc/fixuid/

USER rebble:rebble
RUN wget -q -O - https://developer.rebble.io/s3.amazonaws.com/assets.getpebble.com/pebble-tool/pebble-sdk-4.5-linux64.tar.bz2 | \
        tar xj --strip-components=1 -C /sdk

RUN cd /sdk && \
        virtualenv --no-site-packages .env && \
        bash -c "source .env/bin/activate && \
        pip install -r requirements.txt && \
        deactivate"

RUN mkdir /sdk/.pebble-sdk && \
        touch /sdk/.pebble-sdk/NO_TRACKING && \
        /bin/bash -c "yes | /sdk/bin/pebble sdk install https://github.com/Spitemare/pebble-sdks/raw/master/sdk-core-4.3.tar.bz2"

COPY rebble /sdk/bin/

WORKDIR "/work"
ENTRYPOINT ["/sdk/bin/rebble"]
