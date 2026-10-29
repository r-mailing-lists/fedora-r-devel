#!/usr/bin/env bash
# Fetch months of Fedora's R list from its Mailman 3 archive and write each as
# raw/<YYYY-Month>.mbox (see hyperkitty-to-mbox.py for what is kept).
#
#   tools/update.sh                    this month and the one before
#   tools/update.sh 2026-09 2026-10    the months named
#   FORCE=1 tools/update.sh ...        replace a month even with fewer messages
#
# A month already here is replaced only by a copy with at least as many
# messages, so an export that comes back short or empty never takes mail
# away. Needs GNU date and python3.
set -euo pipefail

EXPORT="https://lists.fedoraproject.org/archives/list/r-devel@lists.fedoraproject.org/export"
cd "$(dirname "$0")/.."
mkdir -p raw

months=("$@")
if [ ${#months[@]} -eq 0 ]; then
  this=$(date -u +%Y-%m)
  months=("$(date -u -d "$this-01 -1 month" +%Y-%m)" "$this")
fi

count() { grep -c '^From ' "$1" 2>/dev/null || true; }

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
for m in "${months[@]}"; do
  case "$m" in [12][0-9][0-9][0-9]-[01][0-9]) ;; *) echo "not a month: $m" >&2; exit 1 ;; esac
  start="$m-01"
  end=$(date -u -d "$start +1 month" +%F)
  name="raw/$(date -u -d "$start" +%Y-%B).mbox"
  curl -fsSL --retry 3 --retry-delay 20 -o "$tmp/export.mbox.gz" \
    "$EXPORT/r-devel-$m.mbox.gz?start=$start&end=$end"
  python3 -I tools/hyperkitty-to-mbox.py "$tmp/export.mbox.gz" "$tmp/month.mbox"
  new=$(count "$tmp/month.mbox")
  old=$(count "$name")
  if [ "$new" -eq 0 ]; then
    echo "$m: no messages"
  elif [ "${FORCE:-0}" = 1 ] || [ "$new" -ge "${old:-0}" ]; then
    mv "$tmp/month.mbox" "$name"
    echo "$m: $new messages"
  else
    echo "$m: kept the copy here ($old messages), the export had $new" >&2
  fi
  sleep 2
done
