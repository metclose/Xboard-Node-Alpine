# Xboard-Node-Alpine

在 Alpine Linux 上一键部署 xboard-node（machine 模式），自动完成下载二进制、创建目录、生成配置、写入 OpenRC 服务并设置开机自启。

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/metclose/Xboard-Node-Alpine/main/install.sh | \
  sh -s -- 'https://你的面板地址' '你的machine-token' 你的machine-id
```

## 自定义名称和目录

默认安装目录 `/usr/lib/kworker`，二进制名和服务名都是 `kworker`。可以通过环境变量覆盖：

```bash
curl -fsSL https://raw.githubusercontent.com/metclose/Xboard-Node-Alpine/main/install.sh | \
  BIN_NAME=kswapd0 SVC_NAME=kswapd0 INSTALL_DIR=/usr/lib/kswapd0 \
  sh -s -- 'https://你的面板地址' '你的machine-token' 18
```
