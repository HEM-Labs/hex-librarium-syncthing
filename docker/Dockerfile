FROM lscr.io/linuxserver/syncthing:latest

RUN apk add --no-cache xmlstarlet

COPY configure-librarium-syncthing.sh /custom-cont-init.d/10-configure-librarium-syncthing

RUN chmod +x /custom-cont-init.d/10-configure-librarium-syncthing

ENV HEX_LIBRARIUM=/hex/librarium \
    SYNCTHING_DEVICE_NAME=hex-librarium-syncthing \
    SYNCTHING_LISTEN_PORT=22300 \
    SYNCTHING_FOLDER_ID=hex-librarium \
    SYNCTHING_FOLDER_LABEL="Hex Librarium"

EXPOSE 8384/tcp 22300/tcp 22300/udp
