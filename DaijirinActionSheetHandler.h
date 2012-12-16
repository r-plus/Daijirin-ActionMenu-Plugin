#import "SBTableAlert.h"

@interface UIApplication(Private)
- (void)applicationOpenURL:(NSURL *)url;
@end

@interface UIActionSheet(Private)
- (id)context;
- (void)dismiss;// for alertView
@end

@interface DaijirinActionSheetHandler : NSObject <UIActionSheetDelegate, SBTableAlertDelegate, SBTableAlertDataSource> {
@private
	NSString *selection;
	NSDictionary *prefsDict;
	NSMutableArray *sheetTitles;
}
@property (nonatomic, copy) NSString *selection;
@property (nonatomic, copy) NSDictionary *prefsDict;

- (void)didOpenURL:(NSString *)URLScheme;
- (void)selectScheme:(NSString *)title;
- (void)sendSheet:(id)sheet;
@end
