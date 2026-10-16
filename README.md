# YuE2 Mac Lite

YuE2 Mac Lite runs YuE2 on Apple Silicon through the Metal backend in
[audio.cpp](https://github.com/0xShug0/audio.cpp).

# Benefits

  - Native Apple Silicon C++/Metal implementation.
  - No Python environment.
  - One click startup.
  - Full BF16 model and F32 decoder.
  - Current upstream runtime.
  - Verified on an M5 Max.
  - Lighter / simpler than other ports.

The repository contains the installer, launchers and configuration. The
audio.cpp binaries and YuE2 model files are downloaded during installation and
checked against pinned SHA-256 hashes.

## Requirements

- Apple Silicon Mac
- macOS
- 12 GB of free disk space
- Internet connection for the initial 7.8 GB download

The default setup uses the BF16 YuE2-3B model and F32 VAE. It favours output
quality over low memory use.

## Installation

1. Download the repository and unzip it if necessary.
2. Double-click `Install-YuE2.command` in Finder.
3. When installation has finished, double-click `Start-YuE2.command`.

The launcher starts a local server and opens <http://127.0.0.1:8080>. Leave the
Terminal window open while the server is in use. Press Control-C in that window
to stop it.

If macOS blocks one of the `.command` files, Control-click it, choose **Open**,
then confirm **Open**.

## Command-line use

Put the lyrics in a UTF-8 text file and pass that file and a style description
to `generate-song.sh`:

```sh
./generate-song.sh lyrics.txt "acoustic folk, warm, intimate"
```

The default output is `outputs/song.wav`. A different path can be supplied as
the third argument:

```sh
./generate-song.sh lyrics.txt "synth pop, energetic" outputs/demo.wav
```

Lyrics can use section labels understood by YuE2:

```text
[Verse]
First verse

[Chorus]
Chorus
```

## Installed versions

- audio.cpp `0.9.1`, macOS arm64 Metal build
- `audio-cpp/Yue2-3B-GGUF` revision
  `eb116220931de5f373d024d48800338178c7de51`
- YuE2-3B BF16 model
- YuE2 VAE F32 model

Interrupted downloads are resumed where possible. Running the installer again
checks the existing files and only replaces files that fail verification.

An existing download cache can be used by setting `YUE2_DOWNLOAD_CACHE`:

```sh
YUE2_DOWNLOAD_CACHE=/path/to/cache ./Install-YuE2.command
```

## Limits

This setup covers text-and-style song generation. It does not include the
additional models and tools used for covers, humming input, stem separation or
voice cloning.

## Licences

The files in this repository are licensed under Apache-2.0. Downloaded software
and model files keep their own licences.

The YuE2 weights are licensed under CC BY-NC 4.0 with additional permission
from the YuE2 authors for individual creators to publish and monetise generated
outputs. That permission does not allow companies to use the model weights
commercially, or allow commercial redistribution of the weights. Check the
current upstream terms before relying on those permissions.

Full source and attribution details are in
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
