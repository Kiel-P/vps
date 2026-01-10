#!/bin/bash
echo "[INFO] Request SSL LetsEncrypt"

systemctl stop xray || true

certbot certonly \
  --standalone \
  -d "$DOMAIN" \
  --non-interactive \
  --agree-tos \
  -m admin@$DOMAIN

systemctl start xray
