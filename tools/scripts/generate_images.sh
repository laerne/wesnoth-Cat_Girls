#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"

python -m sprite_manager -U kra -i :/images-kra/exports -o :/images
