#!/bin/sh
set -euo pipefail

grim -g "$(slurp)" "$HOME/Pictures/screenshot-$(date '+%Y-%m-%d-%H-%M').png"
