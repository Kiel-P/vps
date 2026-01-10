#!/bin/bash
echo "[INFO] Install dependency..."
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y curl wget unzip socat cron certbot
