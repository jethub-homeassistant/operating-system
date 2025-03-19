#!/bin/bash

CURPWD="$(pwd)"
GITHUB_WORKSPACE="$(realpath ${CURPWD})"

BUILDER_UID="$(id -u)"
BUILDER_GID="$(id -g)"

BOARD="$1"
shift

if [[ -z "$BOARD" ]]; then
  BOARD=jethub_j200
fi

sudo docker build -t os-builder .


sudo docker run --rm --privileged -v "${GITHUB_WORKSPACE}:/build" \
  -e BUILDER_UID="${BUILDER_UID}" -e BUILDER_GID="${BUILDER_GID}" \
  -v "./cache:/cache" \
  os-builder \
  make BUILDDIR=/build $BOARD $@

