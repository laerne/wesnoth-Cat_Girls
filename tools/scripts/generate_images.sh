#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"

python -m sprite_manager $@ kra -i :/images-kra/exports -o :/images
