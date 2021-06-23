include $(THEOS)/makefiles/common.mk

ARCHS = arm64

TOOL_NAME = postinst

postinst_FILES = main.m
postinst_FRAMEWORKS = MediaPlayer
postinst_CFLAGS = -fobjc-arc
postinst_CODESIGN_FLAGS = -Sentitlements.plist
postinst_INSTALL_PATH = /DEBIAN

include $(THEOS_MAKE_PATH)/tool.mk
