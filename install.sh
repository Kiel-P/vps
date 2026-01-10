#!/bin/bash
set -e
trap 'echo "❌ INSTALL ERROR — proses dihentikan"; exit 1' ERR

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

clear
echo "=================================="
echo "     ZiVPN Installer v1.0"
echo "=================================="

if [[ $EUID -ne 0 ]]; then
  echo "❌ Jalankan sebagai root"
  exit 1
fi

# ---------- VALIDASI FILE ----------
REQUIRED_FILES=(
  "$BASEDIR/core/dependency.sh"
  "$BASEDIR/core/domain.sh"
  "$BASEDIR/core/xray.sh"
  "$BASEDIR/core/systemd.sh"
  "$BASEDIR/core/ssl.sh"
  "$BASEDIR/bin/zivpn"
)

for f in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "❌ File tidak ditemukan: $f"
    exit 1
  fi
done

chmod +x "$BASEDIR"/core/*.sh
chmod +x "$BASEDIR"/bin/zivpn

# ---------- INSTALL STEP ----------
source "$BASEDIR/core/dependency.sh"
source "$BASEDIR/core/domain.sh"
source "$BASEDIR/core/xray.sh"
source "$BASEDIR/core/systemd.sh"
source "$BASEDIR/core/ssl.sh"

# ---------- INSTALL COMMAND ----------
install -m 755 "$BASEDIR/bin/zivpn" /usr/bin/zivpn

if ! command -v zivpn >/dev/null 2>&1; then
  echo "❌ zivpn gagal terpasang"
  exit 1
fi

echo "=================================="
echo "✅ INSTALL BERHASIL"
echo "➡️ Jalankan perintah: zivpn"
echo "=================================="
