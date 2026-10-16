#!/bin/zsh
# Copyright 2026 YuE2 Mac Lite contributors
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

project_dir="${0:A:h}"
cli="$project_dir/runtime/audio.cpp/audiocpp_cli"
model_dir="$project_dir/models/Yue2-3B-GGUF"

usage() {
  print -u2 "Usage: ./generate-song.sh LYRICS_FILE STYLE [OUTPUT_WAV]"
  print -u2 'Example: ./generate-song.sh lyrics.txt "acoustic folk, warm, intimate"'
}

if (( $# < 2 || $# > 3 )); then
  usage
  exit 2
fi

if [[ ! -x "$cli" ]]; then
  print -u2 "YuE2 Mac Lite is not installed. Run ./Install-YuE2.command first."
  exit 1
fi

lyrics_file="$1"
style="$2"
output="${3:-$project_dir/outputs/song.wav}"

if [[ ! -f "$lyrics_file" ]]; then
  print -u2 "Lyrics file not found: $lyrics_file"
  exit 1
fi

/bin/mkdir -p "${output:h}"
lyrics="$(command cat -- "$lyrics_file")"

cd "$project_dir"
exec "$cli" \
  --task gen \
  --family yue2 \
  --model "$model_dir" \
  --backend metal \
  --threads 12 \
  --text "$lyrics" \
  --request-option "style=$style" \
  --request-option cot=full \
  --request-option num_inference_steps=8 \
  --session-option yue2.model_gguf=yue2-3b-bf16.gguf \
  --session-option yue2.vae_gguf=yue2-vae-f32.gguf \
  --out "$output" \
  --log
