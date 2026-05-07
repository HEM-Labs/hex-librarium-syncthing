# Hex Librarium Syncthing

Syncthing wrapper for syncing the shared Hex Librarium Docker volume between machines.

The compose stack runs `librarium-init` before Syncthing so a newly created shared volume has the canonical Librarium directory structure before syncing starts.

The image seeds Syncthing config only when `/config/config.xml` does not exist. Existing config is treated as user-owned runtime state and is left untouched.

## Contract

- Synced volume: `hex-librarium`
- Container mount path: `/hex/librarium`
- Syncthing config: `/config`
- Default Syncthing device name: `hex-librarium-syncthing`
- Default GUI port: `18384`
- Default sync port: `22300/tcp` and `22300/udp`

Generated config disables Syncthing discovery, NAT traversal, and relays. Add remote devices with explicit hostname-based addresses such as:

```text
tcp://workstation-a:22300, quic://workstation-a:22300
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

By default, config is stored in the project-local `./syncthing-config` directory. The directory is checked in as a placeholder, but its generated contents are ignored because they contain runtime state and Syncthing device identity.

To use a different config location:

```sh
SYNCTHING_CONFIG_SOURCE=../somewhere/syncthing-config task sync
```

To change the ports:

```sh
SYNCTHING_GUI_PORT=18385 SYNCTHING_LISTEN_PORT=22301 task sync
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
