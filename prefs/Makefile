include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MembranePrefs
MembranePrefs_FILES = MembranePrefsController.m #LOCALMembrane.m
MembranePrefs_INSTALL_PATH = /Library/PreferenceBundles
MembranePrefs_FRAMEWORKS = UIKit CoreGraphics QuartzCore
MembranePrefs_PRIVATE_FRAMEWORKS = Social Preferences
MembranePrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MembranePrefs.plist$(ECHO_END)
