#!/bin/sh
set -eu

CONFIG_FILE="${SYNCTHING_CONFIG_FILE:-/config/config.xml}"
LIBRARIUM_ROOT="${HEX_LIBRARIUM:-/hex/librarium}"
LISTEN_PORT="${SYNCTHING_LISTEN_PORT:-22300}"
GUI_ADDRESS="${SYNCTHING_GUI_ADDRESS:-0.0.0.0:8384}"
FOLDER_ID="${SYNCTHING_FOLDER_ID:-hex-librarium}"
FOLDER_LABEL="${SYNCTHING_FOLDER_LABEL:-Hex Librarium}"

mkdir -p "$LIBRARIUM_ROOT"

if [ -f "$CONFIG_FILE" ]; then
  printf 'Using existing Syncthing config at %s\n' "$CONFIG_FILE"
  exit 0
fi

syncthing generate --home=/config >/dev/null

xmlstarlet ed -L \
  -u "/configuration/gui/address" -v "$GUI_ADDRESS" \
  -u "/configuration/options/globalAnnounceEnabled" -v "false" \
  -u "/configuration/options/localAnnounceEnabled" -v "false" \
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

printf 'Generated Syncthing config at %s with folder %s at %s, GUI %s, sync port %s, discovery disabled\n' "$CONFIG_FILE" "$FOLDER_ID" "$LIBRARIUM_ROOT" "$GUI_ADDRESS" "$LISTEN_PORT"
