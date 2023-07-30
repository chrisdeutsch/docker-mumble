#!/usr/bin/env bash

if [[ ! -f /config/murmur.ini ]]; then
    sed \
        's|^database=.*$|database=/data/mumble-server.sqlite|' \
        /etc/murmur/murmur.ini \
        > /config/murmur.ini
fi

exec "$@"
