#!/bin/sh
set -eu

export WLR_BACKENDS=headless
dbus-run-session sway
