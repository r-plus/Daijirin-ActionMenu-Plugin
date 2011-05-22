#import <Preferences/Preferences.h>

__attribute__((visibility("hidden")))
@interface DaijirinListController: PSListController @end

@implementation DaijirinListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Daijirin" target:self] retain];
	}
	return _specifiers;
}

- (void)github:(id)github {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/r-plus/Daijirin-ActionMenu-Plugin"]];
}
@end