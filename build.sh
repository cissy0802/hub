#!/usr/bin/env bash
# Rebuild secondbrian's two language pages from the hub's source of truth.
#   index.html    = English  (hub index.en.html)  ← default landing
#   index.zh.html = Chinese  (hub index.html)
# Transforms applied to both:
#   1. toggle links: relative href="index.html" -> index.zh.html ; href="index.en.html" -> index.html
#   2. root-relative assets (/comments.js, /search.js, ...) -> absolute on cissy0802.github.io
# CNAME is committed separately and never touched here.
set -euo pipefail

HUB="https://raw.githubusercontent.com/cissy0802/cissy0802.github.io/main"

curl -sfL --retry 4 --retry-delay 2 "$HUB/index.en.html" -o index.html
curl -sfL --retry 4 --retry-delay 2 "$HUB/index.html"    -o index.zh.html

for f in index.html index.zh.html; do
  perl -i -pe '
    s{href="index\.html"}{href="index.zh.html"}g;
    s{href="index\.en\.html"}{href="index.html"}g;
    s{(src|href)="/([^"/][^"]*)"}{$1="https://cissy0802.github.io/$2"}g;
  ' "$f"
done

echo "Built index.html (EN) + index.zh.html (ZH) from hub."
