#import <UIKit/UIKit.h>

@interface QTMButton : UIButton
@property (nonatomic, copy, readwrite) NSString *accessibilityIdentifier;
@end

@interface YTQTMButton : QTMButton
- (void)setSizeWithPaddingAndInsets:(BOOL)sizeWithPaddingAndInsets;
@end