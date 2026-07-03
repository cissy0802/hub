#!/usr/bin/env bash
# Rebuild secondbrian's language pages from the hub's source of truth.
#   index.en.html = English  (hub index.en.html)  ← default (via index.html redirect stub)
#   index.zh.html = Chinese  (hub index.html)
# Transforms applied to both:
#   1. toggle: the 中文 link points at the hub's index.html → repoint to index.zh.html
#      (the EN link already targets index.en.html, which is our English file, so it's left as-is)
#   2. root-relative assets (/comments.js, /search.js, ...) -> absolute on cissy0802.github.io
# index.html (a static redirect stub -> index.en.html) and CNAME are committed once and never touched here.
set -euo pipefail

HUB="https://raw.githubusercontent.com/cissy0802/cissy0802.github.io/main"

curl -sfL --retry 4 --retry-delay 2 "$HUB/index.en.html" -o index.en.html
curl -sfL --retry 4 --retry-delay 2 "$HUB/index.html"    -o index.zh.html

for f in index.en.html index.zh.html; do
  perl -i -pe '
    s{href="index\.html"}{href="index.zh.html"}g;
    s{(src|href)="/([^"/][^"]*)"}{$1="https://cissy0802.github.io/$2"}g;
  ' "$f"
done

echo "Built index.en.html (EN) + index.zh.html (ZH) from hub."
