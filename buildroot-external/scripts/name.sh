#!/bin/bash

function os_image_name() {
    echo "${BINARIES_DIR}/${OS_ID}_${BOARD_ID}-$(os_version).${1}"
}

function os_image_name_burn() {
    echo "${BINARIES_DIR}/${OS_ID}_${BOARD_ID}-$(os_version)_burn.${1}"
}

function os_image_basename() {
    echo "${BINARIES_DIR}/${OS_ID}_${BOARD_ID}-$(os_version)"
}

function os_rauc_compatible() {
    echo "${OS_ID}-${BOARD_ID}"
}

function os_version() {
    if [ -z "${VERSION_SUFFIX}" ]; then
        echo "${VERSION_MAJOR}.${VERSION_MINOR}"
    else
        echo "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_SUFFIX}"
    fi
}

function path_boot_dir() {
    echo "${BINARIES_DIR}/boot"
}

function path_rootfs_img() {
    echo "${BINARIES_DIR}/rootfs.erofs"
}
