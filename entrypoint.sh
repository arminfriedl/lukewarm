#!/usr/bin/env bash

set -euo pipefail

# Copy immutable dist to work folder if it exists and is empty
if [ -d "/class" ] && [ -z "$(ls -A /class)" ]; then
    cp -R /usr/class/* /class/
fi

exec "$@"
