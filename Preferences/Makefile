TARGET := iphone:clang:latest:14.0

ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AblazePreferences

AblazePreferences_FILES = AblazePreferencesRootListController.m
AblazePreferences_FRAMEWORKS = UIKit
AblazePreferences_PRIVATE_FRAMEWORKS = Preferences
AblazePreferences_INSTALL_PATH = /Library/PreferenceBundles
AblazePreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
