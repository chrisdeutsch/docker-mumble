# docker-mumble

A containerized version of the Mumble VoIP server.

## Docker Compose

An exemplary `docker-compose.yml` is shown below:

```yaml
---
version: "3"
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