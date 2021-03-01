include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SixLS
SixLS_FILES = $(wildcard *.m) $(wildcard SkittyPrefs/*.m)
SixLS_INSTALL_PATH = /Library/PreferenceBundles
SixLS_PRIVATE_FRAMEWORKS = Preferences
SixLS_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist$(ECHO_END)
