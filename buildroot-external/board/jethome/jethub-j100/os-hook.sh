#!/bin/bash
# shellcheck disable=SC2155

# shellcheck source=../../../scripts/burn.sh
. "${SCRIPT_DIR}/burn.sh"

function os_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    mkdir -p "${BOOT_DATA}/amlogic"
    cp "${BINARIES_DIR}/meson-axg-jethome-jethub-j100.dtb" "${BOOT_DATA}/amlogic/"
    cp "${BINARIES_DIR}/meson-axg-jethome-jethub-j110-rev-2.dtb" "${BOOT_DATA}/amlogic/"
    cp "${BINARIES_DIR}/meson-axg-jethome-jethub-j110-rev-3.dtb" "${BOOT_DATA}/amlogic/"

    if ls "${BINARIES_DIR}"/*.dtbo 1> /dev/null 2>&1; then
        echo "Found .dtbo files in ${BINARIES_DIR}"
        mkdir -p "${BOOT_DATA}/overlays"
        cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/overlays/"
    fi
    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/os-config.txt" || true
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"

    # Add kernel into rootfs
    if [ -f "${BINARIES_DIR}/Image" ]; then
    cp "${BINARIES_DIR}/Image" "${TARGET_DIR}/boot/"
        else
    echo "ERROR: Kernel Image not found!"
    exit 1
    fi

}

function os_post_image() {
    convert_disk_image_xz
    # support for create AmLogic burnable images
    [[ -f "${BINARIES_DIR}/platform.conf" ]] && _create_disk_burn
    [[ -f "${BINARIES_DIR}/platform.conf" ]] && convert_disk_image_burn_zip
}
