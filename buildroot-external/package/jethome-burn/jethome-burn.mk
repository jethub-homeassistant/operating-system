
################################################################################
#
# jethome-burn
#
################################################################################

JETHOME_BURN_VERSION = 87be932dceb6135c99dfc5a105a6345eff954f2c
#8d56980a5eabff379bfaf24b6eba0badae4b6a05
#3ffa2d05f41ed92888d413a0f8cee08cefcbd240
#b147825d93a5b4cb6db46a72630b676a9eb07a2d
#b573f5581c3f8c30d980dc9b37f21694b8740452
#1637ad52cd62c13c81f30355984a29901c134ebf
JETHOME_BURN_SITE = https://github.com/jethome-ru/jethome-tools
JETHOME_BURN_SITE_METHOD = git
JETHOME_BURN_INSTALL_IMAGES = YES

#JETHOME_BURN_DEPENDENCIES =

JETHOME_BURN_LICENSE = PROPRIETARY
JETHOME_BURN_REDISTRIBUTE = NO

ifeq ($(BR2_PACKAGE_JETHOME_BURN),y)

ifeq ($(call qstrip,$(BR2_PACKAGE_JETHOME_BURN_BOARD)),)
$(error No board u-boot firmware config name specified, check your BR2_PACKAGE_JETHOME_BURN_BOARD setting)
else

ifeq ($(call qstrip,$(BR2_PACKAGE_JETHOME_BURN_BOARD)),jethubj100)
    BR2_PACKAGE_JETHOME_BURN_BOARD_DIR = j100
    BR2_PACKAGE_JETHOME_BURN_DTS = "meson-axg-jethome-jethub-j100.dts"
endif

ifeq ($(call qstrip,$(BR2_PACKAGE_JETHOME_BURN_BOARD)),jethubj200)
    BR2_PACKAGE_JETHOME_BURN_BOARD_DIR = j200
    BR2_PACKAGE_JETHOME_BURN_DTS = "meson-sm1-jethome-jethub-j200.dts"
endif

ifeq ($(call qstrip,$(BR2_PACKAGE_JETHOME_BURN_BOARD)),jethubj80)
    BR2_PACKAGE_JETHOME_BURN_BOARD_DIR = j80
    BR2_PACKAGE_JETHOME_BURN_DTS = "meson-gxl-s905w-jethome-jethub-j80.dts"
endif

endif # qstrip BR2_PACKAGE_JETHOME_BURN_BOARD

ifeq ($(call qstrip,$(BR2_PACKAGE_JETHOME_BURN_BOARD_DIR)),)
$(error No board u-boot firmware config name exist, check your BR2_PACKAGE_JETHOME_BURN_BOARD setting, available: jethubj100, jethubj80. got:$(BR2_PACKAGE_JETHOME_BURN_BOARD) )
endif

endif


JETHOME_BURN_BINS +=  dtbtools/dtbTool tools/aml_image_v2_packer_new
JETHOME_BURN_DATA += bins/$(BR2_PACKAGE_JETHOME_BURN_BOARD_DIR)/DDR.USB bins/$(BR2_PACKAGE_JETHOME_BURN_BOARD_DIR)/UBOOT.USB bins/$(BR2_PACKAGE_JETHOME_BURN_BOARD_DIR)/platform.conf

define JETHOME_BURN_BUILD_CMDS
    cd $(@D)/dtbtools ; make dtbTool
endef

define JETHOME_BURN_INSTALL_IMAGES_CMDS
	$(foreach f,$(JETHOME_BURN_BINS), \
            cp -dpf "$(@D)/$(f)" "$(HOST_DIR)/bin/"
	)
	$(foreach f,$(JETHOME_BURN_DATA), \
            cp -dpf "$(@D)/$(f)" "$(BINARIES_DIR)/"
	)
    cp -dprf "$(@D)/dts" "$(BINARIES_DIR)/"
    cp -dprf "$(@D)/dts/$(BR2_PACKAGE_JETHOME_BURN_DTS)" "$(BINARIES_DIR)/dts/board.dts"
endef


$(eval $(generic-package))

