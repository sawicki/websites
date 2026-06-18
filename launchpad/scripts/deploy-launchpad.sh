#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "usage: sudo deploy-launchpad" >&2
  exit 64
fi

if [[ "${EUID}" -ne 0 ]]; then
  echo "deploy-launchpad must run as root via sudo" >&2
  exit 1
fi

STAGING="/home/felix/landing-deploy"
CADDY_SRC="${STAGING}/Caddyfile.hostinger"
CADDY_DST="/etc/caddy/Caddyfile"
STAMP="$(date +%Y%m%d-%H%M%S)"

require_file() {
  if [[ ! -f "$1" ]]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

sync_dir() {
  local src="$1"
  local dst="$2"

  if [[ ! -d "${src}" ]]; then
    echo "missing required directory: ${src}" >&2
    exit 1
  fi

  install -d -m 0755 -o www-data -g www-data "${dst}"
  cp -a "${src}/." "${dst}/"
  chown -R www-data:www-data "${dst}"
  find "${dst}" -type d -exec chmod 0755 {} +
  find "${dst}" -type f -exec chmod 0644 {} +
}

require_file "${CADDY_SRC}"
require_file "${STAGING}/landing-index.html"

caddy validate --config "${CADDY_SRC}" >/dev/null

if ! cmp -s "${CADDY_SRC}" "${CADDY_DST}"; then
  cp "${CADDY_DST}" "${CADDY_DST}.bak-launchpad-${STAMP}"
  install -m 0644 "${CADDY_SRC}" "${CADDY_DST}"
fi

if [[ -d "${STAGING}/www/landing" ]]; then
  sync_dir "${STAGING}/www/landing" /var/www/landing
else
  install -d -m 0755 -o www-data -g www-data /var/www/landing
  install -m 0644 -o www-data -g www-data "${STAGING}/landing-index.html" /var/www/landing/index.html

  for asset in favicon.ico favicon-16x16.png favicon-32x32.png apple-touch-icon.png icon-192.png icon-512.png; do
    if [[ -f "${STAGING}/${asset}" ]]; then
      install -m 0644 -o www-data -g www-data "${STAGING}/${asset}" "/var/www/landing/${asset}"
    fi
  done

  if [[ -d "${STAGING}/mhpcc" ]]; then
    sync_dir "${STAGING}/mhpcc" /var/www/landing/mhpcc
  fi
fi

if [[ -d "${STAGING}/eberly.xyz" ]]; then
  sync_dir "${STAGING}/eberly.xyz" /var/www/eberly.xyz
fi

if [[ -d "${STAGING}/ty.fjs.cx" ]]; then
  sync_dir "${STAGING}/ty.fjs.cx" /var/www/ty.fjs.cx
fi

systemctl reload caddy
echo "launchpad deploy complete"
