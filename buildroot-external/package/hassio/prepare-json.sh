#!/usr/bin/env bash

set -e
set -u
set -o pipefail

version_json="$1"

cat "${version_json}" > "${version_json}.tmp"

jq .core+="$(jq .homeassistant[\"jethub-d1\"] ${version_json}.tmp)" "${version_json}.tmp" > "${version_json}"
