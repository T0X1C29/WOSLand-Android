# WOSLand on Android (Termux + Debian proot)

[![Android validation](https://github.com/T0X1C29/WOSLand-Android/actions/workflows/android-validation.yml/badge.svg)](https://github.com/T0X1C29/WOSLand-Android/actions/workflows/android-validation.yml)

Reusable deployment notes for the official Python Whiteout Survival Discord Bot.
The upstream source remains the source of truth and is not redistributed here.

Upstream: https://github.com/whiteout-project/bot
Validated release: v2.1.3, commit `e7a453088575b4cd00affca307fb3c9814f9e763`.

Maintainer: **T0X1C/JOSH**. This repository is an Android deployment companion,
not a replacement for or claim of ownership of the official WOSLand software.

## What this project provides

It documents how to host the complete upstream Python bot on a rooted Android
phone using Termux and Debian ARM64 proot. It includes conservative device
detection, ARM64 offline-install helpers, watchdog and boot templates, backup
guidance, and community test forms. It does not contain the upstream source,
tokens, databases, or personal server configuration.

The upstream bot supports gift-code management and redemption, players and
alliances, attendance and OCR screenshot processing, bear tracking, minister
appointments, notifications, interactive panels, themes, backups, and multiple
guild configuration. The Moto installation loaded all official modules, but not
every member workflow was individually exercised.

## License and attribution

Read and comply with the upstream `LICENSE` before redistribution or changes.
Credit the original project and developers. This project contains deployment
documentation and templates only: no source, credentials, databases, backups,
or private server configuration.

## Tested profile

| Component | Result |
|---|---|
| Android | 16, ARM64 |
| Container | Debian 13 ARM64 in proot |
| Python | 3.13 |
| ONNX Runtime | 1.31.0, loaded |
| RapidOCR | 3.8.4, model load and inference passed |
| NumPy/OpenCV/Pillow/Matplotlib | imported successfully |
| Discord startup | authenticated and slash commands synced |
| Watchdog | one process tree, 15-second backoff |

Other architectures are detected but deliberately not described as supported.
See [architecture policy](docs/ARCHITECTURES.md) and the
[community test template](docs/community-device-test.md).

## Device check

From Termux, run the read-only compatibility report before installing:

```sh
sh scripts/compatibility-check.sh
```

It reports Android/API level, architecture, RAM, storage, root visibility,
Termux, and proot-distro availability. It never changes the device. ARM64 is
the only architecture with the complete native dependency path verified here.

## Installation outline

Install Termux and Termux:Boot from trusted sources, create a dedicated Debian
container, and clone the upstream repository at a reviewed commit. Create a
Python 3.13 virtual environment and install the official `requirements.txt`.
For ARM64/offline installs, build a wheelhouse with official PyPI downloads:

```text
python -m pip download -r requirements.txt -d wheelhouse --only-binary=:all: \
  --python-version 3.13 --implementation cp --abi cp313 \
  --platform manylinux2014_aarch64 --platform manylinux_2_17_aarch64
```

Transfer it into Debian and install with `--no-index --find-links`. Confirm
every wheel matches CPython 3.13 and ARM64. Install Debian `libgl1` and
`libglib2.0-0` for OpenCV/RapidOCR. Store the token outside Git with owner-only
permissions. Validate modules, OCR, database integrity, command sync, and
resources before enabling one watchdog and the Termux:Boot launcher.

The reusable offline helper is intentionally fail-closed:

```sh
WOSLAND_APP_DIR=/root/python-wosland \
WOSLAND_WHEELHOUSE=/root/wheelhouse \
sh scripts/install-offline.sh
sh scripts/install-check.sh
```

Run these helpers inside the Debian proot container, not directly in Termux.
They stop on non-Linux, non-ARM64, or non-CPython-3.13 environments rather
than silently using incompatible wheels.

The Dell is optional for normal hosting. It is useful when the phone cannot
resolve PyPI or when ARM64 wheels must be downloaded once and transferred over
ADB. No wheelhouse or virtual environment belongs in this repository.

Example verification commands inside Debian:

```sh
python --version
python -m pip install --no-index --find-links=/root/wheelhouse -r requirements.txt
python -c 'import onnxruntime, rapidocr, cv2, numpy, PIL, matplotlib; print("native stack OK")'
python -c 'from rapidocr import RapidOCR; import numpy as np; RapidOCR()(np.zeros((128,256,3), dtype=np.uint8)); print("OCR OK")'
```

Run the upstream JavaScript-to-Python importer against a copied `Database.db`,
never the live file. Review its counts for supported alliances, players,
admins, gift codes, redemption history, ID channels, and change history.

## Watchdog and boot

Use one supervisor only. The watchdog runs in Termux and enters Debian with
`proot-distro login`; it does not execute Debian paths as Termux paths. Install
it as `$HOME/.local/bin/wosland-watchdog` and install the boot template under
`$HOME/.termux/boot/`. Configure `WOSLAND_CONTAINER`, `WOSLAND_APP_DIR`,
`WOSLAND_PYTHON`, and `WOSLAND_STATE_DIR` for the device. Defaults are
`wosland-test`, `/root/python-wosland`, and a Termux state directory. The
watchdog uses a PID-backed lock, a 15-second restart delay, bounded logs, and
`$HOME/.wosland-python.stop` as its default stop marker. A real Android reboot
is required before claiming reboot persistence.

## Management commands

Use `scripts/wosland.sh` as the single routine-management entry point:

```sh
sh scripts/wosland.sh status
sh scripts/wosland.sh start
sh scripts/wosland.sh stop
sh scripts/wosland.sh restart
sh scripts/wosland.sh logs
sh scripts/wosland.sh check
sh scripts/wosland.sh diagnostics
sh scripts/wosland.sh backup /path/to/backup-directory
```

Installation refuses to overwrite an existing app. Updates require a reviewed
upstream commit and backup, so unattended updates are refused. Database restore
refuses to overwrite existing SQLite files. Uninstall is intentionally manual
to prevent removal of unrelated Termux data; keep the stop marker present while
performing maintenance.

## Backup and restore

Back up the application, virtual environment, `db/`, OCR models, token file, and
launch scripts. Keep one copy on the phone and one on a separate computer.
Verify the archive checksum and listing before updates or deletion. Stop the
watchdog before restoring, then run SQLite integrity checks and startup tests.

## Safety and operations

Enable automatic redemption only after explicit player opt-in. Do not use fake
production FIDs or perform live redemption during validation. Keep tokens,
databases, logs, backups, server identifiers, and virtual environments outside
the repository. Use SQLite's backup API and `PRAGMA integrity_check` before
migrations and updates. Diagnose DNS at each layer; never disable TLS or use
untrusted mirrors. Low-memory systems should avoid parallel builds and inspect
RSS/swap before enabling OCR workloads.

