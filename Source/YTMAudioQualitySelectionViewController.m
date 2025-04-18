#import "YTMAudioQualitySelectionViewController.h"
#import "Headers/Localization.h"

@implementation YTMAudioQualitySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOC(@"SELECT_AUDIO_QUALITY");
    self.tableView.tableFooterView = [UIView new];
    
    self.feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [self.feedbackGenerator prepare];
    
    [self setupQualityArrays];
}

- (void)setupQualityArrays {
    self.qualityValues = @[@"manual", @"64k", @"128k", @"192k", @"320k", @"best"];
    NSArray *displayQualities = @[LOC(@"MANUAL"), @"64k", @"128k", @"192k", @"320k", LOC(@"BEST_POSSIBLE")];
    
    self.qualities = self.isDefaultQualitySelection ? displayQualities : [displayQualities subarrayWithRange:NSMakeRange(1, 5)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.qualities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.qualities[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (self.isDefaultQualitySelection) {
        NSDictionary *YTMUltimateDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YTMUltimate"];
        NSString *currentQuality = [YTMUltimateDict objectForKey:@"defaultAudioQuality"];
        if (currentQuality == nil) {
            currentQuality = @"best";
        }
        if ([currentQuality isEqualToString:self.qualityValues[indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.feedbackGenerator impactOccurred];
    
    NSString *selectedQuality = self.qualityValues[self.isDefaultQualitySelection ? indexPath.row : indexPath.row + 1];
    [self.delegate audioQualitySelected:selectedQuality];
    
    if (self.isDefaultQualitySelection) {
        [tableView reloadData];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end