#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import "DaijirinActionSheetHandler.h"
#import "SBTableAlert.h"
#import "define.h"

@implementation DaijirinActionSheetHandler

@synthesize selection, prefsDict;

- (void)selectScheme:(NSString *)title
{
	if ([title isEqualToString:@"大辞林"])
		[self didOpenURL:DAIJIRIN_SCHEME_URL];
	else if ([title isEqualToString:@"大辞泉"])
		[self didOpenURL:DAIJISEN_SCHEME_URL];
	else if ([title isEqualToString:@"広辞苑"])
		[self didOpenURL:KOJIEN_SCHEME_URL];
	else if ([title isEqualToString:@"Wisdom"])
		[self didOpenURL:WISDOM_SCHEME_URL];
	else if ([title isEqualToString:@"EOW"])
		[self didOpenURL:EOW_SCHEME_URL];
	else if ([title isEqualToString:@"EBPocket"])
		[self didOpenURL:EBPOCKET_SCHEME_URL];
	else if ([title isEqualToString:@"GuruDic"])
		[self didOpenURL:GURUDIC_SCHEME_URL];
	else if ([title isEqualToString:@"Midori"])
		[self didOpenURL:MIDORI_SCHEME_URL];
	else if ([title isEqualToString:@"ポケプロ"])
		[self didOpenURL:POCKET_PROGRESSIVE_EJ_SCHEME_URL];
	else if ([title isEqualToString:@"ロングマン英和"])
		[self didOpenURL:LONGMAN_EJ_SCHEME_URL];
	else if ([title isEqualToString:@"ロングマン英英"])
		[self didOpenURL:LONGMAN_EE_SCHEME_URL];
	else if ([title isEqualToString:@"Dictionary.com"])
		[self didOpenURL:DICTIONARYCOM_SCHEME_URL];
	else if ([title isEqualToString:@"Kotoba!"])
		[self didOpenURL:KOTOBA_SCHEME_URL];
	else if ([title isEqualToString:@"角川類語"])
		[self didOpenURL:RUIGO_SCHEME_URL];
	else if ([title isEqualToString:@"ALC語源"])
		[self didOpenURL:ALC_ORIGIN_OF_WORD_SCHEME_URL];
	else if ([title isEqualToString:@"Excite"])
		[self didOpenURL:EXCITE_SCHEME_URL];
	else if ([title isEqualToString:@"Google"])
		[self didOpenURL:GOOGLE_SCHEME_URL];
	else if ([title isEqualToString:@"Safari"])
		[self didOpenURL:SAFARI_SCHEME_URL];
	else
		[self autorelease];
}

- (void)alertSheet:(UIActionSheet *)sheet buttonClicked:(int)button
{
	NSString *context = [sheet context];
	button--;
	NSString *title = [sheet buttonTitleAtIndex:button];
	button++;
	
	if ([context isEqualToString:@"amDaijirin"])
		[self selectScheme:title];
	
	[sheet dismiss];
	sheet.delegate = nil;
}

- (void)didOpenURL:(NSString *)URLScheme
{
	NSMutableString *string = [[NSMutableString alloc] initWithString:URLScheme];
	
	NSString *rawString = [selection copy];// for Daijisen
	if ([selection length] > 0 && ![string isEqualToString:EXCITE_SCHEME_URL])
		selection = [selection stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString *scheme = nil;
	NSArray *URLTypes;
	NSDictionary *URLType;
	
	BOOL URLSchemeEnabled = YES;
	if ([prefsDict objectForKey:@"Enabled"] != nil)
		URLSchemeEnabled = [[prefsDict objectForKey:@"Enabled"] boolValue];
	
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	if ([identifier isEqualToString:@"com.apple.MobileSMS"])
		scheme = @"sms";
	
	if ((URLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"]))
		if ((URLType = [URLTypes lastObject]))
			scheme = [[URLType objectForKey:@"CFBundleURLSchemes"] lastObject];

	//daijirin, ruigo and wisdom with returnURL.
	if ( ( [string isEqualToString:DAIJIRIN_SCHEME_URL] || [string isEqualToString:WISDOM_SCHEME_URL] || [string isEqualToString:RUIGO_SCHEME_URL] )
			&& URLSchemeEnabled
			&& URL_SCHEME_BLACKLIST
		  && scheme != nil)
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
		NSMutableDictionary *param;
    param = [NSMutableDictionary dictionary];
		[param setObject:rawString forKey:@"keyword"];
		//daijisen append returnURL.
		if (URLSchemeEnabled &&
				URL_SCHEME_BLACKLIST &&
				scheme != nil)
		{
			[param setObject:[scheme stringByAppendingString:@":"] forKey:@"appBackURL"];
		}

		NSMutableString *urlString;
    urlString = [NSMutableString stringWithString:
								 [[param description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // Add scheme
    [urlString insertString:[NSString stringWithFormat:@"%@:", @"daijisen"] atIndex:0];
		// Copy string
		[string deleteCharactersInRange:NSMakeRange(0,[string length])];
		string = [urlString copy];
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
	//ALC_語源
	else if ([string isEqualToString:ALC_ORIGIN_OF_WORD_SCHEME_URL])
	{		
		if ([[prefsDict objectForKey:@"ALCMobilizerEnabled"] boolValue]) {
			[string appendFormat:@"%@%@stg=1&noimg=1", selection, @"%26"];
		} else {
			[string deleteCharactersInRange:NSMakeRange(0,[string length])];
			[string appendFormat:@"http://home.alc.co.jp/db/owa/etm_sch?instr=%@&stg=1" , selection];
		}
	}
	else if (![string isEqualToString:EXCITE_SCHEME_URL])
	{ //(NO returnURLScheme) all app except daijisen.
		[string appendFormat:@"%@",selection];
	}
	
	//Append Longman
	if ([string isEqualToString:LONGMAN_EE_SCHEME_URL] || [string isEqualToString:LONGMAN_EJ_SCHEME_URL]){
		[string appendString:@"?exact=on"];
		if (URLSchemeEnabled)
			[string appendFormat:@"&back=%@:", scheme];
	}
	
  // clipboard for excite
  if ([string isEqualToString:EXCITE_SCHEME_URL]) {
    static NSString *const PasteboardName = @"jp.co.excite.translate";
    UIPasteboard *pb = [UIPasteboard pasteboardWithName:PasteboardName create:YES];
    if (pb.changeCount < 0) {
      [UIPasteboard removePasteboardWithName:PasteboardName];
      pb = [UIPasteboard pasteboardWithName:PasteboardName create:YES];
    }
    pb.persistent = YES;
    [pb setString:selection];
  }
  
  // openURL
	if ([identifier isEqualToString:@"com.apple.springboard"])
		[[UIApplication sharedApplication] applicationOpenURL:[NSURL URLWithString:string]];
	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];

	[string release];
	[self release];
  self = nil;
}

- (void)sendSheet:(id)sheet
{
	NSInteger numberOfButtons = [sheet numberOfButtons] -1;
	sheetTitles = [[NSMutableArray alloc] init];
	
	for (NSInteger i=0; i<numberOfButtons; i++)
		[sheetTitles addObject:[sheet buttonTitleAtIndex:i]];
}

#pragma mark - SBTableAlertDataSource

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRow:(NSInteger)row {
	UITableViewCell *cell;
	
//	if (tableAlert.view.tag == 0 || tableAlert.view.tag == 1) {
//		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
//	} else if (tableAlert.view.tag == 2) {
		// Note: SBTableAlertCell
		cell = [[[SBTableAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
//	}
	
	[cell.textLabel setText:[sheetTitles objectAtIndex:row]];
	
	return cell;
}

- (NSInteger)numberOfRowsInTableAlert:(SBTableAlert *)tableAlert {
//	if (tableAlert.type == SBTableAlertTypeSingleSelect)
		return [sheetTitles count];
	/*
	else
		return 10;
	*/
}

#pragma mark - SBTableAlertDelegate

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRow:(NSInteger)row {
/*
	if (tableAlert.type == SBTableAlertTypeMultipleSelct) {
		UITableViewCell *cell = [tableAlert.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
		if (cell.accessoryType == UITableViewCellAccessoryNone)
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		else
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		
		[tableAlert.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES];
	}
*/
	NSString *dictTitle = [tableAlert.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]].textLabel.text;
	[self retain];
	[self selectScheme:dictTitle];	
}

- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[tableAlert release];
	[sheetTitles release];
}

@end
