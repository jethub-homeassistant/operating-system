
################################################################################
#
# amlogic-boot-fip
#
################################################################################

AMLOGIC_BOOT_FIP_E_VERSION = 106c0d9a280701227045f092bd1d7ae4a44cfd09
AMLOGIC_BOOT_FIP_E_SITE = https://github.com/adeepn/amlogic-boot-fip
AMLOGIC_BOOT_FIP_E_SITE_METHOD = git
AMLOGIC_BOOT_FIP_E_INSTALL_IMAGES = YES
AMLOGIC_BOOT_FIP_E_DEPENDENCIES = uboot

AMLOGIC_BOOT_FIP_E_LICENSE = PROPRIETARY
AMLOGIC_BOOT_FIP_E_REDISTRIBUTE = NO

AMLOGIC_BOOT_BINS += u-boot.bin u-boot.bin.sd.bin

define AMLOGIC_BOOT_FIP_E_BUILD_CMDS
    mkdir -p $(@D)/fip
    cp $(BINARIES_DIR)/u-boot.bin $(@D)/fip/bl33.bin
    cd "$(@D)"; ./build-fip.sh $(call qstrip,$(BR2_PACKAGE_AMLOGIC_BOOT_FIP_E_BOARD)) $(@D)/fip/bl33.bin $(@D)/fip
endef

ifeq ($(BR2_PACKAGE_AMLOGIC_BOOT_FIP_E),y)
ifeq ($(call qstrip,$(BR2_PACKAGE_AMLOGIC_BOOT_FIP_E_BOARD)),)
$(error No board u-boot firmware config name specified, check your BR2_PACKAGE_AMLOGIC_BOOT_FIP_E_BOARD setting)
endif # qstrip BR2_PACKAGE_AMLOGIC_BOOT_FIP_E_BOARD
endif

define AMLOGIC_BOOT_FIP_E_INSTALL_IMAGES_CMDS
	$(foreach f,$(AMLOGIC_BOOT_BINS), \
			cp -dpf "$(@D)/fip/$(f)" "$(BINARIES_DIR)/"
	)
endef

$(eval $(generic-package))
