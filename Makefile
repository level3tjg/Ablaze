export TARGET = iphone:clang:latest:14.0

THEOS_DEVICE_IP = 10.12.3.128

include $(THEOS)/makefiles/common.mk
SUBPROJECTS += AblazeUIService
SUBPROJECTS += Tweak
SUBPROJECTS += MediaPlayer
SUBPROJECTS += preinst
SUBPROJECTS += postinst
SUBPROJECTS += preferences
include $(THEOS_MAKE_PATH)/aggregate.mk

before-package::
	cp layout/DEBIAN/prerm $(THEOS_STAGING_DIR)/DEBIAN/prerm
