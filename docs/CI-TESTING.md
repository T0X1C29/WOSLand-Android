# CI testing

WOSLand-Android uses GitHub Actions to validate the deployment toolkit without
connecting to a phone, Discord, or any personal credentials.

## What CI runs

The `Android validation` workflow runs on pull requests targeting `master`,
pushes to `master`, and manual dispatch. It includes separate jobs for:

- POSIX and Bash syntax checks.
- Pinned ShellCheck (`koalaman/shellcheck-alpine:v0.10.0`).
- The repository's POSIX test harness.
- Simulated Android/Termux architecture and API detection.
- Installer preflight rejection for wrong Python, missing wheelhouses, and
  partial-install prevention.
- Watchdog stale-lock and stop-marker behavior.
- Static dependency and upstream commit checks.
- Secret-pattern and private-file checks.

The workflow publishes a job summary with the test count and uploads only
non-sensitive failure logs.

## Local checks

On a Linux or Termux shell:

```sh
sh tests/shell-tests.sh
sh tests/android-simulation.sh
sh tests/installer-preflight.sh
sh tests/watchdog-simulation.sh
```

ShellCheck can be run with the same pinned container used by CI:

```sh
docker run --rm -v "$PWD:/mnt" koalaman/shellcheck-alpine:v0.10.0 \
  shellcheck -x /mnt/scripts/*.sh
```

## What CI cannot prove

CI runs on Linux hosted infrastructure. It does not prove Android background
behavior, Termux:Boot persistence, ARM64 native wheel availability, OCR model
inference on a particular phone, Discord authentication, gift-code API access,
or production resource usage. Those results must be reported separately using
the [community device test template](community-device-test.md).

Ubuntu x86_64 CI is not an ARM64 or Android substitute. The Moto G 5G (2025)
remains the only physically verified deployment in this project.

## Reporting failures

Open an issue with the workflow URL, failing job, commit, Android architecture,
Python version, Debian/proot version, and sanitized diagnostics. Never attach
tokens, databases, backups, private logs, or personal device identifiers.
