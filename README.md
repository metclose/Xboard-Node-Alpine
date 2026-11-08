# Xboard-Node-Alpine

- 在 Alpine Linux 上一键部署 Xboard-Node，官方的 Xboard-Node 一键命令不支持 Alpine，于是写个专属 Alpine 的脚本。

## 脚本做了什么

- 从官方 Xboard-Node 仓库下载对应架构的二进制文件。
- 生成官方格式的 `config.yml`（面板地址、机器 Token、机器 ID）。
- 写入 OpenRC 服务脚本，启动服务并设置开机自启。

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/metclose/Xboard-Node-Alpine/main/install.sh | \
  sh -s -- 'https://你的面板地址' '你的machine-token' 你的machine-id
```

## 自定义名称和目录（可选）

- 脚本一键安装提供隐藏 Xboard-Node 名称的功能，并且默认已开启，默认安装目录为 `/usr/lib/kworker`，二进制名和服务名都是 `kworker`。
- 若想自定义名称和目录，可以通过环境变量覆盖：

```bash
curl -fsSL https://raw.githubusercontent.com/metclose/Xboard-Node-Alpine/main/install.sh | \
  BIN_NAME=自定义二进制名 SVC_NAME=自定义服务名 INSTALL_DIR=自定义目录 \
  sh -s -- 'https://你的面板地址' '你的machine-token' 你的machine-id
```
