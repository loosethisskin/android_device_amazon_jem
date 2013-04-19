DEVICE_FOLDER := device/amazon/jem
TARGET_BOARD_OMAP_CPU := 4470

# inherit from common
-include device/amazon/bowser-common/BoardConfigCommon.mk

# inherit from the proprietary version
-include vendor/amazon/jem/BoardConfigVendor.mk

# Kernel Build
TARGET_KERNEL_SOURCE := kernel/amazon/bowser-common
TARGET_KERNEL_CONFIG := jem_android_defconfig

# Use the custom kernel toolchain to compile the external modules if one is defined
ifneq ($(TARGET_KERNEL_CUSTOM_TOOLCHAIN),)
    KERNEL_ARM_EABI_TOOLCHAIN="$(ANDROID_BUILD_TOP)/prebuilts/gcc/linux-x86/arm/$(TARGET_KERNEL_CUSTOM_TOOLCHAIN)/bin"
else
    KERNEL_ARM_EABI_TOOLCHAIN="$(ARM_EABI_TOOLCHAIN)"
endif

# External SGX Module
SGX_MODULES:
	make clean -C $(COMMON_FOLDER)/pvr-source/eurasiacon/build/linux2/omap4430_android
	cp $(TARGET_KERNEL_SOURCE)/drivers/video/omap2/omapfb/omapfb.h $(KERNEL_OUT)/drivers/video/omap2/omapfb/omapfb.h
	make -j8 -C $(COMMON_FOLDER)/pvr-source/eurasiacon/build/linux2/omap4430_android ARCH=arm KERNEL_CROSS_COMPILE=$(KERNEL_ARM_EABI_TOOLCHAIN)/arm-eabi- CROSS_COMPILE=$(KERNEL_ARM_EABI_TOOLCHAIN)/arm-eabi- KERNELDIR=$(KERNEL_OUT) TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=544sc PLATFORM_VERSION=4.0
	mv $(KERNEL_OUT)/../../target/kbuild/pvrsrvkm_sgx544_112.ko $(KERNEL_MODULES_OUT)
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/pvrsrvkm_sgx544_112.ko

TARGET_KERNEL_MODULES += SGX_MODULES

# OTA Packaging / Bootimg creation
BOARD_CUSTOM_BOOTIMG_MK := $(DEVICE_FOLDER)/boot.mk

# hack the ota
TARGET_RELEASETOOL_OTA_FROM_TARGET_SCRIPT := ./$(DEVICE_FOLDER)/releasetools/bowser_ota_from_target_files
# not tested at all
TARGET_RELEASETOOL_IMG_FROM_TARGET_SCRIPT := ./$(DEVICE_FOLDER)/releasetools/bowser_img_from_target_files

# TWRP Config
TARGET_OTA_ASSERT_DEVICE := blaze_tablet,bowser,jem
DEVICE_RESOLUTION := 1920x1200
RECOVERY_TOUCHSCREEN_SWAP_XY := true
RECOVERY_TOUCHSCREEN_FLIP_X := true
TW_IGNORE_DEVICE := MAX44007
