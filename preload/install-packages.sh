#!/bin/sh
# Preload packages into the NPM Mirror cache.
#
# Usage:
#   ./install-packages.sh                    # preload all packages
#   PROFILE=frontend ./install-packages.sh    # preload only packages tagged "frontend"
#   INCREMENTAL=1 ./install-packages.sh       # skip packages already preloaded before
#
# Config file: packages.conf (see that file for the tag format)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONF_FILE="$SCRIPT_DIR/packages.conf"
STATE_FILE="$SCRIPT_DIR/.preload-state"

PROFILE="${PROFILE:-all}"
INCREMENTAL="${INCREMENTAL:-0}"

if [ ! -f "$CONF_FILE" ]; then
  echo "Config file not found: $CONF_FILE"
  exit 1
fi

[ "$INCREMENTAL" = "1" ] && touch "$STATE_FILE"

total=0
installed=0
skipped=0
failed=0

while IFS= read -r line; do
  case "$line" in
    ''|'#'*) continue ;;
  esac

  package="$(echo "$line" | awk '{print $1}')"
  tags="$(echo "$line" | sed -n 's/.*#tags: *//p')"

  [ -z "$package" ] && continue

  if [ "$PROFILE" != "all" ]; then
    case ",$tags," in
      *",$PROFILE,"*) : ;;
      *) continue ;;
    esac
  fi

  total=$((total + 1))

  if [ "$INCREMENTAL" = "1" ] && grep -qxF "$package" "$STATE_FILE" 2>/dev/null; then
    skipped=$((skipped + 1))
    continue
  fi

  echo "Installing: $package"
  if npm install --no-save --ignore-scripts "$package"; then
    installed=$((installed + 1))
    [ "$INCREMENTAL" = "1" ] && echo "$package" >> "$STATE_FILE"
  else
    echo "Failed: $package"
    failed=$((failed + 1))
  fi
done < "$CONF_FILE"

echo ""
echo "Preload finished. profile=$PROFILE matched=$total installed=$installed skipped=$skipped failed=$failed"
