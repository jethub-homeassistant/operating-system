#!/bin/bash
# shellcheck disable=SC2155



function _create_disk_burn() {
    local hdd_ext=${1:-img}
    local hdd_img="$(hassos_image_name "${hdd_ext}")"
    local hdd_img_burn="$(hassos_image_name_burn "${hdd_ext}")"

    local boot_img="$(path_boot_img)"
    local rootfs_img="$(path_rootfs_img)"
    local overlay_img="$(path_overlay_img)"
    local data_img="$(path_data_img)"
    local kernel_img="$(path_kernel_img)"

    local ddrbin_img="DDR.USB"
    local ubootbin_img="UBOOT.USB"
    local bootloader_img="u-boot.bin"
    {
      echo "[LIST_NORMAL]"
      echo 'file="'"${ddrbin_img}"'"		main_type="USB"		sub_type="DDR"'
      echo 'file="'"${ubootbin_img}"'"		main_type="USB"		sub_type="UBOOT"'
      echo 'file="_aml_dtb.PARTITION"		main_type="dtb"		sub_type="meson1"'
      echo 'file="platform.conf"		main_type="conf"		sub_type="platform"'
      echo ""
      echo "[LIST_VERIFY]"
      echo 'file="_aml_dtb.PARTITION"	main_type="PARTITION"		sub_type="_aml_dtb"'
      echo 'file="'"${bootloader_img}"'"	main_type="PARTITION"		sub_type="bootloader"'
      echo 'file="'"${boot_img##*/}"'"		main_type="PARTITION"		sub_type="boothaos"'
      echo 'file="'"${kernel_img##*/}"'"		main_type="PARTITION"		sub_type="kernela"'
      echo 'file="'"${rootfs_img##*/}"'"		main_type="PARTITION"		sub_type="systema"'
      echo 'file="'"${overlay_img##*/}"'"		main_type="PARTITION"		sub_type="overlay"'
      echo 'file="'"${data_img##*/}"'"		main_type="PARTITION"		sub_type="data"'
    } > "${BINARIES_DIR}/image.cfg"

    _create_dtb_file
    aml_image_v2_packer_new -r "${BINARIES_DIR}/image.cfg" "${BINARIES_DIR}/" "$hdd_img_burn"

}

function size2number() {
    local f=0
    for v in "${@}"
    do
    local p=$(echo "$v" | awk \
      'BEGIN{IGNORECASE = 1}
       function printsectors(n,b,p) {printf "%u\n", n*b^p}
       /B$/{     printsectors($1,  1, 0)};
       /K(iB)?$/{printsectors($1,  2, 10)};
       /M(iB)?$/{printsectors($1,  2, 20)};
       /G(iB)?$/{printsectors($1,  2, 30)};
       /T(iB)?$/{printsectors($1,  2, 40)};
       /KB$/{    printsectors($1, 10,  3)};
       /MB$/{    printsectors($1, 10,  6)};
       /GB$/{    printsectors($1, 10,  9)};
       /TB$/{    printsectors($1, 10, 12)}')
    for s in $p
    do
        f=$((f+s))
    done

    done
    echo $f
}


function _create_dtb_file () {
    local boot_size=$(size2number "${BOOT_SIZE}")
    local kernel0_size=$(size2number "${KERNEL_SIZE}")
    local system0_size=$(size2number "$SYSTEM_SIZE")
    local kernel1_size=$(size2number "$KERNEL_SIZE")
    local system1_size=$(size2number "$SYSTEM_SIZE")
    local bootstate_size=$(size2number "$BOOTSTATE_SIZE")
    local overlay_size=$(size2number "$OVERLAY_SIZE")
    local data_size=$(size2number "$DATA_SIZE")
    {
      echo "/ {"
      echo "	partitions: partitions {"
      echo "		parts = <0x08>;"
      echo "		part-0 = <&boothaos>;"
      echo "		part-1 = <&overlay>;"
      echo "		part-2 = <&kernela>;"
      echo "		part-3 = <&systema>;"
      echo "		part-4 = <&kernelb>;"
      echo "		part-5 = <&systemb>;"
      echo "		part-6 = <&bootinfo>;"
      echo "		part-7 = <&data>;"
      echo ""
      echo "		boothaos: boothaos {"
      echo "			pname = \"boothaos\";"
      echo "			size = <0x00 ${boot_size}>;"
      echo "			mask = <0x01>;"
      echo "		};"
      echo ""
      echo "		overlay: overlay {"
      echo "			pname = \"overlay\";"
      echo "			size = <0x00 ${overlay_size}>;"
      echo "			mask = <0x04>;"
      echo "		};"
      echo ""
      echo "		data: data {"
      echo "			pname = \"data\";"
      echo "			size = <0xffffffff 0xffffffff>;"
      echo "			mask = <0x04>;"
      echo "		};"
      echo ""
      echo "		kernela: kernela {"
      echo "			pname = \"kernela\";"
      echo "			size = <0x00 ${kernel0_size}>;"
      echo "			mask = <0x04>;"
      echo "		};"
      echo ""
      echo "		systema: systema {"
      echo "			pname = \"systema\";"
      echo "			size = <0x00 ${system0_size}>;"
      echo "			mask = <0x04>;"
      echo "		};"
      echo ""
      echo "		kernelb: kernelb {"
      echo "			pname = \"kernelb\";"
      echo "			size = <0x00 ${kernel1_size}>;"
      echo "			mask = <0x04>;"
      echo "		};"
      echo ""
      echo "		systemb: systemb {"
      echo "			pname = \"systemb\";"
      echo "			size = <0x00 ${system1_size}>;"
      echo "			mask = <0x04>;"
      echo "		};"
      echo ""
      echo "		bootinfo: bootinfo {"
      echo "			pname = \"bootinfo\";"
      echo "			size = <0x00 ${bootstate_size}>;"
      echo "			mask = <0x04>;"
      echo "		};"
      echo "	};"
      echo "};"
    } > "${BINARIES_DIR}/dts/partition.dtsi"

    echo cpp -nostdinc -I "${BINARIES_DIR}/dts" -I "${BINARIES_DIR}/dts/include" -undef -x assembler-with-cpp "${BINARIES_DIR}/dts/board.dts" "${BINARIES_DIR}/dts/board.dts.preprocess"
    cpp -nostdinc -I "${BINARIES_DIR}/dts" -I "${BINARIES_DIR}/dts/include" -undef -x assembler-with-cpp "${BINARIES_DIR}/dts/board.dts" "${BINARIES_DIR}/dts/board.dts.preprocess"
    echo dtc -I dts -O dtb -p 0x1000 -qqq "${BINARIES_DIR}/dts/board.dts.preprocess" -o "${BINARIES_DIR}/dts/board.dtb"
    dtc -I dts -O dtb -p 0x1000 -qqq "${BINARIES_DIR}/dts/board.dts.preprocess" -o "${BINARIES_DIR}/dts/board.dtb"

    dtbTool -o "$BINARIES_DIR/_aml_dtb.PARTITION" "${BINARIES_DIR}/dts/"

}


function convert_disk_image_burn_zip() {
    local hdd_ext=${1:-img}
    local hdd_img_burn="$(hassos_image_name_burn "${hdd_ext}")"

    rm -f "${hdd_img_burn}.zip"
    zip -j -m -q -r "${hdd_img_burn}.zip" "${hdd_img_burn}"
}
