# Hex Librarium Syncthing

[![Publish](https://img.shields.io/github/actions/workflow/status/HEM-Labs/hex-librarium-syncthing/publish.yml?branch=master&label=publish)](https://github.com/HEM-Labs/hex-librarium-syncthing/actions/workflows/publish.yml)
[![GitHub Tag](https://img.shields.io/github/v/tag/HEM-Labs/hex-librarium-syncthing?label=version)](https://github.com/HEM-Labs/hex-librarium-syncthing/tags)
[![GitHub License](https://img.shields.io/github/license/HEM-Labs/hex-librarium-syncthing)](LICENSE)
[![GHCR Image](https://img.shields.io/badge/GHCR-hex--librarium--syncthing-2496ED?logo=github)](https://github.com/HEM-Labs/hex-librarium-syncthing/pkgs/container/hex-librarium-syncthing)

Syncthing wrapper for syncing the shared Hex Librarium Docker volume between machines.

The compose stack runs `librarium-init` before Syncthing so a newly created shared volume has the canonical Librarium directory structure before syncing starts.

The image seeds Syncthing config only when `/config/config.xml` does not exist inside the container. By default, that container path is backed by the project-local `./syncthing-config` directory. Existing config is treated as user-owned runtime state and is left untouched.

## Contract

- Synced volume: `hex-librarium`
- Container mount path: `/hex/librarium`
- Syncthing config container path: `/config`
- Default project-local config directory: `./syncthing-config`
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

Syncthing reads and writes config at `/config` inside the container. In the default compose setup, that path is mounted from the project-local `./syncthing-config` directory.

The `./syncthing-config` directory is checked in as a placeholder, but its generated contents are ignored because they contain runtime state and Syncthing device identity.

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

Versioned images are published as:

```text
ghcr.io/hem-labs/hex-librarium-syncthing:x.y.z
ghcr.io/hem-labs/hex-librarium-syncthing:x.y
```

Build locally:

```sh
task build
```

Override the image name:

```sh
LIBRARIUM_SYNCTHING_IMAGE=ghcr.io/your-org/hex-librarium-syncthing:dev task build
```

## Release

Update `CHANGELOG.md` with a release entry, then run the `Publish Librarium Syncthing Image` workflow from `master` with the target version.

The workflow updates `VERSION`, commits the release metadata, tags that commit as `vX.Y.Z`, and publishes the corresponding container image.
