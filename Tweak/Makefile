ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Ablaze

Ablaze_FILES = Tweak.x SpringBoard.x MusicApplication.xm AblazeRemoteViewController.m UIView+Recursion.m Music.x Spotify.x Tidal.x # LockScreen.x LSBackground.x LSPlayer.x
Ablaze_LIBRARIES = mryipc
Ablaze_PRIVATE_FRAMEWORKS = MediaRemote MediaPlayer MediaPlaybackCore
Ablaze_CFLAGS = -fobjc-arc -I..

include $(THEOS_MAKE_PATH)/tweak.mk
