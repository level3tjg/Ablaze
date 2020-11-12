include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

BUNDLE_NAME = AblazePrefs

AblazePrefs_FILES = ABRootListController.m
AblazePrefs_INSTALL_PATH = /Library/PreferenceBundles
AblazePrefs_FRAMEWORKS = UIKit
AblazePrefs_PRIVATE_FRAMEWORKS = Preferences
AblazePrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AblazePrefs.plist$(ECHO_END)
