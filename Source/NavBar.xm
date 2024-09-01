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

    QTMButton *testButton = [self viewWithTag:1001];
    if (!testButton) {
        testButton = [[NSClassFromString(@"QTMButton") alloc] init];
        [testButton setTitle:@"TEST" forState:UIControlStateNormal];
        [testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        testButton.tag = 1001;
        testButton.accessibilityIdentifier = @"id.navigation.test.button";
        testButton.hidden = YES;
        [testButton addTarget:self action:@selector(sortButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:testButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTestButtonVisibility:) name:@"YTMUShowTestButton" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTestButtonVisibility:) name:@"YTMUHideTestButton" object:nil];
    }

    CGSize buttonSize = [testButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat buttonWidth = MAX(buttonSize.width, 44); // Ensure minimum touch target size
    CGFloat buttonHeight = MIN(MAX(buttonSize.height, 44), self.frame.size.height - 16); // Ensure minimum touch target size and fit within nav bar
    CGFloat buttonY = (self.frame.size.height - buttonHeight) / 2;

    CGFloat leftmostX = self.frame.size.width;
    for (UIView *button in existingButtons) {
        if (button.frame.origin.x < leftmostX) {
            leftmostX = button.frame.origin.x;
        }
    }

    CGFloat testButtonX = leftmostX - buttonWidth - 8;
    testButton.frame = CGRectMake(testButtonX, buttonY, buttonWidth, buttonHeight);
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
- (void)updateTestButtonVisibility:(NSNotification *)notification {
    QTMButton *testButton = [self viewWithTag:1001];
    if ([notification.name isEqualToString:@"YTMUShowTestButton"]) {
        testButton.hidden = NO;
    } else if ([notification.name isEqualToString:@"YTMUHideTestButton"]) {
        testButton.hidden = YES;
    }
}

%end
