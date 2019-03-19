include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Brooch
Brooch_FILES = Tweak.xm
Brooch_LIBRARIES = mdauschutils

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
