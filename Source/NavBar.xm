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
        sortButton = [[NSClassFromString(@"QTMButton") alloc] init];
        UIImage *sortImage = [UIImage systemImageNamed:@"line.3.horizontal.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:24 weight:UIImageSymbolWeightThin]];
        [sortButton setImage:sortImage forState:UIControlStateNormal];
        sortButton.tag = 1001;
        sortButton.accessibilityIdentifier = @"id.navigation.sort.button";
        sortButton.hidden = YES;
        [sortButton addTarget:self action:@selector(sortButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:sortButton];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSortButtonVisibility:) name:@"YTMUShowSortButton" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSortButtonVisibility:) name:@"YTMUHideSortButton" object:nil];
    }

    CGFloat buttonSize = 40;
    CGFloat buttonY = (self.frame.size.height - buttonSize) / 2;
    CGFloat leftmostX = self.frame.size.width;

    for (UIView *button in existingButtons) {
        if (button.frame.origin.x < leftmostX) {
            leftmostX = button.frame.origin.x;
        }
    }

    CGFloat sortButtonX = MAX(8, leftmostX - buttonSize - 8);
    sortButton.frame = CGRectMake(sortButtonX, buttonY, buttonSize, buttonSize);

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