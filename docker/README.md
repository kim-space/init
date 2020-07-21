## docker

本脚本用于 Ubuntu 下 Docker 初始化安装，目前仅支持 Ubuntu 18.04/20.04 系统；
默认情况下 Docker 配置调整通过 `docker.service` 文件完成，该文件将会被 systemd
复制到 `/etc/systemd/system/docker.service.d/override.conf`，后续调整请修改此
文件，**不建议直接修改默认的 `docker.service` 配置，这会导致升级后被覆盖**。本脚
本初始化完成后会锁定 Docker 版本，后续如需升级请执行 `apt-mark unhold PKG_NAME`。
