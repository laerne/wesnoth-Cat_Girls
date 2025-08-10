#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"

python -m sprite_manager animate -i :/json-animations --recursive $@