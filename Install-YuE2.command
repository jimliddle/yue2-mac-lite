#!/bin/zsh
# Copyright 2026 YuE2 Mac Lite contributors
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

project_dir="${0:A:h}"
runtime_version="0.9.1"
model_revision="eb116220931de5f373d024d48800338178c7de51"
runtime_archive="audio-v0.9.1-bin-macos-arm64-metal.tar.gz"
runtime_sha256="960436787b84bf137a70ea1713ac460207ef2ac7b2617380fb7a1f4650d1100d"
runtime_url="https://github.com/0xShug0/audio.cpp/releases/download/v0.9.1/$runtime_archive"
model_base="https://huggingface.co/audio-cpp/Yue2-3B-GGUF/resolve/$model_revision"
download_cache="${YUE2_DOWNLOAD_CACHE:-}"

finish() {
  local exit_code=$?
  if (( exit_code != 0 )); then
    print -u2 ""
    print -u2 "Installation failed. The error above should identify the problem."
  fi
  if [[ -t 0 ]]; then
    print ""
    read -r "?Press Return to close..."
  fi
  return $exit_code
}
trap finish EXIT

fail() {
  print -u2 "Error: $*"
  exit 1
}

sha256() {
  /usr/bin/shasum -a 256 "$1" | /usr/bin/awk '{print $1}'
}

is_valid() {
  local file="$1"
  local expected="$2"
  [[ -f "$file" ]] && [[ "$(sha256 "$file")" == "$expected" ]]
}

copy_from_cache() {
  local cache_file="$1"
  local destination="$2"
  /bin/cp -c "$cache_file" "$destination" 2>/dev/null || /bin/cp "$cache_file" "$destination"
}

fetch() {
  local label="$1"
  local url="$2"
  local destination="$3"
  local expected="$4"
  local cache_file=""
  local partial="$destination.part"

  /bin/mkdir -p "${destination:h}"

  if is_valid "$destination" "$expected"; then
    print "Verified: $label"
    return
  fi

  if [[ -n "$download_cache" ]]; then
    cache_file="$download_cache/${destination:t}"
    if is_valid "$cache_file" "$expected"; then
      print "Using verified cache: $label"
      /bin/rm -f "$partial"
      copy_from_cache "$cache_file" "$partial"
    fi
  fi

  if ! is_valid "$partial" "$expected"; then
    print "Downloading: $label"
    if ! /usr/bin/curl \
      --fail \
      --location \
      --retry 5 \
      --retry-delay 2 \
      --continue-at - \
      --output "$partial" \
      "$url"; then
      print "The partial file could not be resumed; retrying from the beginning."
      /bin/rm -f "$partial"
      /usr/bin/curl \
        --fail \
        --location \
        --retry 5 \
        --retry-delay 2 \
        --output "$partial" \
        "$url"
    fi
  fi

  if ! is_valid "$partial" "$expected"; then
    /bin/rm -f "$partial"
    fail "checksum mismatch for $label; the partial download was removed"
  fi

  /bin/mv "$partial" "$destination"
  print "Installed: $label"
}

[[ "$(/usr/bin/uname -s)" == "Darwin" ]] || fail "macOS is required"
[[ "$(/usr/bin/uname -m)" == "arm64" ]] || fail "an Apple Silicon Mac is required"

for command_path in /usr/bin/curl /usr/bin/shasum /usr/bin/tar /usr/bin/awk; do
  [[ -x "$command_path" ]] || fail "required command is missing: $command_path"
done

available_kb="$(/bin/df -Pk "$project_dir" | /usr/bin/awk 'NR == 2 {print $4}')"
required_kb=$((12 * 1024 * 1024))
(( available_kb >= required_kb )) || fail "at least 12 GB of free disk space is required"

print "YuE2 Mac Lite installer"
print ""
print "This installs:"
print "  audio.cpp $runtime_version for Apple Silicon (Apache-2.0)"
print "  YuE2-3B BF16 and VAE F32 weights (CC BY-NC 4.0)"
print ""
print "Model downloads total approximately 7.8 GB."
print "See THIRD_PARTY_NOTICES.md for sources and licence details."
print ""

/bin/mkdir -p "$project_dir/downloads" "$project_dir/runtime" "$project_dir/models/Yue2-3B-GGUF/sidecars"

archive_path="$project_dir/downloads/$runtime_archive"
fetch "audio.cpp $runtime_version" "$runtime_url" "$archive_path" "$runtime_sha256"

runtime_dir="$project_dir/runtime/audio.cpp-$runtime_version"
if [[ ! -x "$runtime_dir/audiocpp_server" || ! -x "$runtime_dir/audiocpp_cli" || ! -f "$runtime_dir/model_specs/yue2.json" ]]; then
  staging_dir="$project_dir/runtime/.audio.cpp-$runtime_version-staging"
  /bin/rm -rf "$staging_dir"
  /bin/mkdir -p "$staging_dir"
  /usr/bin/tar -xzf "$archive_path" -C "$staging_dir"
  [[ -x "$staging_dir/audiocpp_server" ]] || fail "the audio.cpp archive has an unexpected layout"
  /bin/rm -rf "$runtime_dir"
  /bin/mv "$staging_dir" "$runtime_dir"
fi
/bin/ln -sfn "audio.cpp-$runtime_version" "$project_dir/runtime/audio.cpp"

model_dir="$project_dir/models/Yue2-3B-GGUF"
fetch "YuE2-3B BF16 model" "$model_base/yue2-3b-bf16.gguf?download=true" "$model_dir/yue2-3b-bf16.gguf" "18fe0cda4687a565fc6f2045759f446a67f0d775ea479b87da45de90e7ddc9bc"
fetch "YuE2 VAE F32 model" "$model_base/yue2-vae-f32.gguf?download=true" "$model_dir/yue2-vae-f32.gguf" "cf3b71c6ef13b8b7970f8c1013b899e4af6ff9756c93bda45bef542dd6e10546"
fetch "generation config" "$model_base/sidecars/yue2-generation-config.json?download=true" "$model_dir/sidecars/yue2-generation-config.json" "203830cebde6e3644eb291925362990d198e66c3b6006cd11f1aaa21904bcc61"
fetch "model config" "$model_base/sidecars/yue2-model-config.json?download=true" "$model_dir/sidecars/yue2-model-config.json" "ad3477bbef890bf98ae196c1e4b44779494a6231c4ab66f32708eabadf265329"
fetch "tokenizer" "$model_base/sidecars/yue2-qwen.tiktoken?download=true" "$model_dir/sidecars/yue2-qwen.tiktoken" "b2b1b8dfb5cc5f024bafc373121c6aba3f66f9a5a0269e243470a1de16a33186"
fetch "VAE config" "$model_base/sidecars/yue2-vae-config.json?download=true" "$model_dir/sidecars/yue2-vae-config.json" "f0191bb9694009956de44e0c361a6f1334760be4c8f848e599bde242a54a0970"

print ""
print "Installation complete."
print "Double-click Start-YuE2.command to open the local web interface."
