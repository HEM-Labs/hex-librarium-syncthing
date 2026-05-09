#!/bin/sh
set -eu

CONFIG_FILE="${SYNCTHING_CONFIG_FILE:-/config/config.xml}"
LIBRARIUM_ROOT="${HEX_LIBRARIUM:-/hex/librarium}"
DEVICE_NAME="${SYNCTHING_DEVICE_NAME:-hex-librarium-syncthing}"
LISTEN_PORT="${SYNCTHING_LISTEN_PORT:-22300}"
FOLDER_ID="${SYNCTHING_FOLDER_ID:-hex-librarium}"
FOLDER_LABEL="${SYNCTHING_FOLDER_LABEL:-Hex Librarium}"

mkdir -p "$LIBRARIUM_ROOT"

if [ -f "$CONFIG_FILE" ]; then
  printf 'Using existing Syncthing config at %s\n' "$CONFIG_FILE"
  exit 0
fi

syncthing generate --home=/config >/dev/null

xmlstarlet ed -L \
  -d "/configuration/device[1]/@name" \
  -i "/configuration/device[1]" -t attr -n "name" -v "$DEVICE_NAME" \
  -u "/configuration/options/globalAnnounceEnabled" -v "false" \
  -u "/configuration/options/localAnnounceEnabled" -v "false" \
  -u "/configuration/options/relaysEnabled" -v "false" \
  -u "/configuration/options/natEnabled" -v "false" \
  -d "/configuration/options/listenAddress" \
  -s "/configuration/options" -t elem -n "listenAddress" -v "tcp://0.0.0.0:${LISTEN_PORT}" \
  -s "/configuration/options" -t elem -n "listenAddress" -v "quic://0.0.0.0:${LISTEN_PORT}" \
  "$CONFIG_FILE"

xmlstarlet ed -L \
  -d "/configuration/folder[@id='default']" \
  -s "/configuration" -t elem -n "folder" -v "" \
  -i "/configuration/folder[last()]" -t attr -n "id" -v "$FOLDER_ID" \
  -i "/configuration/folder[last()]" -t attr -n "label" -v "$FOLDER_LABEL" \
  -i "/configuration/folder[last()]" -t attr -n "path" -v "$LIBRARIUM_ROOT" \
  -i "/configuration/folder[last()]" -t attr -n "type" -v "sendreceive" \
  -i "/configuration/folder[last()]" -t attr -n "rescanIntervalS" -v "3600" \
  -i "/configuration/folder[last()]" -t attr -n "fsWatcherEnabled" -v "true" \
  "$CONFIG_FILE"

printf 'Generated Syncthing config at %s for device %s with folder %s at %s, sync port %s, discovery and relays disabled\n' "$CONFIG_FILE" "$DEVICE_NAME" "$FOLDER_ID" "$LIBRARIUM_ROOT" "$LISTEN_PORT"
