#!/bin/bash
set -e

echo "📦 ZIVPN One Click Installer"

wget -q https://raw.githubusercontent.com/USERNAME/udp-zivpn/main/install.sh
chmod +x install.sh
./install.sh
