@interface DaijirinActionSheetHandler : NSObject <UIActionSheetDelegate> {
@private
	NSString *selection;
	NSDictionary *prefsDict;
}
@property (nonatomic, copy) NSString *selection;
@property (nonatomic, copy) NSDictionary *prefsDict;

- (void)didOpenURL:(NSString *)URLScheme;
@end