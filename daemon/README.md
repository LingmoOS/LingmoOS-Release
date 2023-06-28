# CuteOS Daemon

[![Build](https://github.com/Cute-OS/daemon/actions/workflows/build.yml/badge.svg)](https://github.com/Cute-OS/daemon/actions/workflows/build.yml)

CuteOS backend

## Dependencies

Debian/Ubuntu Dependencies:

```shell
sudo apt install cmake libqapt-dev
```

## Build

```shell
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..
make
sudo make install
```

## License

This project has been licensed by GPLv3.
