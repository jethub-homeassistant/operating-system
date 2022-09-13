
################################################################################
#
# amlogic-boot-fip
#
################################################################################

AMLOGIC_BOOT_FIP_VERSION = f49ee39e1c6988b8ddb24f4e5a63286d133864cb
AMLOGIC_BOOT_FIP_SITE = https://github.com/LibreELEC/amlogic-boot-fip
AMLOGIC_BOOT_FIP_SITE_METHOD = git
AMLOGIC_BOOT_FIP_INSTALL_IMAGES = YES
AMLOGIC_BOOT_FIP_DEPENDENCIES = uboot

AMLOGIC_BOOT_FIP_LICENSE = PROPRIETARY
AMLOGIC_BOOT_FIP_REDISTRIBUTE = NO

AMLOGIC_BOOT_BINS += u-boot.bin.sd.bin

define AMLOGIC_BOOT_FIP_BUILD_CMDS
    mkdir -p $(@D)/fip
    cp $(BINARIES_DIR)/u-boot.bin $(@D)/fip/bl33.bin
    cd "$(@D)"; ./build-fip.sh $(call qstrip,$(BR2_PACKAGE_AMLOGIC_BOOT_FIP_BOARD)) $(@D)/fip/bl33.bin $(@D)/fip
endef

ifeq ($(BR2_PACKAGE_AMLOGIC_BOOT_FIP),y)
ifeq ($(call qstrip,$(BR2_PACKAGE_AMLOGIC_BOOT_FIP_BOARD)),)
$(error No board u-boot firmware config name specified, check your BR2_PACKAGE_AMLOGIC_BOOT_FIP_BOARD setting)
endif # qstrip BR2_PACKAGE_AMLOGIC_BOOT_FIP_BOARD
endif

define AMLOGIC_BOOT_FIP_INSTALL_IMAGES_CMDS
	$(foreach f,$(AMLOGIC_BOOT_BINS), \
			cp -dpf "$(@D)/fip/$(f)" "$(BINARIES_DIR)/"
	)
endef

$(eval $(generic-package))
