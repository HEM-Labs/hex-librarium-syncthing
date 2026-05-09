# Hex Librarium Syncthing

[![Publish](https://img.shields.io/github/actions/workflow/status/HEM-Labs/hex-librarium-syncthing/publish.yml?branch=master&label=publish)](https://github.com/HEM-Labs/hex-librarium-syncthing/actions/workflows/publish.yml)
[![GitHub Tag](https://img.shields.io/github/v/tag/HEM-Labs/hex-librarium-syncthing?label=version)](https://github.com/HEM-Labs/hex-librarium-syncthing/tags)
[![GitHub License](https://img.shields.io/github/license/HEM-Labs/hex-librarium-syncthing)](LICENSE)
[![GHCR Image](https://img.shields.io/badge/GHCR-hex--librarium--syncthing-2496ED?logo=github)](https://github.com/HEM-Labs/hex-librarium-syncthing/pkgs/container/hex-librarium-syncthing)

Syncthing wrapper for syncing the shared Hex Librarium Docker volume between machines.

This image packages Syncthing via the LinuxServer.io Syncthing container image. See [THIRD_PARTY.md](THIRD_PARTY.md) for upstream attribution.

The compose stack runs `librarium-init` before Syncthing so a newly created shared volume has the canonical Librarium directory structure before syncing starts.

The Syncthing wrapper also ensures the Syncthing folder marker exists at `/hex/librarium/.stfolder`. This marker is Syncthing-owned runtime metadata, not part of the Hex Librarium directory contract, and lets Syncthing safely attach to either a fresh Librarium volume or an existing one.

The image seeds Syncthing config only when `/config/config.xml` does not exist inside the container. By default, that container path is backed by the project-local `./syncthing-config` directory. Existing config is treated as user-owned runtime state and is left untouched.

## Contract

- Synced volume: `hex-librarium`
- Container mount path: `/hex/librarium`
- Syncthing config container path: `/config`
- Syncthing folder marker: `/hex/librarium/.stfolder`
- Default project-local config directory: `./syncthing-config`
- Default Syncthing device name: `hex-librarium-syncthing`
- Syncthing GUI container port: `8384/tcp`
- Default host GUI port: `18384/tcp`
- Default sync port: `22300/tcp` and `22300/udp`

Syncthing runs as `root:root` inside the container by default through `PUID=0` and `PGID=0`. See [Runtime Notes](#runtime-notes) for rationale.

Generated config disables Syncthing discovery, NAT traversal, and relays. Add remote devices with explicit hostname-based addresses such as:

```text
tcp://workstation-a:22300, quic://workstation-a:22300
```

## Runtime Notes

This image keeps the LinuxServer.io Syncthing runtime model intact where possible. Syncthing listens on `8384/tcp` inside the container, and `compose.yml` maps the project host default, `18384/tcp`, to that internal port. Treat Syncthing log URLs as container-local; from the host, use the configured host port.

The container runs as `root:root` by default because it writes to the shared `hex-librarium` Docker volume used by other Hex components. This avoids host-specific UID/GID coordination for the shared volume. This is container user configuration, not Docker `--privileged` mode. Only run this service in trusted private environments unless you deliberately harden the deployment.

Syncthing uses the folder marker to verify that the configured folder is present before scanning. Creating `.stfolder` in a fresh or existing Librarium volume matches what Syncthing creates when a folder is added through the web UI. Syncthing treats this marker as an internal file and does not sync it to other devices.

## Run

For end users on Windows, use the batch files to pull and run the published images:

```bat
run.bat
```

This runs Syncthing in the foreground. Press `Ctrl+C` to stop the container.

Detached service mode:

```bat
start.bat
```

Stop detached service mode:

```bat
stop.bat
```

The batch files use the same `compose.yml` as development, but run with `--no-build` so Docker uses the published GHCR images.

By default, the Syncthing GUI is available on the host at:

```text
http://localhost:18384/
```

## Develop

Install [Task](https://taskfile.dev/) and Docker, then run:

```sh
task run
```

This runs Syncthing in the foreground. Press `Ctrl+C` to stop the container.

Useful development commands:

```sh
task build
task start
task stop
task update
task version
```

Create the shared Librarium volume manually when needed:

```sh
task volume
```

## Config

Syncthing reads and writes config at `/config` inside the container. In the default compose setup, that path is mounted from the project-local `./syncthing-config` directory.

The `./syncthing-config` directory is checked in as a placeholder, but its generated contents are ignored because they contain runtime state and Syncthing device identity.

To use a different config location:

```sh
SYNCTHING_CONFIG_SOURCE=../somewhere/syncthing-config task run
```

To change the ports:

```sh
SYNCTHING_GUI_PORT=18385 SYNCTHING_LISTEN_PORT=22301 task run
```

`SYNCTHING_GUI_PORT` changes only the host-facing port. Inside the container, Syncthing keeps the LinuxServer.io default GUI port, `8384/tcp`, and the compose file maps the chosen host port to that internal port. Syncthing log messages may therefore mention `127.0.0.1:8384`; use the configured host port from outside the container.

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
