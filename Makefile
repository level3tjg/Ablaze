INSTALL_TARGET_PROCESSES = SpringBoard

TARGET = iphone:clang:latest

THEOS_DEVICE_IP = 192.168.1.103
THEOS_DEVICE_PORT = 22

ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Ablaze

Ablaze_FILES = $(shell find ./Tweak -name '*.mm' -o -name '*.xm')
Ablaze_CFLAGS = -fobjc-arc
Ablaze_FRAMEWORKS = Foundation CoreServices
Ablaze_PRIVATE_FRAMEWORKS = MediaRemote MediaPlayer MediaPlaybackCore

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Prefs
SUBPROJECTS += preinst
include $(THEOS_MAKE_PATH)/aggregate.mk

before-package::
	mv $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/Ablaze.dylib $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/zz_Ablaze.dylib
	mv $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/Ablaze.plist $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/zz_Ablaze.plist

