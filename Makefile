export ARCHS = arm64 arm64e
export TARGET = iphone:clang::11.0

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += tweak prefs

include $(THEOS_MAKE_PATH)/aggregate.mk
