#import <UIKit/UIKit.h>

@interface YTMNavigationBarView : UIView
- (void)sortButtonTapped:(id)sender;
- (void)updateSortButtonVisibility:(NSNotification *)notification;

- (void)addRightButton:(UIButton *)button;
- (void)addFarthestRightButton:(UIButton *)button;
- (void)resetButtons;
- (void)resetLeftButtons;
- (void)resetRightButtons;
- (void)setTitle:(NSString *)title;
- (void)setTitleHidden:(BOOL)hidden;
- (void)setTitleAlpha:(CGFloat)alpha;
- (void)setTitleView:(UIView *)titleView;
- (void)setIconHeaderView:(UIView *)iconHeaderView;
- (void)setMusicLogoVisible:(BOOL)visible;
- (void)setAdjustedLeftPadding:(CGFloat)padding;
- (void)setLeftButtonsFromAppHeaderRenderer;

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, assign) NSInteger leftButtonsCount;
@property (nonatomic, assign) NSInteger rightButtonsCount;
@property (nonatomic, assign) CGFloat responsiveButtonPadding;
@property (nonatomic, weak) id parentResponder;
@property (nonatomic, strong) id appHeaderRenderer;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSArray *leftButtons;
@property (nonatomic, strong) NSArray *rightButtons;

@end