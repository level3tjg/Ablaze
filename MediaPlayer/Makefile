ARCHS = arm64

include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = MediaPlayer

# Don't copy to $THEOS/lib
THEOS_LIBRARY_PATH = -q

MediaPlayer_FILES = MediaPlayer.m
MediaPlayer_INSTALL_PATH = /Library/Frameworks
MediaPlayer_CFLAGS = -fobjc-arc
MediaPlayer_LDFLAGS = -Xlinker -reexport_library $(THEOS)/lib/MediaPlayer.framework/MediaPlayer

include $(THEOS_MAKE_PATH)/framework.mk
