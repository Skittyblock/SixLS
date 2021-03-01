INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SixLS
SixLS_FILES = $(wildcard *.swift) $(wildcard *.m) Tweak.x
SixLS_PRIVATE_FRAMEWORKS = UserNotificationsKit
SixLS_CFLAGS = -fobjc-arc -I./Headers
SixLS_SWIFTFLAGS += -DTWEAK

include $(THEOS_MAKE_PATH)/tweak.mk
