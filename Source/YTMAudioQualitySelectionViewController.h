#import <UIKit/UIKit.h>

@protocol YTMAudioQualitySelectionDelegate <NSObject>
- (void)audioQualitySelected:(NSString *)quality;
@end

@interface YTMAudioQualitySelectionViewController : UITableViewController
@property (nonatomic, weak) id<YTMAudioQualitySelectionDelegate> delegate;
@end