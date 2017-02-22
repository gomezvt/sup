//
//  BVTCategoryTableViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTCategoryTableViewController.h"

#import "BVTHeaderTitleView.h"
#import "BVTSubCategoryTableViewController.h"
#import "BVTStyles.h"
#import "AppDelegate.h"

#import "YLPClient+Search.h"
#import "YLPSortType.h"
#import "YLPSearch.h"
#import "YLPBusiness.h"
#import "BVTHUDView.h"
#import "BVTStyles.h"

@interface BVTCategoryTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

static NSArray *categories;
static NSArray *businessesToDisplay;
static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kDefaultCellIdentifier = @"Cell";
static NSString *const kShowSubCategorySegue = @"ShowSubCategory";

@implementation BVTCategoryTableViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    categories = @[ ];
    
    self.titleLabel.text = self.categoryTitle;
    
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

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    BVTHUDView *hudClass = [BVTHUDView hudWithView:self.navigationController.view];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *selectionTitle = cell.textLabel.text;

    [[AppDelegate sharedClient] searchWithLocation:@"Burlington, VT" term:selectionTitle limit:50 offset:0 sort:YLPSortTypeDistance completionHandler:^
     (YLPSearch *searchResults, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (searchResults.businesses.count > 0) {
                 NSMutableArray *filteredArray = [NSMutableArray array];
                 for (YLPBusiness *biz in searchResults.businesses)
                 {
                     if ([[biz.categories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", selectionTitle]] lastObject] && biz.closed == NO)
                     {
                         [filteredArray addObject:biz];
                     }
                 }
                 
                 if (filteredArray.count > 0)
                 {
                     NSArray *descriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
                     NSArray *sortedArray = [filteredArray sortedArrayUsingDescriptors:descriptor];
                     
                     [self performSegueWithIdentifier:kShowSubCategorySegue sender:@[ selectionTitle, sortedArray ]];
                 }
                 else
                 {
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No results match the selected category" message:@"Please select another category" preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
             }
             else if (error) {
                 NSLog(@"An error happened during the request: %@", error);
             }
             else {
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No search results found" message:@"Please select another category" preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 
                 [self presentViewController:alertController animated:YES completion:nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [categories objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        vc.filteredResults = [info lastObject];
    }
}

@end
