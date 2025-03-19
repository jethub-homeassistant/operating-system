#!/bin/bash
# shellcheck disable=SC1090,SC1091,SC2086
set -e

SCRIPT_DIR=${BR2_EXTERNAL_JHOS_PATH}/scripts
BOARD_DIR=${2}
HOOK_FILE=${3}

. "${BR2_EXTERNAL_JHOS_PATH}/meta"
. "${BOARD_DIR}/meta"

. "${SCRIPT_DIR}/hdd-image.sh"
. "${SCRIPT_DIR}/rootfs-layer.sh"
. "${SCRIPT_DIR}/name.sh"
. "${SCRIPT_DIR}/rauc.sh"
. "${HOOK_FILE}"

# Cleanup
rm -rf "$(path_boot_dir)"
mkdir -p "$(path_boot_dir)"

# Hook pre image build stuff
os_pre_image

# Disk & OTA
create_disk_image

# Hook post image build stuff
os_post_image
