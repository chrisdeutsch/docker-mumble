#!/usr/bin/env bash
set -e

if [[ ! -f /config/mumble-server.ini ]]; then
    sed \
        's|^database=.*$|database=/data/mumble-server.sqlite|' \
        /etc/murmur/mumble-server.ini \
        > /config/mumble-server.ini
fi

exec "$@"
