include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Brooch
Brooch_FILES = MDBroochRootListController.m HBTwitterCell.m HBLinkTableCell.m HBTintedTableCell.m
Brooch_INSTALL_PATH = /Library/PreferenceBundles
Brooch_FRAMEWORKS = UIKit
Brooch_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Brooch.plist$(ECHO_END)
