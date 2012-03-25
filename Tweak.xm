#define kURLScheme "googletranslate://amdaijirin?q="

@interface TextTranslator : NSObject <UIApplicationDelegate>
- (id)initWithDelegate:(id)delegate userInfo:(id)info translateText:(id)text fromLanguage:(id)language toLanguage:(id)language5 localeLanguage:(id)language6;
- (void)start;
@end

@interface TranslateViewController : UIViewController
- (void)returnToHomeView;
- (void)showHomePage:(BOOL)show;
- (void)showResultPage:(BOOL)show;
- (void)transitionToViewState:(int)viewState animated:(BOOL)animated;
@end

@interface TranslateAppDelegate : NSObject <UIApplicationDelegate>
@property(readonly, assign, nonatomic) TranslateViewController *translateViewController;
@end

%hook TranslateAppDelegate
%new(c@:@@@@)
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)application3 annotation:(id)annotation
{
  NSString *urlString = [url absoluteString];
  if ([urlString hasPrefix:@kURLScheme]) {
    NSString *query = [urlString substringFromIndex:[@kURLScheme length]];
    NSString *decodedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
        kCFAllocatorDefault,
        (CFStringRef)query,
        CFSTR(""),
        kCFStringEncodingUTF8);
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [[languages objectAtIndex:0] substringToIndex:2];

    TextTranslator *tt = [[%c(TextTranslator) alloc] initWithDelegate:self.translateViewController
                                                             userInfo:nil
                                                        translateText:decodedString
                                                         fromLanguage:@"auto"
                                                           toLanguage:currentLanguage
                                                       localeLanguage:@"en"];
    [tt start];
    [self.translateViewController returnToHomeView];
    [decodedString release];
    return YES;
  } else {
    return NO;
  }
}
%end
