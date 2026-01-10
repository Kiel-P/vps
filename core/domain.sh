#!/bin/bash
DOMAIN_FILE="/etc/zivpn/domain"
mkdir -p /etc/zivpn

if [[ ! -f "$DOMAIN_FILE" ]]; then
  read -rp "Masukkan domain VPS: " DOMAIN
  echo "$DOMAIN" > "$DOMAIN_FILE"
else
  DOMAIN=$(cat "$DOMAIN_FILE")
fi

export DOMAIN
echo "[INFO] Domain: $DOMAIN"
