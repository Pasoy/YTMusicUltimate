#import <UIKit/UIKit.h>
#import "../Headers/Localization.h"
#import "../YTMAudioQualitySelectionViewController.h"

@interface PlayerSettingsController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, YTMAudioQualitySelectionDelegate>
@property (nonatomic, strong) UITableView* tableView;
- (UIView *)KBToolbar:(UITextField *)textField;
@end