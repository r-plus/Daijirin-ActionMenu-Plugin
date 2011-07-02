include theos/makefiles/common.mk

BUNDLE_NAME = Daijirin
Daijirin_FILES = Daijirin.m DaijirinActionSheetHandler.m DaijirinListController.m SBTableAlert.m
Daijirin_INSTALL_PATH = /Library/ActionMenu/Plugins
Daijirin_FRAMEWORKS = UIKit CoreGraphics
Daijirin_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk
