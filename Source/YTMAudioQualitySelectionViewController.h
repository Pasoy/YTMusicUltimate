#import <UIKit/UIKit.h>

@protocol YTMAudioQualitySelectionDelegate <NSObject>
- (void)audioQualitySelected:(NSString *)quality;
@end

@interface YTMAudioQualitySelectionViewController : UITableViewController
@property (nonatomic, strong) UIImpactFeedbackGenerator *feedbackGenerator;
@property (nonatomic, strong) NSArray *qualities;
@property (nonatomic, strong) NSArray *qualityValues;
@property (nonatomic, assign) BOOL isDefaultQualitySelection;
@property (nonatomic, weak) id<YTMAudioQualitySelectionDelegate> delegate;
@end