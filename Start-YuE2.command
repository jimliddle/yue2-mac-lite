#!/bin/zsh
# Copyright 2026 YuE2 Mac Lite contributors
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

project_dir="${0:A:h}"
server="$project_dir/runtime/audio.cpp/audiocpp_server"

if [[ ! -x "$server" ]]; then
  print -u2 "YuE2 Mac Lite is not installed yet."
  print -u2 "Double-click Install-YuE2.command first."
  [[ -t 0 ]] && read -r "?Press Return to close..."
  exit 1
fi

cd "$project_dir"
"$server" --config "$project_dir/yue-server.json" --ui --log &
server_pid=$!

cleanup() {
  kill "$server_pid" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

for attempt in {1..60}; do
  if /usr/bin/curl -fsS http://127.0.0.1:8080/health >/dev/null 2>&1; then
    /usr/bin/open http://127.0.0.1:8080
    print "YuE2 Mac Lite is running at http://127.0.0.1:8080"
    print "Keep this window open. Press Control-C to stop the server."
    wait "$server_pid"
    exit $?
  fi

  if ! kill -0 "$server_pid" 2>/dev/null; then
    wait "$server_pid"
    exit $?
  fi

  sleep 1
done

print -u2 "YuE2 did not become ready at http://127.0.0.1:8080"
exit 1
