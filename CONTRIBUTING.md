# Contributing

Contributions should improve Android deployment tooling without changing the
official WOSLand source. Keep scripts POSIX-compatible where possible, avoid
hard-coded personal paths, and add a simulation test for new safety behavior.

Before opening a pull request, run the commands in [CI testing](docs/CI-TESTING.md).
Never include tokens, databases, backups, virtual environments, or private logs.
Device reports should use `docs/community-device-test.md` and must distinguish
physical results from simulation.
