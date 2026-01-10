#!/bin/bash
set -e
trap 'echo "❌ INSTALL ERROR — proses dihentikan"; exit 1' ERR

clear
echo "=================================="
echo "     ZiVPN Installer v1.0"
echo "=================================="

if [[ $EUID -ne 0 ]]; then
  echo "❌ Jalankan sebagai root"
  exit 1
fi

chmod +x core/*.sh bin/zivpn

source core/dependency.sh
source core/domain.sh
source core/xray.sh
source core/systemd.sh
source core/ssl.sh

install -m 755 bin/zivpn /usr/bin/zivpn

if ! command -v zivpn >/dev/null; then
  echo "❌ zivpn gagal terpasang"
  exit 1
fi

echo "=================================="
echo "✅ INSTALL BERHASIL"
echo "➡️ Jalankan perintah: zivpn"
echo "=================================="
