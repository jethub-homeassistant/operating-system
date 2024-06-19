#!/bin/bash
# shellcheck disable=SC2155

#    local UBOOT="${BINARIES_DIR}/u-boot.bin.sd.bin"
#    local SPL_IMG="$(path_spl_img)"
#    # SPL
#    create_spl_image
#    dd if="${UBOOT}" of="${SPL_IMG}" bs=1 count=442 conv=fsync
#    dd if="${UBOOT}" of="${SPL_IMG}" bs=512 skip=1 seek=1 conv=fsync

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    mkdir -p "${BOOT_DATA}/amlogic"
    cp "${BINARIES_DIR}/meson-gxl-s905w-jethome-jethub-j80.dtb" "${BOOT_DATA}/amlogic/"

    if ls "${BINARIES_DIR}"/*.dtbo 1> /dev/null 2>&1; then
        echo "Found .dtbo files in ${BINARIES_DIR}"
        mkdir -p "${BOOT_DATA}/overlays"
        cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/overlays/"
    fi
    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/haos-config.txt"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"
}


function hassos_post_image() {
    convert_disk_image_xz
    [[ -f "${BINARIES_DIR}/platform.conf" ]] && convert_disk_image_burn_zip
}
