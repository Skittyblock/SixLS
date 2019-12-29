#DEBUG = 0
#FINALPACKAGE = 1

ARCHS = arm64 arm64e
TARGET = iphone:clang::11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SixLS
SixLS_CFLAGS = -fobjc-arc
SixLS_FILES = SIXNotificationAlertView.m SIXNotificationCell.m SIXLockScreenView.m SIXLockScreenViewController.m LockScreen.xm

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"
