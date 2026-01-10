#!/bin/bash
echo "[INFO] Request SSL LetsEncrypt"

mkdir -p /var/lib/letsencrypt /etc/letsencrypt

systemctl stop nginx 2>/dev/null || true
systemctl stop apache2 2>/dev/null || true
systemctl stop xray 2>/dev/null || true

if ss -tlnp | grep -q ':80'; then
  echo "⚠️ Port 80 dipakai, SSL dilewati"
  systemctl start xray
  exit 0
fi

certbot certonly \
 --standalone \
 --preferred-challenges http \
 -d "$DOMAIN" \
 --agree-tos \
 --register-unsafely-without-email \
 --non-interactive || true

systemctl start xray
echo "[INFO] SSL step selesai (tidak fatal)"
