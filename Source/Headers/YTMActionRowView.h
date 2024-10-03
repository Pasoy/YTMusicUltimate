#import <UIKit/UIKit.h>
#import "YTMNowPlayingViewController.h"
#import "YTMAudioQualitySelectionViewController.h"
#import "Headers/MDCButton.h"

@interface YTMActionRowView : UIView {
	UIScrollView *_scrollView;
	NSMutableArray *_actionButtons;
	NSMutableArray *_actionButtonsFromRenderers;
}

@property (nonatomic, weak, readonly) YTMNowPlayingViewController *parentResponder;

- (void)ytmuButtonAction:(MDCButton *)sender;
- (void)showAudioQualitySelection;
- (void)audioQualitySelected:(NSString *)quality;
- (void)downloadAudioWithQuality:(NSString *)quality;
- (void)downloadCoverImage;
@end