//
//  BVTDetailTableViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTSubCategoryTableViewController.h"

#import "BVTDetailTableViewController.h"
#import "BVTHeaderTitleView.h"
#import "BVTThumbNailTableViewCell.h"
#import "YLPBusiness.h"
#import "AppDelegate.h"
#import "YLPClient+Business.h"
#import "YLPBusiness.h"
#import "YLPSearch.h"

@interface BVTSubCategoryTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) BVTHeaderTitleView *headerTitleView;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kThumbNailCell = @"BVTThumbNailTableViewCell";
static NSString *const kDefaultCellIdentifier = @"Cell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation BVTSubCategoryTableViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.navigationItem.titleView = self.headerTitleView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.subCategoryTitle;

    UINib *cellNib = [UINib nibWithNibName:kThumbNailCell bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kDefaultCellIdentifier];

    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.headerTitleView.centerXConstraint.constant = [self _adjustTitleViewCenter];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    YLPBusiness *selectedBusiness = [self.searchResults.businesses objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kShowDetailSegue sender:nil];

//    [self performSegueWithIdentifier:kShowDetailSegue sender:@[ selectedBusiness.name, selectedBusiness ]];

//    [[AppDelegate sharedClient] businessWithId:selectedBusiness.name completionHandler:^
//     (YLPBusiness *business, NSError *error) {
//         dispatch_async(dispatch_get_main_queue(), ^{
//             [self performSegueWithIdentifier:kShowDetailSegue sender:@[ selectedBusiness.name, selectedBusiness ]];
//         });
//     }];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *businesses = (NSArray *)self.searchResults;
    
//    return businesses.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BVTThumbNailTableViewCell *cell = (BVTThumbNailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    
//    NSArray *businesses = (NSArray *)self.searchResults;
//    YLPBusiness *business = [businesses objectAtIndex:indexPath.row];
//    cell.titleLabel.text = business.name;
    cell.titleLabel.text = @"test";

    return cell;
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (CGFloat)_adjustTitleViewCenter
{
    BOOL deviceIsPortrait = [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait;
    
    return deviceIsPortrait ? -20.f : 0.f;
}

#pragma mark - Device Orientation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator
{    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        self.headerTitleView.centerXConstraint.constant = -20.f;
        [self.tableView reloadData];
    } completion:^(id  _Nonnull context) {
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *info = sender;
    if ([[segue identifier] isEqualToString:kShowDetailSegue])
    {
        // Get destination view
        BVTDetailTableViewController *vc = [segue destinationViewController];
        vc.detailTitle = [info firstObject];
        vc.business = [info lastObject];
    }
}

@end
