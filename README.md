# docker-mumble

A containerized version of the Mumble VoIP server.

## Docker Compose

An exemplary `docker-compose.yml` is shown below:

```yaml
---
services:
  server:
    image: ghcr.io/chrisdeutsch/mumble-server:latest
    container_name: mumble-server
    restart: unless-stopped
    volumes:
      - ./config:/config
      - ./data:/data
    environment:
      - TZ=Europe/Berlin
    ports:
      - "64738:64738/tcp"
      - "64738:64738/udp"
```

## Configuration

On first start, a default `mumble-server.ini` is created in the `/config` volume. Edit this file to customize the server (e.g. set a password, server name, or max users) and restart the container to apply changes.

## Volumes

| Path | Description |
|---|---|
| `/config` | Server configuration (`mumble-server.ini`) |
| `/data` | Persistent data (SQLite database) |

## Ports

The server uses port **64738** for both TCP (control) and UDP (voice).
