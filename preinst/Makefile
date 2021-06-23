TARGET := iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

ARCHS = arm64

TOOL_NAME = preinst

preinst_FILES = main.m $(shell find ../AFNetworking/AFNetworking -name "*.m") $(shell find ../ZipArchive/SSZipArchive -name "*.m") $(shell find ../ZipArchive/SSZipArchive/minizip -name "*.c")
preinst_CFLAGS = -fobjc-arc -I../AFNetworking -I../ZipArchive -DCOCOAPODS=1 -DPRIx64=\"llx\" -DHAVE_PKCRYPT -DHAVE_STDINT_H -DHAVE_WZAES -DHAVE_ZLIB
preinst_LIBRARIES = iconv
preinst_CODESIGN_FLAGS = -Sentitlements.plist
preinst_INSTALL_PATH = /DEBIAN

include $(THEOS_MAKE_PATH)/tool.mk
