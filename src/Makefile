include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Membrane
Membrane_FILES = $(wildcard *.xm)
Membrane_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
