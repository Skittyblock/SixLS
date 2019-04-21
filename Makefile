ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SixLS
SixLS_CFLAGS = -fobjc-arc
SixLS_FILES = SIXNotificationAlertView.m SIXNotificationCell.m SIXLockScreenView.m SIXLockScreenViewController.m LockScreen.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
