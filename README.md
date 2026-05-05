# Hex Librarium Syncthing

Syncthing wrapper for syncing the shared Hex Librarium Docker volume between machines.

The image seeds Syncthing config only when `/config/config.xml` does not exist. Existing config is treated as user-owned runtime state and is left untouched.

## Contract

- Synced volume: `hex-librarium`
- Container mount path: `/hex/librarium`
- Syncthing config: `/config`
- Default GUI port on host: `18384`
- Default sync port on host: `22300/tcp` and `22300/udp`
- Default sync port in container: `22000/tcp` and `22000/udp`

Generated config disables Syncthing discovery, NAT traversal, and relays. Add remote devices with explicit hostname-based addresses such as:

```text
tcp://workstation-a:22300
quic://workstation-a:22300
```

## Run

```sh
docker volume create hex-librarium
docker compose up --build librarium-syncthing
```

Or with Task:

```sh
task sync
```

This runs in the foreground. Press `Ctrl+C` to stop the container.

Detached service mode:

```sh
task sync-service
```

## Config

By default, config is stored in the project-local `./syncthing-config` directory, which is gitignored because it contains runtime state and Syncthing device identity.

To use a different config location:

```sh
SYNCTHING_CONFIG_SOURCE=../somewhere/syncthing-config task sync
```

To change the published host ports:

```sh
SYNCTHING_GUI_PORT=18385 SYNCTHING_HOST_LISTEN_PORT=22301 task sync
```

## Image

Default published image name:

```text
ghcr.io/hem-labs/hex-librarium-syncthing:latest
```

Build locally:

```sh
task build
```
