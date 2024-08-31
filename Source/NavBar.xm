#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static BOOL YTMU(NSString *key) {
    NSDictionary *YTMUltimateDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YTMUltimate"];
    return [YTMUltimateDict[key] boolValue];
}

@interface YTMNavigationBarView : UIView
- (void)sortButtonTapped:(id)sender;
@end

@interface QTMButton : UIButton
@property (nonatomic, copy, readwrite) NSString *accessibilityIdentifier;
@end

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

    // Add Test button
    QTMButton *testButton = [self viewWithTag:1001];
    if (!testButton) {
        testButton = [[NSClassFromString(@"QTMButton") alloc] init];
        [testButton setTitle:@"TEST" forState:UIControlStateNormal];
        [testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        testButton.tag = 1001;
        testButton.accessibilityIdentifier = @"id.navigation.test.button";
        [testButton addTarget:self action:@selector(sortButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:testButton];
    }

    // Position the button
    CGSize buttonSize = [testButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat buttonWidth = MAX(buttonSize.width, 44); // Ensure minimum touch target size
    CGFloat buttonHeight = MIN(MAX(buttonSize.height, 44), self.frame.size.height - 16); // Ensure minimum touch target size and fit within nav bar
    CGFloat buttonY = (self.frame.size.height - buttonHeight) / 2;

    // Find the leftmost existing button
    CGFloat leftmostX = self.frame.size.width;
    for (UIView *button in existingButtons) {
        if (button.frame.origin.x < leftmostX) {
            leftmostX = button.frame.origin.x;
        }
    }

    // Position the TEST button to the left of the existing buttons
    CGFloat testButtonX = leftmostX - buttonWidth - 8; // 8 points of padding
    testButton.frame = CGRectMake(testButtonX, buttonY, buttonWidth, buttonHeight);
}

%new
- (void)sortButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YTMUShowSortOptions" object:nil];
}
%end
