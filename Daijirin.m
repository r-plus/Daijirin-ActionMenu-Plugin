#import <UIKit/UIKit.h>
#import "ActionMenu.h"
#import "DaijirinActionSheetHandler.h"
#import "SBTableAlert.h"
#import "define.h"

@interface UIActionSheet (Daijirin)
  - (void)setUseTwoColumnsButtonsLayout:(BOOL)arg1;
  - (void)setTwoColumnsLayoutMode:(int)arg1;
  - (void)setForceHorizontalButtonsLayout:(BOOL)arg1;
  @end

  /*
     typedef enum {
     UIActionSheetStyleAutomatic        = -1,
     UIActionSheetStyleDefault          = UIBarStyleDefault,
     UIActionSheetStyleBlackTranslucent = UIBarStyleBlackTranslucent,
     UIActionSheetStyleBlackOpaque      = UIBarStyleBlackOpaque,
     } UIActionSheetStyle;
   */
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
  if ([prefsDict objectForKey:@"SheetStyle"] != nil) sheetStyle = [[prefsDict objectForKey:@"SheetStyle"] intValue];
  NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
  if ([identifier isEqualToString:@"ch.reeder"]) sheetStyle = 3;// UIAlertView
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
  BOOL kojienEnabled = [[prefsDict objectForKey:@"KojienEnabled"] boolValue];
  BOOL wisdomEnabled = [[prefsDict objectForKey:@"WisdomEnabled"] boolValue];
  BOOL eowEnabled = [[prefsDict objectForKey:@"EOWEnabled"] boolValue];
  BOOL ebpocketEnabled = [[prefsDict objectForKey:@"EBPocketEnabled"] boolValue];
  BOOL gurudicEnabled = [[prefsDict objectForKey:@"GuruDicEnabled"] boolValue];
  BOOL midoriEnabled = [[prefsDict objectForKey:@"MidoriEnabled"] boolValue];
  BOOL pocketProgEJEnabled = [[prefsDict objectForKey:@"PocketProgressiveEJEnabled"] boolValue];
  BOOL progressiveEEnabled = [[prefsDict objectForKey:@"ProgressiveEEnabled"] boolValue];
  BOOL cobuildEEEnabled = [[prefsDict objectForKey:@"COBUILDEEEnabled"] boolValue];
  BOOL cobuildEEJEnabled = [[prefsDict objectForKey:@"COBUILDEEJEnabled"] boolValue];
  BOOL longmanEJEnabled = [[prefsDict objectForKey:@"LongmanEJEnabled"] boolValue];
  BOOL longmanEEEnabled = [[prefsDict objectForKey:@"LongmanEEEnabled"] boolValue];
  BOOL kotobaEnabled = [[prefsDict objectForKey:@"KotobaEnabled"] boolValue];
  BOOL ruigoEnabled = [[prefsDict objectForKey:@"KadokawaRuigoEnabled"] boolValue];
  BOOL alcEnabled = [[prefsDict objectForKey:@"ALCEnabled"] boolValue];
  BOOL exciteEnabled = [[prefsDict objectForKey:@"ExciteEnabled"] boolValue];
  BOOL googleTranslateEnabled = [[prefsDict objectForKey:@"GoogleTranslateEnabled"] boolValue];
  BOOL fasteverEnabled = [[prefsDict objectForKey:@"FastEverEnabled"] boolValue];
  BOOL pdicoEnabled = [[prefsDict objectForKey:@"PdicoEnabled"] boolValue];
  BOOL safariEnabled = [[prefsDict objectForKey:@"SafariEnabled"] boolValue];

  if (daijirinEnabled) [sheet addButtonWithTitle:@"大辞林"];
  if (daijisenEnabled) [sheet addButtonWithTitle:@"大辞泉"];
  if (kojienEnabled) [sheet addButtonWithTitle:@"広辞苑"];
  if (wisdomEnabled)   [sheet addButtonWithTitle:@"Wisdom"];
  if (eowEnabled)   [sheet addButtonWithTitle:@"EOW"];
  if (ebpocketEnabled)   [sheet addButtonWithTitle:@"EBPocket"];
  if (gurudicEnabled)   [sheet addButtonWithTitle:@"GuruDic"];
  if (midoriEnabled)   [sheet addButtonWithTitle:@"Midori"];
  if (pocketProgEJEnabled)   [sheet addButtonWithTitle:@"ポケプロ"];
  if (progressiveEEnabled)   [sheet addButtonWithTitle:@"Progressive"];
  if (cobuildEEEnabled)   [sheet addButtonWithTitle:@"CoBuild-EE"];
  if (cobuildEEJEnabled)   [sheet addButtonWithTitle:@"CoBuild-EEJ"];
  if (longmanEJEnabled)   [sheet addButtonWithTitle:@"ロングマン英和"];
  if (longmanEEEnabled)   [sheet addButtonWithTitle:@"ロングマン英英"];
  if (kotobaEnabled)   [sheet addButtonWithTitle:@"Kotoba!"];
  if (ruigoEnabled)   [sheet addButtonWithTitle:@"角川類語"];
  if (alcEnabled)   [sheet addButtonWithTitle:@"ALC語源"];
  if (exciteEnabled)   [sheet addButtonWithTitle:@"Excite"];
  if (googleTranslateEnabled)   [sheet addButtonWithTitle:@"Google"];
  if (fasteverEnabled)   [sheet addButtonWithTitle:@"FastEver"];
  if (pdicoEnabled) [sheet addButtonWithTitle:@"pdico"];
  if (safariEnabled)   [sheet addButtonWithTitle:@"Safari"];
  [sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];

  int i = [sheet numberOfButtons];
  if (i == 1) {
    [delegate didOpenURL:DAIJIRIN_SCHEME_URL];
  } else if (i == 2) {
    if (daijirinEnabled)      [delegate didOpenURL:DAIJIRIN_SCHEME_URL];
    if (daijisenEnabled)      [delegate didOpenURL:DAIJISEN_SCHEME_URL];
    if (kojienEnabled)        [delegate didOpenURL:KOJIEN_SCHEME_URL];
    if (wisdomEnabled)        [delegate didOpenURL:WISDOM_SCHEME_URL];
    if (eowEnabled)           [delegate didOpenURL:EOW_SCHEME_URL];
    if (ebpocketEnabled)      [delegate didOpenURL:EBPOCKET_SCHEME_URL];
    if (gurudicEnabled)       [delegate didOpenURL:GURUDIC_SCHEME_URL];
    if (midoriEnabled)        [delegate didOpenURL:MIDORI_SCHEME_URL];
    if (pocketProgEJEnabled)  [delegate didOpenURL:POCKET_PROGRESSIVE_EJ_SCHEME_URL];
    if (progressiveEEnabled)  [delegate didOpenURL:PROGRESSIVEE_SCHEME_URL];
    if (cobuildEEEnabled)     [delegate didOpenURL:COBUILD_EE_SCHEME_URL];
    if (cobuildEEJEnabled)    [delegate didOpenURL:COBUILD_EEJ_SCHEME_URL];
    if (longmanEJEnabled)     [delegate didOpenURL:LONGMAN_EJ_SCHEME_URL];
    if (longmanEEEnabled)     [delegate didOpenURL:LONGMAN_EE_SCHEME_URL];
    if (kotobaEnabled)        [delegate didOpenURL:KOTOBA_SCHEME_URL];
    if (ruigoEnabled)         [delegate didOpenURL:RUIGO_SCHEME_URL];
    if (alcEnabled)           [delegate didOpenURL:ALC_ORIGIN_OF_WORD_SCHEME_URL];
    if (exciteEnabled)        [delegate didOpenURL:EXCITE_SCHEME_URL];
    if (googleTranslateEnabled)        [delegate didOpenURL:GOOGLE_SCHEME_URL];
    if (fasteverEnabled) {
      if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:FASTEVERXL_SCHEME_URL]])
        [delegate didOpenURL:FASTEVERXL_SCHEME_URL];
      else
        [delegate didOpenURL:FASTEVER_SCHEME_URL];
    }
    if (pdicoEnabled)        [delegate didOpenURL:PDICO_SCHEME_URL];
    if (safariEnabled)        [delegate didOpenURL:SAFARI_SCHEME_URL];
  } else if (i > 2){
    if (sheetStyle == 3) {
      if (i >= 9) {
        SBTableAlert *alert;
        /*
           alert	= [[SBTableAlert alloc] initWithTitle:@"Single Select" cancelButtonTitle:@"Cancel" messageFormat:nil];
           [alert.view setTag:1];
         */
        //Apple Style
        alert	= [[SBTableAlert alloc] initWithTitle:@"Send to" cancelButtonTitle:@"Cancel" messageFormat:nil];
        [alert.view setTag:2];
        [alert setStyle:SBTableAlertStyleApple];

        [alert setDelegate:delegate];
        [alert setDataSource:delegate];

        [delegate sendSheet:sheet];
        [alert show];

        //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
      }
      if (9 > i && i > 5) {
        [sheet setForceHorizontalButtonsLayout:YES];
        [sheet setNumberOfRows:4];
      }
      [sheet show];
    } else {
      NSString* model = [[UIDevice currentDevice] model];
      BOOL isPad = [model isEqualToString:@"iPad"];

      if (!isPad && 14 > i && i > 5) {
        [sheet setUseTwoColumnsButtonsLayout:YES];
        [sheet setTwoColumnsLayoutMode:2];
      }
      [sheet showInView:[[UIApplication sharedApplication] keyWindow]];
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
