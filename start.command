#!/bin/sh
# Serves this folder on http://localhost:8765 and opens it in a Bluetooth-capable browser.
# Works on macOS (double-click) and Linux. Needs Python 3.
cd "$(dirname "$0")" || exit 1
PORT="${PORT:-8765}"
URL="http://localhost:$PORT"

python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null' EXIT INT TERM
sleep 1

echo "Niimbot Print is running at $URL (press Ctrl+C to stop)"
if [ "$(uname)" = "Darwin" ]; then
  open -a "Google Chrome" "$URL" 2>/dev/null || open -a "Microsoft Edge" "$URL" 2>/dev/null || open "$URL"
else
  xdg-open "$URL" >/dev/null 2>&1 || true
fi
wait "$server_pid"
