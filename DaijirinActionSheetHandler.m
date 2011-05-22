#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import "DaijirinActionSheetHandler.h"

#define URL_SCHEME_BLACKLIST (![identifier isEqualToString:@"com.apple.Maps"] && ![identifier isEqualToString:@"com.apple.iBooks"] && ![identifier isEqualToString:@"com.apple.mobilesafari"])
#define DAIJIRIN_SCHEME_URL @"mkdaijirin://jp.monokakido.DAIJIRIN/search?text="
#define DAIJISEN_SCHEME_URL @"daijisen:operation=searchStartsWith;keyword="
#define WISDOM_SCHEME_URL @"mkwisdom://jp.monokakido.WISDOM/search?text="
#define EOW_SCHEME_URL @"eow://search?query="
#define EBPOCKET_SCHEME_URL @"ebpocket://search?text="
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
		} else if ([title isEqualToString:@"EBPocket"]) {
			[self didOpenURL:EBPOCKET_SCHEME_URL];
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
	
	BOOL URLSchemeEnabled = YES;
	if ([prefsDict objectForKey:@"Enabled"] != nil) URLSchemeEnabled = [[prefsDict objectForKey:@"Enabled"] boolValue];
	
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	if ([identifier isEqualToString:@"com.apple.MobileSMS"]) { scheme = @"sms"; }
	
	if ((URLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"])) {
		if ((URLType = [URLTypes lastObject])) {
			scheme = [[URLType objectForKey:@"CFBundleURLSchemes"] lastObject];
		}
	}
	//daijirin and daijirin with returnURL.
	if ( ( [string isEqualToString:DAIJIRIN_SCHEME_URL] || [string isEqualToString:WISDOM_SCHEME_URL] ) &&
			URLSchemeEnabled &&
			URL_SCHEME_BLACKLIST &&
		  scheme != nil)
	{
		[string appendFormat:@"%@&srcname=%@&src=%@:", selection, identifier, scheme];
	}
	//EOW with returnURL.
	else if (URLSchemeEnabled &&
						 URL_SCHEME_BLACKLIST &&
						 [string isEqualToString:EOW_SCHEME_URL] &&
						 scheme != nil)
	{
		[string appendFormat:@"%@&src=%@&callback=%@:", selection, identifier, scheme];
  }
	//daijisen.
	else if ([string isEqualToString:DAIJISEN_SCHEME_URL])
	{
		[string appendFormat:@"%@;", selection];
		//daijisen append returnURL.
		if (URLSchemeEnabled &&
				URL_SCHEME_BLACKLIST &&
				scheme != nil)
		{
				[string appendFormat:@"appBackURL=%@:;", scheme];
		}
	}
	//EBPocket
	else if ([string isEqualToString:EBPOCKET_SCHEME_URL])
	{
		[string appendFormat:@"%@", selection];
		//EBPocket append returnURL.
		if (URLSchemeEnabled &&
				URL_SCHEME_BLACKLIST &&
				scheme != nil)
		{
			[string appendFormat:@"#%@:", scheme];
		}
	}
	else
	{ //all app except daijisen with no returnURL.
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