# OBS Studio plugin development environment

This repository helps to create an environment to develop OBS Studio plugins.
Main target is Github Actions.

## Github workflow

See action.yml.

## Standalone
To run the script from a terminal, checkout this repository somewhere and run the script directly.

For Linux
```
../obs-studio-devel-action/scripts/linux-download.sh -a -o 28
```

For macOS
```
../obs-studio-devel-action/scripts/macos-download.sh -a x86_64 -o 28 -d /tmp/obs-deps-28-x86_64
```
