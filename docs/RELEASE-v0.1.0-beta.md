# v0.1.0-beta release notes

This beta packages the Android deployment companion for the official Python
WOSLand bot. It provides compatibility detection, pinned-source retrieval,
online/offline ARM64 dependency helpers, a single-instance Termux watchdog,
Termux:Boot integration, backups, health checks, management commands, and
simulation-based CI.

## Verified

- Moto G 5G (2025), Android 16, ARM64, Debian ARM64 proot, CPython 3.13.
- ONNX Runtime, RapidOCR, NumPy, OpenCV, Pillow, and Matplotlib imported on
  the documented deployment.
- GitHub Actions shell, ShellCheck, policy, privacy, and simulation checks.

## Not claimed by this beta

The CI does not emulate Discord, live gift-code redemption, OCR inference, or
physical Android hardware. Reboot persistence and other devices require an
independent community report. The upstream bot source is not redistributed;
users fetch the pinned upstream commit themselves.
