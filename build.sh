#!/bin/sh
# Zips each data pack (any directory with a pack.mcmeta) into dist/<name>.zip
set -e
cd "$(dirname "$0")"
mkdir -p dist
for mcmeta in */pack.mcmeta; do
  pack=$(dirname "$mcmeta")
  rm -f "dist/$pack.zip"
  (cd "$pack" && zip -qr "../dist/$pack.zip" pack.mcmeta data -x '*.DS_Store')
  echo "Built dist/$pack.zip"
done
