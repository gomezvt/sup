//
//  BVTSurpriseCategoryTableViewController.m
//  bvt
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTSurpriseCategoryTableViewController.h"

#import "BVTHeaderTitleView.h"
#import "BVTStyles.h"

@interface BVTSurpriseCategoryTableViewController ()

@end

static NSArray *categories;
static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kShowShoppingCartSegue = @"ShowShoppingCart";

@implementation BVTSurpriseCategoryTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
    
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    categories = @[ ];
        
    if ([self.categoryTitle isEqualToString:@"Arts and Museums"])
    {
        categories = kArtsMuseums;
    }
    else if ([self.categoryTitle isEqualToString:@"Coffee, Sweets, and Bakeries"])
    {
        categories = kCoffeeSweetsBakeries;
    }
    else if ([self.categoryTitle isEqualToString:@"Music"])
    {
        categories = kMusic;
    }
    else if ([self.categoryTitle isEqualToString:@"Hotels, Hostels, Bed & Breakfast"])
    {
        categories = kHotelsHostelsBB;
    }
    else if ([self.categoryTitle isEqualToString:@"Entertainment and Recreation"])
    {
        categories = kEntertainmentRecreation;
    }
    else if ([self.categoryTitle isEqualToString:@"Bars and Lounges"])
    {
        categories = kBarsLounges;
    }
    else if ([self.categoryTitle isEqualToString:@"Restaurants"])
    {
        categories = kRestaurants;
    }
    else if ([self.categoryTitle isEqualToString:@"Shopping"])
    {
        categories = kShopping;
    }
    else if ([self.categoryTitle isEqualToString:@"Tours and Festivals"])
    {
        categories = kToursFestivals;
    }
    else
    {
        // Travel
        categories = kTravel;
    }
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSString *selectionTitle = [kBVTCategories objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:kShowShoppingCartSegue sender:nil];
}

#pragma mark - Table view data source

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    
    return cell;
}
@end
