#import <UIKit/UIKit.h>
#import "ActionMenu.h"
#import <SpringBoard/SpringBoard.h>
#import <Preferences/Preferences.h>

#define PREFERENCE_PATH @"/var/mobile/Library/Preferences/jp.r-plus.amdaijirin.plist"
#define URL_SCHEME_BLACKLIST (![identifier isEqualToString:@"com.apple.Maps"] && ![identifier isEqualToString:@"com.apple.iBooks"])
//&& ![identifier isEqualToString:@"com.apple.mobilesafari"] 
#define DAIJIRIN_SCHEME_URL @"mkdaijirin://jp.monokakido.DAIJIRIN/search?text="
#define DAIJISEN_SCHEME_URL @"daijisen:operation=searchStartsWith;keyword="
#define WISDOM_SCHEME_URL @"mkwisdom://jp.monokakido.WISDOM/search?text="
#define EOW_SCHEME_URL @"eow://search?query="
#define SAFARI_SCHEME_URL @"x-web-search:///?"

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

@interface UIApplication (DaijirinGetSafariActiveURL)
- (id) activeURL;
@end

@interface UIResponder (Daijirin) <UIActionSheetDelegate>
@end

@implementation UIResponder (Daijirin)

- (void)didOpenURL:(NSString *)URLScheme
{
	NSString *selection = [self selectedTextualRepresentation];
	NSMutableString *string = [[NSMutableString alloc] initWithString:URLScheme];
	
	if ([selection length] > 0) {
		selection = [selection stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	NSString *scheme = nil;
	NSArray *URLTypes;
	NSDictionary *URLType;
	
	NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
	BOOL URLSchemeEnabled = [[prefsDict objectForKey:@"Enabled"] boolValue];
	
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	if ([identifier isEqualToString:@"com.apple.MobileSMS"]) { scheme = @"sms"; }
	
	if ([identifier isEqualToString:@"com.apple.mobilesafari"]) {
    scheme = [[UIApplication sharedApplication] activeURL];
	} else if ((URLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"])) {
		if ((URLType = [URLTypes lastObject])) {
			scheme = [[URLType objectForKey:@"CFBundleURLSchemes"] lastObject];
		}
	}
	
	if ( ( [string isEqualToString:DAIJIRIN_SCHEME_URL] || [string isEqualToString:WISDOM_SCHEME_URL] ) &&
			URLSchemeEnabled &&
			URL_SCHEME_BLACKLIST &&
		  scheme != nil) {
		if ([identifier isEqualToString:@"com.apple.mobilesafari"]){
			[string appendFormat:@"%@&srcname=%@&src=%@", selection, identifier, scheme];			
		} else {
			[string appendFormat:@"%@&srcname=%@&src=%@:", selection, identifier, scheme];
		}
	} else if (URLSchemeEnabled &&
						 URL_SCHEME_BLACKLIST &&
						 [string isEqualToString:EOW_SCHEME_URL] &&
						 scheme != nil) {
		if ([identifier isEqualToString:@"com.apple.mobilesafari"]){
			[string appendFormat:@"%@&src=%@&callback=%@", selection, identifier, scheme];
		} else {
			[string appendFormat:@"%@&src=%@&callback=%@:", selection, identifier, scheme];
		}
  } else if ([string isEqualToString:DAIJISEN_SCHEME_URL]) {
		[string appendFormat:@"%@;", selection];
		if (URLSchemeEnabled &&
				URL_SCHEME_BLACKLIST &&
				scheme != nil) {
			if ([identifier isEqualToString:@"com.apple.mobilesafari"]){
				[string appendFormat:@"appBackURL=%22%@%22;", scheme];
			} else {
				[string appendFormat:@"appBackURL=%22%@:%22;", scheme];
			}
		}
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

- (void)alertSheet:(UIActionSheet *)sheet buttonClicked:(int)button
{
	NSString *context = [sheet context];
	button--;
	NSString *title = [sheet buttonTitleAtIndex:button];
	button++;
	
	if ([context isEqualToString:@"amDaijirin"]) {
		if ([title isEqualToString:@"大辞林"]) {
			[self performSelector:@selector(didOpenURL:) withObject:DAIJIRIN_SCHEME_URL afterDelay:0];
		} else if ([title isEqualToString:@"大辞泉"]) {
			[self performSelector:@selector(didOpenURL:) withObject:DAIJISEN_SCHEME_URL afterDelay:0];
		} else if ([title isEqualToString:@"Wisdom"]) {
			[self performSelector:@selector(didOpenURL:) withObject:WISDOM_SCHEME_URL afterDelay:0];
		} else if ([title isEqualToString:@"EOW"]) {
			[self performSelector:@selector(didOpenURL:) withObject:EOW_SCHEME_URL afterDelay:0];
		} else if ([title isEqualToString:@"Safari"]) {
			[self performSelector:@selector(didOpenURL:) withObject:SAFARI_SCHEME_URL afterDelay:0];
		}
	}
	[sheet dismiss];
}

- (void)doDaijirin:(id)sender
{
	[self performSelector:@selector(showActionSheetForDaijirin:) withObject:self afterDelay:0];
}

- (void)showActionSheetForDaijirin:(id)sender
{
	NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
	if (!prefsDict){
		[self performSelector:@selector(didOpenURL:) withObject:DAIJIRIN_SCHEME_URL afterDelay:0];
	} else {
		int sheetStyle = [[prefsDict objectForKey:@"SheetStyle"] intValue];
		NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
		if ( [identifier isEqualToString:@"ch.reeder"] ) sheetStyle = 3;
		id sheet;
		
		if (sheetStyle != 3) {
			sheet = [[[UIActionSheet alloc] initWithTitle:@"Send to"
																					 delegate:self
																	cancelButtonTitle:nil
														 destructiveButtonTitle:nil
																	otherButtonTitles:nil]
							 autorelease];
			
			[sheet setAlertSheetStyle:sheetStyle];
		} else {
			sheet = [[[UIAlertView alloc] initWithTitle:@"Send to"
																					message:nil
																				 delegate:self
																cancelButtonTitle:nil
																otherButtonTitles:nil]
							 autorelease];
		}
		
		[sheet setContext:@"amDaijirin"];
		
		BOOL daijirinEnabled = [[prefsDict objectForKey:@"DaijirinEnabled"] boolValue];
		BOOL daijisenEnabled = [[prefsDict objectForKey:@"DaijisenEnabled"] boolValue];
		BOOL wisdomEnabled = [[prefsDict objectForKey:@"WisdomEnabled"] boolValue];
		BOOL eowEnabled = [[prefsDict objectForKey:@"EOWEnabled"] boolValue];
		BOOL safariEnabled = [[prefsDict objectForKey:@"SafariEnabled"] boolValue];
		
		if (daijirinEnabled) [sheet addButtonWithTitle:@"大辞林"];
		if (daijisenEnabled) [sheet addButtonWithTitle:@"大辞泉"];
		if (wisdomEnabled)   [sheet addButtonWithTitle:@"Wisdom"];
		if (eowEnabled)   [sheet addButtonWithTitle:@"EOW"];
		if (safariEnabled)   [sheet addButtonWithTitle:@"Safari"];
		[sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];
		
		int i = [sheet numberOfButtons];
		if (i == 1) {
			[self performSelector:@selector(didOpenURL:) withObject:DAIJIRIN_SCHEME_URL afterDelay:0];
		} else if (i == 2) {
			if (daijirinEnabled) [self performSelector:@selector(didOpenURL:) withObject:DAIJIRIN_SCHEME_URL afterDelay:0];
			if (daijisenEnabled) [self performSelector:@selector(didOpenURL:) withObject:DAIJISEN_SCHEME_URL afterDelay:0];
			if (wisdomEnabled) [self performSelector:@selector(didOpenURL:) withObject:WISDOM_SCHEME_URL afterDelay:0];
			if (eowEnabled) [self performSelector:@selector(didOpenURL:) withObject:EOW_SCHEME_URL afterDelay:0];
			if (safariEnabled) [self performSelector:@selector(didOpenURL:) withObject:SAFARI_SCHEME_URL afterDelay:0];
		} else if (i > 2){
			if (sheetStyle == 3){
				[sheet show];
			} else {
				[sheet showInView:sender];
			}
		}
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
