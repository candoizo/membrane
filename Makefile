export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2222

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += src
SUBPROJECTS += prefs
SUBPROJECTS += gates
include $(THEOS_MAKE_PATH)/aggregate.mk
