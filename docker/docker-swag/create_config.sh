#!/usr/bin/env bash

set -e
. ./.env
mkdir -vp $DOCKERSWAG_CONFIG

files=(url email subdomains)

for file in "${files[@]}"; do
touch $DOCKERSWAG_CONFIG/$file
done
