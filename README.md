# WOSLand on Android (Termux + Debian proot)

Reusable deployment notes for the official Python Whiteout Survival Discord Bot.
The upstream source remains the source of truth and is not redistributed here.

Upstream: https://github.com/whiteout-project/bot
Validated release: v2.1.3, commit `e7a453088575b4cd00affca307fb3c9814f9e763`.

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

Use one supervisor only. The tested deployment uses a foreground Debian-proot
launch, a 15-second restart delay, a duplicate-instance lock, and a Termux:Boot
launcher with a bounded delay. Keep disabled service directories outside runit’s
watch directory. A real Android reboot is required before claiming reboot
persistence.

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

