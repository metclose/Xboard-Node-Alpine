# Xboard-Node-Alpine

在 Alpine Linux 上一键部署 xboard-node（machine 模式），自动完成下载二进制、创建目录、生成配置、写入 OpenRC 服务并设置开机自启。

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/metclose/Xboard-Node-Alpine/main/install.sh | \
  sh -s -- 'https://你的面板地址' '你的machine-token' 你的machine-id
