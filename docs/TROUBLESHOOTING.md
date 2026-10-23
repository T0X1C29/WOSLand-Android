# Troubleshooting

## PyPI DNS or IPv6 failures

Compare DNS and HTTPS from Android, Termux, Debian, and Python. If HTTPS works
but pip cannot resolve PyPI, build the wheelhouse on another trusted machine and
transfer it with ADB. Do not disable TLS or use an untrusted mirror.

## ARM64 wheel errors

Confirm `python --version` is 3.13 and use `cp313` plus an ARM64 manylinux
platform. Do not install x86_64 wheels or silently omit native packages.

## ONNX Runtime or RapidOCR

Check that ONNX Runtime imports, that the RapidOCR model files exist, and that
Debian has `libgl1` and `libglib2.0-0`. A successful import alone is not an OCR
test; run the inference command from the README.

## proot and permissions

Use explicit rootfs and executable paths. Keep the application in its dedicated
container. Avoid recursive ownership changes and do not place disabled runit
directories under runit's watched service directory.

## Duplicate processes or restart loops

Use one watchdog, one lock, and a bounded restart delay. Inspect the process
tree before starting another copy. Stop the watchdog intentionally before
restoring a backup.

## Discord commands

Confirm the bot token is correct, the required gateway intents are enabled, and
the bot has been invited with the upstream-required scopes and permissions.
Global command propagation can take time; the startup log must show a successful
sync before treating registration as verified.

## Memory pressure

Avoid parallel builds. Measure RSS, free memory, and swap before OCR. The tested
Moto had roughly 3.6 GB RAM and used substantial swap while all workloads ran;
other devices may need more headroom.

