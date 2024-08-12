@interface YTMAudioQualitySelectionViewController : UITableViewController
@property (nonatomic, weak) id<AudioQualitySelectionDelegate> delegate;
@end

@protocol AudioQualitySelectionDelegate <NSObject>
- (void)audioQualitySelected:(NSString *)quality;
@end