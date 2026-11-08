#!/bin/sh
set -e

# ── 参数：按 panel → token → id 顺序 ──
PANEL_URL="${1:-${PANEL_URL:-}}"
MACHINE_TOKEN="${2:-${MACHINE_TOKEN:-}}"
MACHINE_ID="${3:-${MACHINE_ID:-}}"

if [ -z "$PANEL_URL" ] || [ -z "$MACHINE_TOKEN" ] || [ -z "$MACHINE_ID" ]; then
  echo "usage: sh install.sh <panel_url> <machine_token> <machine_id>"
  exit 1
fi

INSTALL_DIR="${INSTALL_DIR:-/usr/lib/kworker}"
BIN_NAME="${BIN_NAME:-kworker}"
SVC_NAME="${SVC_NAME:-kworker}"
REPO_BASE="${REPO_BASE:-https://github.com/cedar2025/xboard-node/releases/latest/download}"

# ── 架构检测 ──
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  BIN_ARCH="amd64" ;;
  aarch64) BIN_ARCH="arm64" ;;
  *) echo "unsupported arch: $ARCH"; exit 1 ;;
esac

# ── 下载二进制到目标目录的临时名，成功后 mv 成正式名 ──
mkdir -p "$INSTALL_DIR"
TMP_BIN="${INSTALL_DIR}/.${BIN_NAME}.download"
cleanup() { rm -f "$TMP_BIN"; }
trap cleanup EXIT INT TERM

echo "Downloading xboard-node-linux-${BIN_ARCH} ..."
curl -fsSL "${REPO_BASE}/xboard-node-linux-${BIN_ARCH}" -o "$TMP_BIN"
chmod +x "$TMP_BIN"
mv -f "$TMP_BIN" "${INSTALL_DIR}/${BIN_NAME}"
trap - EXIT INT TERM

# ── 生成配置文件 ──
cat > "${INSTALL_DIR}/config.yml" <<EOF
instances:
  - panel:
      url: "${PANEL_URL}"
    machine:
      machine_id: ${MACHINE_ID}
      token: "${MACHINE_TOKEN}"
EOF
chmod 600 "${INSTALL_DIR}/config.yml"

# ── 写 OpenRC 服务 ──
cat > "/etc/init.d/${SVC_NAME}" <<EOF
#!/sbin/openrc-run

name="${SVC_NAME}"
description="Kernel worker"
command="${INSTALL_DIR}/${BIN_NAME}"
command_args="-c ${INSTALL_DIR}/config.yml"
command_user="root"
command_background="yes"
pidfile="/run/${SVC_NAME}.pid"

depend() {
    need net
}
EOF
chmod +x "/etc/init.d/${SVC_NAME}"

# ── 启动并设开机自启 ──
rc-service "$SVC_NAME" stop 2>/dev/null || true
rc-service "$SVC_NAME" start
rc-update add "$SVC_NAME" default

echo "Done. Service: ${SVC_NAME}"
echo "Check: rc-service ${SVC_NAME} status && ps -o pid,comm,args -C ${SVC_NAME}"
