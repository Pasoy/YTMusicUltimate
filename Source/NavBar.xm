#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Headers/YTMNavigationBarView.h>
#import <Headers/YTQTMButton.h>

static BOOL YTMU(NSString *key) {
    NSDictionary *YTMUltimateDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YTMUltimate"];
    return [YTMUltimateDict[key] boolValue];
}

@interface YTMSortFilterButton : UIButton
@end

%hook QTMButton
- (void)layoutSubviews {
    %orig;
    if (YTMU(@"YTMUltimateIsEnabled") && YTMU(@"hideHistoryButton")) {
        if ([self.accessibilityIdentifier isEqualToString:@"id.navigation.history.button"]) {
            self.hidden = YES;
        }
    }
    if (YTMU(@"YTMUltimateIsEnabled") && YTMU(@"hideCastButton")) {
        if ([self.accessibilityIdentifier isEqualToString:@"id.mdx.playbackroute.button"]) {
            self.hidden = YES;
        }
    }
}
%end

%hook YTMNavigationBarView
- (void)layoutSubviews {
    %orig;

    NSArray *subviews = [self subviews];

    UIView *sortFilterButton = nil;
    NSMutableArray *existingButtons = [NSMutableArray array];
    
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"YTMSortFilterButton")]) {
            sortFilterButton = subview;
        }
        if ([subview isKindOfClass:NSClassFromString(@"QTMButton")] && subview.tag != 1001) {
            [existingButtons addObject:subview];
        }
    }
    
    if (YTMU(@"YTMUltimateIsEnabled") && YTMU(@"hideFilterButton")) {
        if (sortFilterButton != nil) {
            [sortFilterButton removeFromSuperview];
        }
    }

    QTMButton *sortButton = (QTMButton *)[self viewWithTag:1001];
    if (!sortButton) {
        sortButton = [[NSClassFromString(@"QTMButton") alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIImage *sortImage = [UIImage systemImageNamed:@"line.3.horizontal.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:24 weight:UIImageSymbolWeightThin]];
        [sortButton setImage:sortImage forState:UIControlStateNormal];
        sortButton.tag = 1001;
        sortButton.accessibilityIdentifier = @"id.navigation.sort.button";
        sortButton.hidden = YES;
        [sortButton addTarget:self action:@selector(sortButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        [self addRightButton:sortButton];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSortButtonVisibility:) name:@"YTMUShowSortButton" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSortButtonVisibility:) name:@"YTMUHideSortButton" object:nil];
    }

    CGFloat leftmostX = self.bounds.size.width;
    for (UIButton *button in self.rightButtons) {
        if (button != sortButton && button.frame.origin.x < leftmostX) {
            leftmostX = button.frame.origin.x;
        }
    }

    CGFloat sortButtonX = leftmostX - sortButton.frame.size.width - 8;
    sortButton.frame = CGRectMake(sortButtonX, 8, 40, 40);

    sortButton.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [sortButton.imageView.centerXAnchor constraintEqualToAnchor:sortButton.centerXAnchor],
        [sortButton.imageView.centerYAnchor constraintEqualToAnchor:sortButton.centerYAnchor],
        [sortButton.imageView.widthAnchor constraintEqualToConstant:24],
        [sortButton.imageView.heightAnchor constraintEqualToConstant:24]
    ]];

    sortButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    sortButton.imageView.image = [sortButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    sortButton.tintColor = [UIColor whiteColor];
}

- (void)dealloc {
    %orig;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

%new
- (void)sortButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YTMUShowSortOptions" object:nil];
}

%new
- (void)updateSortButtonVisibility:(NSNotification *)notification {
    QTMButton *sortButton = [self viewWithTag:1001];
    if ([notification.name isEqualToString:@"YTMUShowSortButton"]) {
        sortButton.hidden = NO;
    } else if ([notification.name isEqualToString:@"YTMUHideSortButton"]) {
        sortButton.hidden = YES;
    }
}
%end