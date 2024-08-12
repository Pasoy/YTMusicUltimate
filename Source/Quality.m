@implementation YTMAudioQualitySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOC(@"SELECT_AUDIO_QUALITY");
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSArray *qualities = @[@"64k", @"128k", @"192k", @"320k"];
    cell.textLabel.text = qualities[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *qualities = @[@"64k", @"128k", @"192k", @"320k"];
    NSString *selectedQuality = qualities[indexPath.row];
    [self.delegate audioQualitySelected:selectedQuality];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end