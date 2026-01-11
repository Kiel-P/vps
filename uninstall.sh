#!/bin/bash

systemctl stop zivpn
systemctl disable zivpn

rm -f /etc/systemd/system/zivpn.service
rm -rf /etc/zivpn
rm -f /usr/local/bin/zivpn

systemctl daemon-reload

echo "🗑 ZIVPN removed"
