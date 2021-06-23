ARCHS = arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = AblazeUIService

AblazeUIService_FILES = main.m AblazeViewController.m
AblazeUIService_FRAMEWORKS = UIKit MediaPlayer
AblazeUIService_PRIVATE_FRAMEWORKS = MediaRemote
AblazeUIService_CFLAGS = -fobjc-arc -I..
AblazeUIService_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/application.mk
