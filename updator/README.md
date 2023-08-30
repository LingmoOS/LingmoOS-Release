# CuteOS 更新

CuteOS系统更新工具。

## 依赖包

Debian/Ubuntu 依赖包:
```shell
sudo apt install cmake libqapt-dev
```

## 构建

```shell
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..
make
sudo make install
```

## License

This project has been licensed by GPLv3.
