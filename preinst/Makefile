TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

TOOL_NAME = preinst

preinst_FILES = main.m
preinst_CFLAGS = -fobjc-arc
preinst_FRAMEWORKS = CoreServices
preinst_CODESIGN_FLAGS = -Sentitlements.plist
preinst_INSTALL_PATH = /DEBIAN

include $(THEOS_MAKE_PATH)/tool.mk
