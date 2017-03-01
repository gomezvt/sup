//
//  BVTSurpriseTableViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTSurpriseTableViewController.h"
#import "BVTHeaderTitleView.h"
#import "BVTSurpriseCategoryTableViewController.h"
#import "BVTStyles.h"

@interface BVTSurpriseTableViewController ()
<BVTSurpriseCategoryTableViewControllerDelegate>

@property (nonatomic, strong) BVTHeaderTitleView *headerTitleView;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kShowCategorySegue = @"ShowCategory";

@implementation BVTSurpriseTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
    


}

- (void)didTapBackChevron:(id)sender withCategories:(NSMutableArray *)categories
{
    self.selectedCategories = categories;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (!self.selectedCategories)
    {
        self.selectedCategories = [[NSMutableArray alloc] init];
    }
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *selectionTitle = [kBVTCategories objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:kShowCategorySegue sender:selectionTitle];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kBVTCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [kBVTCategories objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BVTSurpriseCategoryTableViewController *vc = [segue destinationViewController];
    vc.delegate = self;
    vc.selectedCategories = self.selectedCategories;
    
    vc.categoryTitle = sender;
}

@end
