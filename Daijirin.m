#import <UIKit/UIKit.h>
#import "ActionMenu.h"
#import <SpringBoard/SpringBoard.h>
#import <Preferences/Preferences.h>

#define PreferencePath @"/var/mobile/Library/Preferences/jp.r-plus.amdaijirin.plist"

@interface DaijirinListController: PSListController {
}
@end

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

@implementation UIView (Daijirin)

- (void) didOpenURL:(NSString *)URLScheme
{
	NSString *selection = [self selectedTextualRepresentation];
	NSMutableString *string = [[NSMutableString alloc] initWithString:URLScheme];
	
	if ([selection length] > 0) {
		selection = [selection stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	NSString *scheme = nil;
	NSArray *URLTypes;
	NSDictionary *URLType;

	if ((URLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"])) {
		if ((URLType = [URLTypes lastObject])) {
			scheme = [[URLType objectForKey:@"CFBundleURLSchemes"] lastObject];
		}
	}
	
	NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:PreferencePath];
	BOOL URLSchemeEnabled = [[prefsDict objectForKey:@"Enabled"] boolValue];
		
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	if ([identifier isEqualToString:@"com.apple.MobileSMS"]) { scheme = @"sms"; }
	
	if (URLSchemeEnabled &&
			![identifier isEqualToString:@"com.apple.mobilesafari"] &&
			![identifier isEqualToString:@"com.apple.Maps"] &&
			![identifier isEqualToString:@"com.apple.iBooks"] &&
			![string isEqualToString:@"http://www.google.com/m/search?q="] &&
		  scheme != nil) {
		[string appendFormat:@"%@&srcname=%@&src=%@:", selection, identifier, scheme];
	} else {
		[string appendFormat:@"%@",selection];
	}
	
	if ([identifier isEqualToString:@"com.apple.springboard"]){
		[[UIApplication sharedApplication] applicationOpenURL:[NSURL URLWithString:string]];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
	}
	[string release];
}

- (void) alertSheet:(UIActionSheet *)sheet buttonClicked:(int)button
{
	NSString *context = [sheet context];
	button--;
	NSString *title = [sheet buttonTitleAtIndex:button];
	button++;
	
	if ([context isEqualToString:@"amDaijirin"]) {
		if ([title isEqualToString:@"大辞林"]) {
			[self performSelector:@selector(didOpenURL:) withObject:@"mkdaijirin://jp.monokakido.DAIJIRIN/search?text=" afterDelay:0];			
		} else if ([title isEqualToString:@"Wisdom"]) {
			[self performSelector:@selector(didOpenURL:) withObject:@"mkwisdom://jp.monokakido.WISDOM/search?text=" afterDelay:0];
		} else if ([title isEqualToString:@"Google"]) {
			[self performSelector:@selector(didOpenURL:) withObject:@"http://www.google.com/m/search?q=" afterDelay:0];
		}
	}
	[sheet dismiss];
}

- (void)doDaijirin:(id)sender
{	
	UIActionSheet *sheet = [[[UIActionSheet alloc]
													 initWithTitle:@"Send to"
													 buttons:nil//[[NSArray arrayWithObjects:nil]//@"大辞林", @"Wisdom", @"Google", @"Cancel", nil]
													 defaultButtonIndex:3
													 delegate:self
													 context:@"amDaijirin"
													 ] autorelease];
	//	[sheet setBodyText:@"send to"];

	
	NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:PreferencePath];
	int numberOfRows = [[prefsDict objectForKey:@"NumberOfRows"] intValue];	
	BOOL daijirinEnabled = [[prefsDict objectForKey:@"DaijirinEnabled"] boolValue];
	BOOL wisdomEnabled = [[prefsDict objectForKey:@"WisdomEnabled"] boolValue];
	BOOL googleEnabled = [[prefsDict objectForKey:@"GoogleEnabled"] boolValue];

	[sheet setNumberOfRows:numberOfRows];
	if (daijirinEnabled) [sheet addButtonWithTitle:@"大辞林"];
	if (wisdomEnabled)   [sheet addButtonWithTitle:@"Wisdom"];
	if (googleEnabled)   [sheet addButtonWithTitle:@"Google"];
	[sheet setDefaultButton:(id)[sheet addButtonWithTitle:@"Cancel"]];
	
	int i = [sheet numberOfButtons];
	if (i == 2) {
		if (daijirinEnabled) [self performSelector:@selector(didOpenURL:) withObject:@"mkdaijirin://jp.monokakido.DAIJIRIN/search?text=" afterDelay:0];
		if (wisdomEnabled) [self performSelector:@selector(didOpenURL:) withObject:@"mkwisdom://jp.monokakido.WISDOM/search?text=" afterDelay:0];
		if (googleEnabled) [self performSelector:@selector(didOpenURL:) withObject:@"http://www.google.com/m/search?q=" afterDelay:0];
	} else if (!(i == 1)){
		[sheet popupAlertAnimated:YES];
	}
}

- (BOOL)canDoDaijirin:(id)sender
{
	return [self respondsToSelector:@selector(insertText:)];
}

+ (void)load
{
	static BOOL isPad;
	
	NSString* model = [[UIDevice currentDevice] model];
	isPad = [model isEqualToString:@"iPad"];
	
		id<AMMenuItem> daijirinMenu = [[UIMenuController sharedMenuController] registerAction:@selector(doDaijirin:) title:@"Daijirin" canPerform:@selector(canDoDaijirin:)];
		
		if (!isPad && [[UIScreen mainScreen] scale] == 2.0 ) {
			daijirinMenu.image = [[UIImage alloc] initWithContentsOfFile:@"/Library/ActionMenu/Plugins/Daijirin@2x.png"];
		} else {
			daijirinMenu.image = [[UIImage alloc] initWithContentsOfFile:@"/Library/ActionMenu/Plugins/Daijirin.png"];
		}
}

@end

// vim:ft=objc
