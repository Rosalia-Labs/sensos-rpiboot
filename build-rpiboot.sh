#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USBBOOT_DIR="${ROOT_DIR}/usbboot"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_cmd git
require_cmd make
require_cmd pkg-config
require_cmd cc

if ! pkg-config --exists libusb-1.0; then
  cat >&2 <<'EOF'
Missing libusb development files for pkg-config.

If you use MacPorts, install the dependencies with:
  sudo port install libusb pkgconfig git
EOF
  exit 1
fi

if [ ! -d "${USBBOOT_DIR}/.git" ]; then
  echo "Cloning raspberrypi/usbboot into ${USBBOOT_DIR}"
  git clone --depth 1 https://github.com/raspberrypi/usbboot.git "${USBBOOT_DIR}"
else
  echo "Updating existing usbboot checkout"
  if [ -n "$(git -C "${USBBOOT_DIR}" status --porcelain)" ]; then
    echo "Refusing to update: ${USBBOOT_DIR} has local changes" >&2
    exit 1
  fi
  git -C "${USBBOOT_DIR}" pull --ff-only --depth 1 origin master
fi

echo "Building rpiboot"
make -C "${USBBOOT_DIR}"

cat <<EOF

Build complete.
Binary: ${USBBOOT_DIR}/rpiboot

Run it with:
  ${USBBOOT_DIR}/rpiboot
EOF
