#import <Preferences/Preferences.h>

__attribute__((visibility("hidden")))
@interface DaijirinListController: PSListController @end

@implementation DaijirinListController

- (void)updateSpecifier:(id)specifier {
	PSSpecifier* slaveSpecifier = [self specifierForID:@"SlaveToggle"];

	if ([[self readPreferenceValue:specifier] boolValue])
		[slaveSpecifier setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
	[self reloadSpecifier:slaveSpecifier];
}

- (void)setMasterToggle:(id)value specifier:(id)specifier { // thanks @Sakurina https://gist.github.com/1033214
  // You'd set the "set" property for your switch in your plist to
  // "setMasterToggle:specifier:" so this gets called
  [self setPreferenceValue:value specifier:specifier];
	
  BOOL boolValue = [value boolValue];
	
  // "SlaveToggle" is the ID of the toggle that depends on this switch
	
  PSSpecifier* slaveSpecifier = [self specifierForID:@"SlaveToggle"];
  if (!boolValue)
    [self setPreferenceValue:[NSNumber numberWithBool:NO] specifier:slaveSpecifier];
	[slaveSpecifier setProperty:[NSNumber numberWithBool:boolValue] forKey:@"enabled"];
	[self reloadSpecifier:slaveSpecifier];
	
  // Of course, you might want to split that behavior out into another method
  // you could call during your initializer otherwise it will remain enabled
  // when you first launch the prefs bundle.
	
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Daijirin" target:self] retain];
		[self updateSpecifier:[self specifierForID:@"ALCEnabledID"]];
	}
	return _specifiers;
}

- (void)github:(id)github {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/r-plus/Daijirin-ActionMenu-Plugin"]];
}
@end