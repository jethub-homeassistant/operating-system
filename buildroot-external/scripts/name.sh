#!/bin/bash

function jhos_image_name() {
    echo "${BINARIES_DIR}/${JHOS_ID}_${BOARD_ID}-$(jhos_version).${1}"
}

function jhos_image_name_burn() {
    echo "${BINARIES_DIR}/${JHOS_ID}_${BOARD_ID}-$(jhos_version)_burn.${1}"
}

function jhos_rauc_compatible() {
    echo "${JHOS_ID}-${BOARD_ID}"
}

function jhos_version() {
    if [ -z "${VERSION_DEV}" ]; then
        echo "${VERSION_MAJOR}.${VERSION_BUILD}"
    else
        echo "${VERSION_MAJOR}.${VERSION_BUILD}.${VERSION_DEV}"
    fi
}

function hassos_image_name() {
    echo "${BINARIES_DIR}/${HASSOS_ID}_${BOARD_ID}-$(hassos_version).${1}"
}

function hassos_image_name_burn() {
    echo "${BINARIES_DIR}/${HASSOS_ID}_${BOARD_ID}-$(hassos_version)_burn.${1}"
}

function hassos_rauc_compatible() {
    echo "${HASSOS_ID}-${BOARD_ID}"
}

function hassos_version() {
    if [ -z "${VERSION_DEV}" ]; then
        echo "${VERSION_MAJOR}.${VERSION_BUILD}"
    else
        echo "${VERSION_MAJOR}.${VERSION_BUILD}.${VERSION_DEV}"
    fi
}

function path_spl_img() {
    echo "${BINARIES_DIR}/spl.img"
}

function path_kernel_img() {
    echo "${BINARIES_DIR}/kernel.img"
}

function path_boot_img() {
    echo "${BINARIES_DIR}/boot.vfat"
}

function path_boot_dir() {
    echo "${BINARIES_DIR}/boot"
}

function path_data_img() {
    echo "${BINARIES_DIR}/data.ext4"
}

function path_overlay_img() {
    echo "${BINARIES_DIR}/overlay.ext4"
}

function path_rootfs_img() {
    echo "${BINARIES_DIR}/rootfs.squashfs"
}

