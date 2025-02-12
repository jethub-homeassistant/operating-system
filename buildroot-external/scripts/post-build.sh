#!/bin/bash
# shellcheck disable=SC1090,SC1091
set -e

SCRIPT_DIR=${BR2_EXTERNAL_JHOS_PATH}/scripts
BOARD_DIR=${2}

. "${BR2_EXTERNAL_JHOS_PATH}/meta"
. "${BOARD_DIR}/meta"

. "${SCRIPT_DIR}/rootfs-layer.sh"
. "${SCRIPT_DIR}/name.sh"
. "${SCRIPT_DIR}/rauc.sh"

# JHOS tasks
fix_rootfs
install_tini_docker

# Write os-release
# shellcheck disable=SC2153
(
    echo "NAME=\"${OS_NAME}\""
    echo "VERSION=\"$(os_version) (${BOARD_NAME})\""
    echo "ID=${OS_ID}"
    echo "VERSION_ID=$(os_version)"
    echo "PRETTY_NAME=\"${OS_NAME} $(os_version)\""
    echo "CPE_NAME=cpe:2.3:o:jethome:${OS_ID}:$(os_version):*:${DEPLOYMENT}:*:*:*:${BOARD_ID}:*"
    echo "HOME_URL=https://jethome.ru/"
    echo "VARIANT=\"${OS_NAME} ${BOARD_NAME}\""
    echo "VARIANT_ID=${BOARD_ID}"
) > "${TARGET_DIR}/usr/lib/os-release"

# Write machine-info
(
    echo "CHASSIS=${CHASSIS}"
    echo "DEPLOYMENT=${DEPLOYMENT}"
) > "${TARGET_DIR}/etc/machine-info"


# Setup RAUC
prepare_rauc_signing
write_rauc_config
install_rauc_certs
install_bootloader_config

# Fix overlay presets
"${HOST_DIR}/bin/systemctl" --root="${TARGET_DIR}" preset-all
