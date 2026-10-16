# Third-party notices

This repository does not contain audio.cpp binaries or YuE2 model weights. The
installer downloads the following files from their publishers.

## audio.cpp

- Source: <https://github.com/0xShug0/audio.cpp>
- Downloaded release: `v0.9.1`, macOS arm64 Metal archive
- Copyright: ShugoAI LLC and audio.cpp contributors
- Licence: [Apache License 2.0](https://github.com/0xShug0/audio.cpp/blob/v0.9.1/LICENSE)

The release archive includes its upstream licence file. YuE2 Mac Lite does not
modify or redistribute the archive.

## YuE2 model files

- Original project: <https://github.com/multimodal-art-projection/YuE>
- Original YuE2-3B model: <https://huggingface.co/m-a-p/YuE2-3B>
- Original YuE2 VAE: <https://huggingface.co/m-a-p/YuE2-Vae>
- GGUF conversion: <https://huggingface.co/audio-cpp/Yue2-3B-GGUF>
- GGUF revision: `eb116220931de5f373d024d48800338178c7de51`
- Licence: [CC BY-NC 4.0 with the YuE2 authors' additional creator permission](https://github.com/multimodal-art-projection/YuE/blob/cbb3b060725ddd95ac6e6237cfb709e153da5988/MODEL_LICENSE)

The installer downloads BF16 YuE2-3B weights, F32 YuE2 VAE weights and the
configuration and tokenizer files required by audio.cpp. Each file is fetched
from the pinned GGUF revision and checked against a SHA-256 hash.

The additional creator permission is dated 16 September 2026. The model
licensors permit personal users, content creators and musicians
acting as individuals to publish and monetise generated outputs, subject to the
responsible-use conditions in the model licence. Companies need a separate
commercial licence to use the weights commercially. The additional permission
does not cover commercial redistribution of the weights.

When sharing the weights or adapted weights, follow the attribution rules in
the full model licence. Identify YuE2, the relevant model and its source
repository, retain the licence notice and indicate modifications. Credit on
generated output is encouraged by the YuE2 authors but is not required by their
additional creator permission.

Third-party rights may still apply to prompts, lyrics, recordings and generated
material. Users are responsible for obtaining any rights or consent their use
requires.

YuE2 Mac Lite is an independent installer and launcher. It is not affiliated
with or endorsed by the YuE2 or audio.cpp projects.
