//
//  BVTDisclaimerViewController.m
//  bvt
//
//  Created by Greg on 6/3/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTDisclaimerViewController.h"
#import "BVTHeaderTitleView.h"
#import "BVTStyles.h"
@import GoogleMobileAds;

@interface BVTDisclaimerViewController ()
@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";

@implementation BVTDisclaimerViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60.f, 0);

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.f;
    
    UIView *view = self.tabBarController.selectedViewController.view;
    UIView *bannerSpace = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 61.f, view.frame.size.width, 61.f)];
    bannerSpace.backgroundColor = [UIColor whiteColor];
    [view addSubview:bannerSpace];
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    
    [bannerSpace addSubview:self.bannerView];
    
    [self.bannerView setFrame:CGRectMake(0, 0, bannerSpace.frame.size.width, self.bannerView.frame.size.height)];
    
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    // Do any additional setup after loading the view.
}

- (IBAction)didTapBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
