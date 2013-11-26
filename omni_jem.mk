# Inherit some common stuff.
$(call inherit-product, vendor/omni/config/common.mk)

# Inherit device configuration for bowser
$(call inherit-product, device/amazon/jem/full_jem.mk)
$(call inherit-product, device/amazon/bowser-common/omni_jem.mk)

#TARGET_SCREEN_WIDTH := 1920
TARGET_SCREEN_WIDTH := 480
TARGET_SCREEN_HEIGHT := 1200

PRODUCT_NAME := omni_jem
PRODUCT_DEVICE := jem
PRODUCT_MODEL := Amazon Kindle Fire HD
PRODUCT_RELEASE_NAME := KindleFireHD
PRODUCT_BRAND := google
PRODUCT_MANUFACTURER := Amazon
