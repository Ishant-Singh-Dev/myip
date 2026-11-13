#!/bin/sh
# myip: print your public IP address, or print it only when it has changed.
# Asks https://ipcomet.com/api/ip, which answers with the bare address as plain text.
#
#   myip              your public IPv4 address
#   myip -6           your public IPv6 address
#   myip --changed    print the address only if it differs from the last run (kept in ~/.myip-4 or ~/.myip-6)
#
# The version is fixed on purpose: on a dual-stack connection curl may use IPv4 on one run and IPv6 on the
# next, and comparing the two would look like a change every time.
set -eu
v=4
changed=no
for arg in "$@"; do
  case "$arg" in
    -4) v=4 ;;
    -6) v=6 ;;
    --changed) changed=yes ;;
    *) echo "usage: myip [-4|-6] [--changed]" >&2; exit 2 ;;
  esac
done
ip=$(curl -"$v" -fsS --max-time 10 https://ipcomet.com/api/ip)
if [ "$changed" = yes ]; then
  state="$HOME/.myip-$v"
  [ "$ip" = "$(cat "$state" 2>/dev/null || true)" ] && exit 0
  printf '%s' "$ip" > "$state"
fi
echo "$ip"
