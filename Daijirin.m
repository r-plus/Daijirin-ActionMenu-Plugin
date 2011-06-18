#import <UIKit/UIKit.h>
#import "ActionMenu.h"
#import "DaijirinActionSheetHandler.h"

#define PREFERENCE_PATH @"/var/mobile/Library/Preferences/jp.r-plus.amdaijirin.plist"
#define DAIJIRIN_SCHEME_URL @"mkdaijirin://jp.monokakido.DAIJIRIN/search?text="
#define DAIJISEN_SCHEME_URL @"daijisen:operation=searchStartsWith;keyword="
#define WISDOM_SCHEME_URL @"mkwisdom://jp.monokakido.WISDOM/search?text="
#define EOW_SCHEME_URL @"eow://search?query="
#define EBPOCKET_SCHEME_URL @"ebpocket://search?text="
#define SAFARI_SCHEME_URL @"x-web-search:///?"
#define ALC_ORIGIN_OF_WORD_SCHEME_URL @"http://www.google.com/gwt/x?u=http://home.alc.co.jp/db/owa/etm_sch?instr="

@interface UIActionSheet (Daijirin)
- (void)setUseTwoColumnsButtonsLayout:(BOOL)arg1;
- (void)setTwoColumnsLayoutMode:(int)arg1;
- (void)setForceHorizontalButtonsLayout:(BOOL)arg1;
@end

@implementation UIView (Daijirin)

- (void)doDaijirin:(id)sender
{
	DaijirinActionSheetHandler *delegate = [[DaijirinActionSheetHandler alloc] init];
	delegate.selection = [self selectedTextualRepresentation];
	NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
	delegate.prefsDict = prefsDict;
	
	if (!prefsDict){
		[delegate didOpenURL:DAIJIRIN_SCHEME_URL];
		return;
	}
	
	int sheetStyle = 2;
	if([prefsDict objectForKey:@"SheetStyle"] != nil) sheetStyle = [[prefsDict objectForKey:@"SheetStyle"] intValue];
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	if ( [identifier isEqualToString:@"ch.reeder"] ) sheetStyle = 3;
	id sheet;
	
	if (sheetStyle != 3) {
		sheet = [[[UIActionSheet alloc] initWithTitle:@"Send to"
																				 delegate:delegate
																cancelButtonTitle:nil
													 destructiveButtonTitle:nil
																otherButtonTitles:nil]
						 autorelease];
		
		[sheet setAlertSheetStyle:sheetStyle];
	} else {
		sheet = [[[UIAlertView alloc] initWithTitle:@"Send to"
																				message:nil
																			 delegate:delegate
															cancelButtonTitle:nil
															otherButtonTitles:nil]
						 autorelease];
	}
	
	[sheet setContext:@"amDaijirin"];
	
	BOOL daijirinEnabled = YES;
	if([prefsDict objectForKey:@"DaijirinEnabled"] != nil) daijirinEnabled = [[prefsDict objectForKey:@"DaijirinEnabled"] boolValue];
	BOOL daijisenEnabled = [[prefsDict objectForKey:@"DaijisenEnabled"] boolValue];
	BOOL wisdomEnabled = [[prefsDict objectForKey:@"WisdomEnabled"] boolValue];
	BOOL eowEnabled = [[prefsDict objectForKey:@"EOWEnabled"] boolValue];
	BOOL ebpocketEnabled = [[prefsDict objectForKey:@"EBPocketEnabled"] boolValue];
	BOOL alcEnabled = [[prefsDict objectForKey:@"ALCEnabled"] boolValue];
	BOOL safariEnabled = [[prefsDict objectForKey:@"SafariEnabled"] boolValue];
	
	if (daijirinEnabled) [sheet addButtonWithTitle:@"大辞林"];
	if (daijisenEnabled) [sheet addButtonWithTitle:@"大辞泉"];
	if (wisdomEnabled)   [sheet addButtonWithTitle:@"Wisdom"];
	if (eowEnabled)   [sheet addButtonWithTitle:@"EOW"];
	if (ebpocketEnabled)   [sheet addButtonWithTitle:@"EBPocket"];
	if (alcEnabled)   [sheet addButtonWithTitle:@"ALC語源"];
	if (safariEnabled)   [sheet addButtonWithTitle:@"Safari"];
	[sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];
	
	int i = [sheet numberOfButtons];
	if (i == 1) {
		[delegate didOpenURL:DAIJIRIN_SCHEME_URL];
	} else if (i == 2) {
		if (daijirinEnabled) [delegate didOpenURL:DAIJIRIN_SCHEME_URL];
		if (daijisenEnabled) [delegate didOpenURL:DAIJISEN_SCHEME_URL];
		if (wisdomEnabled)   [delegate didOpenURL:WISDOM_SCHEME_URL];
		if (eowEnabled)      [delegate didOpenURL:EOW_SCHEME_URL];
		if (ebpocketEnabled) [delegate didOpenURL:EBPOCKET_SCHEME_URL];
		if (alcEnabled) [delegate didOpenURL:ALC_ORIGIN_OF_WORD_SCHEME_URL];
		if (safariEnabled)   [delegate didOpenURL:SAFARI_SCHEME_URL];
	} else if (i > 2){
		if (sheetStyle == 3) {
			if (i > 5) {
				[sheet setForceHorizontalButtonsLayout:YES];
				[sheet setNumberOfRows:4];
			}
			[sheet show];
		} else {
			if (i > 5) {
				[sheet setUseTwoColumnsButtonsLayout:YES];
				[sheet setTwoColumnsLayoutMode:2];
			}
			[sheet showInView:self];
		}
	}
}

- (BOOL)canDoDaijirin:(id)sender
{
	return ( [[self textualRepresentation] length] > 0 && [self respondsToSelector:@selector(selectAll)] ) ? YES : NO;
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
