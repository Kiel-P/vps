#!/bin/bash
XRAY_VERSION="v25.12.8"
XRAY_URL="https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip"
WORKDIR=$(mktemp -d)

echo "[INFO] Install Xray $XRAY_VERSION"

cd "$WORKDIR"
wget -q "$XRAY_URL" -O xray.zip
unzip -q xray.zip

install -m 755 xray /usr/local/bin/xray
mkdir -p /usr/local/etc/xray /var/log/xray

cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [{
    "port": 443,
    "protocol": "vless",
    "settings": { "clients": [] },
    "streamSettings": {
      "network": "tcp",
      "security": "none"
    }
  }],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

rm -rf "$WORKDIR"
