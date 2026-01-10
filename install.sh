#!/bin/bash
set -e

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

echo "=================================="
echo "     ZiVPN Installer v1.0 STABLE"
echo "=================================="

if [[ $EUID -ne 0 ]]; then
  echo "❌ Jalankan sebagai root"
  exit 1
fi

REQUIRED=(
"$BASEDIR/core/dependency.sh"
"$BASEDIR/core/domain.sh"
"$BASEDIR/core/xray.sh"
"$BASEDIR/core/systemd.sh"
"$BASEDIR/core/ssl.sh"
"$BASEDIR/bin/zivpn"
)

for f in "${REQUIRED[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "❌ File hilang: $f"
    exit 1
  fi
done

chmod +x "$BASEDIR"/core/*.sh
chmod +x "$BASEDIR"/bin/zivpn

source "$BASEDIR/core/dependency.sh"
source "$BASEDIR/core/domain.sh"
source "$BASEDIR/core/xray.sh"
source "$BASEDIR/core/systemd.sh"

# SSL JANGAN MEMBUNUH INSTALLER
set +e
source "$BASEDIR/core/ssl.sh"
set -e

install -m 755 "$BASEDIR/bin/zivpn" /usr/bin/zivpn

if ! command -v zivpn >/dev/null; then
  echo "❌ zivpn gagal terpasang"
  exit 1
fi

echo "=================================="
echo "✅ INSTALL SELESAI"
echo "➡️ Jalankan: zivpn"
echo "=================================="
