//
//  BVTCategoryTableViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTCategoryTableViewController.h"

#import "BVTHeaderTitleView.h"
#import "BVTThumbNailTableViewCell.h"
#import "BVTSubCategoryTableViewController.h"

#import "AppDelegate.h"

#import "YLPClient+Search.h"
#import "YLPSortType.h"
#import "YLPSearch.h"
#import "YLPBusiness.h"

@interface BVTCategoryTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) BVTHeaderTitleView *headerTitleView;

@end

static NSArray *categories;
static NSArray *businessesToDisplay;
static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kThumbNailCell = @"BVTThumbNailTableViewCell";
static NSString *const kDefaultCellIdentifier = @"Cell";
static NSString *const kShowSubCategorySegue = @"ShowSubCategory";

static NSString *const kGalleries = @"Galleries";
static NSString *const kPerformingArts = @"Performing Arts";
static NSString *const kMuseums = @"Museums";

@implementation BVTCategoryTableViewController

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
    
    categories = @[ ];
    
    self.titleLabel.text = self.categoryTitle;
    
    if ([self.categoryTitle isEqualToString:@"Arts and Museums"])
    {
        categories = @[ kGalleries, kPerformingArts, kMuseums ];
    }
    
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
    BVTThumbNailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *selectionTitle = cell.titleLabel.text;
    
    [[AppDelegate sharedClient] searchWithLocation:@"San Francisco, CA" term:nil limit:5 offset:0 sort:YLPSortTypeDistance completionHandler:^
     (YLPSearch *searchResults, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error){
                 NSLog(@"An error happened during the request: %@", error);
             }
             else if (searchResults) {
                 [self performSegueWithIdentifier:kShowSubCategorySegue sender:@[ selectionTitle, searchResults ]];
             }
             else {
                 NSLog(@"No business was found");
             }
         });
     }];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BVTThumbNailTableViewCell *cell = (BVTThumbNailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = [categories objectAtIndex:indexPath.row];

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
    if ([[segue identifier] isEqualToString:kShowSubCategorySegue])
    {
        // Get destination view
        BVTSubCategoryTableViewController *vc = [segue destinationViewController];
        vc.subCategoryTitle = [info firstObject];
        vc.searchResults = [info lastObject];
    }
}

@end
