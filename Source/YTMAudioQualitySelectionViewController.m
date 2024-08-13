#import "YTMAudioQualitySelectionViewController.h"
#import "Headers/Localization.h"

@implementation YTMAudioQualitySelectionViewController

@synthesize isDefaultQualitySelection = _isDefaultQualitySelection;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOC(@"SELECT_AUDIO_QUALITY");
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isDefaultQualitySelection ? 6 : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSArray *qualities = self.isDefaultQualitySelection ? 
        @[LOC(@"MANUAL"), @"64k", @"128k", @"192k", @"320k", LOC(@"BEST_POSSIBLE")] :
        @[@"64k", @"128k", @"192k", @"320k", LOC(@"BEST_POSSIBLE")];
    
    cell.textLabel.text = qualities[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *qualities = self.isDefaultQualitySelection ?
        @[@"manual", @"64k", @"128k", @"192k", @"320k", @"best"] :
        @[@"64k", @"128k", @"192k", @"320k", @"best"];
    
    NSString *selectedQuality = qualities[indexPath.row];
    [self.delegate audioQualitySelected:selectedQuality];
    
    if (self.isDefaultQualitySelection) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end