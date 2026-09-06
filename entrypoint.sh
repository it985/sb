#!/bin/sh
set -eu

: "${ANYTLS_SERVER:?ANYTLS_SERVER is required}"
: "${ANYTLS_PASSWORD:?ANYTLS_PASSWORD is required}"

ANYTLS_LISTEN="${ANYTLS_LISTEN:-0.0.0.0:1080}"
ANYTLS_LISTEN_HOST="${ANYTLS_LISTEN%:*}"
ANYTLS_LISTEN_PORT="${ANYTLS_LISTEN##*:}"
ANYTLS_SERVER_PORT="${ANYTLS_SERVER_PORT:-443}"
ANYTLS_SNI="${ANYTLS_SNI:-${ANYTLS_SERVER}}"
ANYTLS_TLS_INSECURE="${ANYTLS_TLS_INSECURE:-false}"

case "${ANYTLS_LISTEN_PORT}" in
  ''|*[!0-9]*)
    echo "ANYTLS_LISTEN must be host:port, got: ${ANYTLS_LISTEN}" >&2
    exit 1
    ;;
esac

case "${ANYTLS_SERVER_PORT}" in
  ''|*[!0-9]*)
    echo "ANYTLS_SERVER_PORT must be numeric, got: ${ANYTLS_SERVER_PORT}" >&2
    exit 1
    ;;
esac

case "${ANYTLS_TLS_INSECURE}" in
  true|false) ;;
  *)
    echo "ANYTLS_TLS_INSECURE must be true or false, got: ${ANYTLS_TLS_INSECURE}" >&2
    exit 1
    ;;
esac

export ANYTLS_LISTEN_HOST ANYTLS_LISTEN_PORT ANYTLS_SERVER ANYTLS_SERVER_PORT ANYTLS_PASSWORD ANYTLS_SNI ANYTLS_TLS_INSECURE

envsubst < /etc/sing-box/config.json.template > /etc/sing-box/config.json

sing-box check -C /etc/sing-box

exec /usr/local/bin/sing-box -D /var/lib/sing-box -C /etc/sing-box run
