include $(THEOS)/makefiles/common.mk

export ARCHS = arm64 arm64e armv7 armv7s

TWEAK_NAME = ChatHeadsClient
ChatHeadsClient_FILES = Tweak.xm ../MessageHeadsXI/MHWindowManager.m
ChatHeadsClient_LIBRARIES = rocketbootstrap
ChatHeadsClient_FRAMEWORKS = Foundation UIKit
ChatHeadsClient_PRIVATEFRAMEWORKS = Preferences AppSupport
ChatHeadsClient_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
