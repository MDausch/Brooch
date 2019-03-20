include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Brooch
Brooch_FILES = Brooch.xm
Brooch_LIBRARIES = mdauschutils colorpicker

Brooch_CFLAGS = -fobjc-arc


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += brooch

include $(THEOS_MAKE_PATH)/aggregate.mk
