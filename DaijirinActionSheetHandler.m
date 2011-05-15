#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import "DaijirinActionSheetHandler.h"

#define URL_SCHEME_BLACKLIST (![identifier isEqualToString:@"com.apple.Maps"] && ![identifier isEqualToString:@"com.apple.iBooks"] && ![identifier isEqualToString:@"com.apple.mobilesafari"])
#define DAIJIRIN_SCHEME_URL @"mkdaijirin://jp.monokakido.DAIJIRIN/search?text="
#define DAIJISEN_SCHEME_URL @"daijisen:operation=searchStartsWith;keyword="
#define WISDOM_SCHEME_URL @"mkwisdom://jp.monokakido.WISDOM/search?text="
#define EOW_SCHEME_URL @"eow://search?query="
#define SAFARI_SCHEME_URL @"x-web-search:///?"

@implementation DaijirinActionSheetHandler

@synthesize selection, prefsDict;

- (void)alertSheet:(UIActionSheet *)sheet buttonClicked:(int)button
{
	NSString *context = [sheet context];
	button--;
	NSString *title = [sheet buttonTitleAtIndex:button];
	button++;
	
	if ([context isEqualToString:@"amDaijirin"]) {
		if ([title isEqualToString:@"大辞林"]) {
			[self didOpenURL:DAIJIRIN_SCHEME_URL];
		} else if ([title isEqualToString:@"大辞泉"]) {
			[self didOpenURL:DAIJISEN_SCHEME_URL];
		} else if ([title isEqualToString:@"Wisdom"]) {
			[self didOpenURL:WISDOM_SCHEME_URL];
		} else if ([title isEqualToString:@"EOW"]) {
			[self didOpenURL:EOW_SCHEME_URL];
		} else if ([title isEqualToString:@"Safari"]) {
			[self didOpenURL:SAFARI_SCHEME_URL];
		}
	}
	[sheet dismiss];
	sheet.delegate = nil;
}

- (void)didOpenURL:(NSString *)URLScheme
{
	NSMutableString *string = [[NSMutableString alloc] initWithString:URLScheme];
	
	if ([selection length] > 0) {
		selection = [selection stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	NSString *scheme = nil;
	NSArray *URLTypes;
	NSDictionary *URLType;
	
	BOOL URLSchemeEnabled = [[prefsDict objectForKey:@"Enabled"] boolValue] ?: YES;
	
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	if ([identifier isEqualToString:@"com.apple.MobileSMS"]) { scheme = @"sms"; }
	
	if ((URLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"])) {
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
	[self autorelease];
}

@end