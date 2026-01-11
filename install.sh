#!/bin/bash
set -e

echo "🚀 Installing ZIVPN UDP..."

# ===== BASIC DEPENDENCY =====
apt update -y
apt install -y wget curl socat cron unzip openssl

# ===== FOLDER =====
mkdir -p /etc/zivpn
mkdir -p /var/log/zivpn

# ===== CONFIG =====
if [[ ! -f /etc/zivpn/config.json ]]; then
cat > /etc/zivpn/config.json << 'EOF'
{
  "listen": ":5667",
  "cert": "/etc/zivpn/zivpn.crt",
  "key": "/etc/zivpn/zivpn.key",
  "obfs": "zivpn",
  "auth": {
    "mode": "passwords",
    "config": ["zi"]
  }
}
EOF
fi

# ===== SSL SELF SIGNED =====
if [[ ! -f /etc/zivpn/zivpn.crt ]]; then
openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/zivpn/zivpn.key \
-out /etc/zivpn/zivpn.crt \
-subj "/CN=zivpn"
fi

# ===== DETECT ARCH =====
ARCH=$(uname -m)
case "$ARCH" in
x86_64) BIN="install-amd64" ;;
aarch64|arm64) BIN="install-arm64" ;;
*) echo "❌ Unsupported arch"; exit 1 ;;
esac

# ===== DOWNLOAD CORE =====
wget -O /usr/local/bin/zivpn "https://github.com/diah082/udp-zivpn/releases/latest/download/$BIN"
chmod +x /usr/local/bin/zivpn

# ===== SYSTEMD =====
cat > /etc/systemd/system/zivpn.service << 'EOF'
[Unit]
Description=ZIVPN UDP Service
After=network.target

[Service]
ExecStart=/usr/local/bin/zivpn server -c /etc/zivpn/config.json
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable zivpn
systemctl restart zivpn

echo "✅ ZIVPN Installed"
echo "➡ Port : 5667"

apt install -y jq

cat > /usr/local/bin/kiki << 'EOF'
#!/bin/bash
bash /usr/local/bin/kiki
EOF

chmod +x /usr/local/bin/kiki

