FROM ubuntu:18.04

RUN apt-get update && \
        apt-get install -y wget python-pip python2.7-dev libsdl1.2debian libfdt1 libpixman-1-0 nodejs npm libfreetype6 libx11-6 rlwrap && \
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

ARG SDK_VERSION
ENV SDK_VERSION ${SDK_VERSION:-4.3}

RUN mkdir /sdk/.pebble-sdk && \
        touch /sdk/.pebble-sdk/NO_TRACKING && \
        /bin/bash -c "yes | /sdk/bin/pebble sdk install https://github.com/aveao/PebbleArchive/raw/master/SDKCores/sdk-core-${SDK_VERSION}.tar.bz2"

RUN wget -q -O - https://raw.githubusercontent.com/imomaliev/bash-repl/master/bin/shrepl | \
        sed -e 's/rlargs=""/rlargs="-b []"/' > /sdk/bin/shrepl && \
        chmod +x /sdk/bin/shrepl && \
        mkdir /sdk/.repl

COPY rebble /sdk/bin/
COPY pebble.repl /sdk/.repl/pebble

WORKDIR "/work"
ENTRYPOINT ["/sdk/bin/rebble"]
