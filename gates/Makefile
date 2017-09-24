GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Gates
Gates_FILES = Gates.xm
Gates_FRAMEWORKS = QuartzCore UIKit
Gates_PRIVATE_FRAMEWORKS = Preferences
Gates_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences"
