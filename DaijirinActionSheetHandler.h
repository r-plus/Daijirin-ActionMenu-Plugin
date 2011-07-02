#import "SBTableAlert.h"

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