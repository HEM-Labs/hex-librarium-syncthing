# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

---

## [0.2.1] - 2026-05-09

### Fixed

- Ensure the `.stfolder` marker exists before startup so fresh Librarium volumes can complete the initial scan.

---

## [0.2.0] - 2026-05-09

### Added

- Added third-party notices for Syncthing and the LinuxServer.io Syncthing image.
- Documented why Syncthing runs in privileged mode in the container.

### Changed

- Renamed interactive and service commands to `run`, `start`, and `stop`.
- Restored the LinuxServer.io default Syncthing GUI container port, `8384/tcp`, and mapped the project default host port `18384/tcp` to it.

---

## [0.1.0] - 2026-05-08

### Added

- Initial Syncthing wrapper for syncing the shared Hex Librarium Docker volume.
