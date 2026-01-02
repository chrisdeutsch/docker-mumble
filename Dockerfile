# Build stage
FROM debian:bookworm-slim@sha256:d5d3f9c23164ea16f31852f95bd5959aad1c5e854332fe00f7b3a20fcc9f635c AS build

# renovate: datasource=github-releases depName=mumble packageName=mumble-voip/mumble
ARG MUMBLE_VERSION=v1.5.857

ARG DEBIAN_FRONTEND=noninteractive

RUN : \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        g++-multilib \
        libasound2-dev \
        libavahi-compat-libdnssd-dev \
        libboost-dev \
        libcap-dev \
        libogg-dev \
        libpoco-dev \
        libprotobuf-dev \
        libprotoc-dev \
        libqt5svg5-dev \
        libsndfile1-dev \
        libspeechd-dev \
        libssl-dev \
        libxi-dev \
        pkg-config \
        protobuf-compiler \
        qtbase5-dev \
        qttools5-dev \
        qttools5-dev-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/mumble
RUN : \
    && curl -L -o mumble.tar.gz "https://github.com/mumble-voip/mumble/releases/download/${MUMBLE_VERSION}/mumble-${MUMBLE_VERSION#'v'}.tar.gz" \
    && tar -xf mumble.tar.gz

WORKDIR /root/mumble/build
RUN : \
    && cmake \
       -Dclient=OFF \
       -Dice=OFF \
       -DCMAKE_BUILD_TYPE=Release \
       /root/mumble/mumble-* \
    && make -j1

# Distribution stage
FROM debian:bookworm-slim@sha256:d5d3f9c23164ea16f31852f95bd5959aad1c5e854332fe00f7b3a20fcc9f635c

ADD ./LICENSE /licenses/LICENSE
ADD ./LICENSE_MUMBLE /licenses/LICENSE_MUMBLE

ARG DEBIAN_FRONTEND=noninteractive

RUN : \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        libprotobuf32 \
        libavahi-compat-libdnssd1 \
        libcap2 \
        libqt5core5a \
        libqt5network5 \
        libqt5sql5 \
        libqt5sql5-mysql \
        libqt5sql5-psql \
        libqt5sql5-sqlite \
        libqt5xml5 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /root/mumble/build/mumble-server /usr/bin/mumble-server
COPY --from=build /root/mumble/build/mumble-server.ini /etc/murmur/mumble-server.ini

RUN : \
    && groupadd --gid 1000 mumble-server \
    && useradd --gid 1000 --uid 1000 mumble-server \
    && install -d -o mumble-server -g mumble-server /config /data

USER mumble-server
EXPOSE 64738/tcp 64738/udp

ADD ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["mumble-server", "-v", "-fg", "-ini", "/config/mumble-server.ini"]
