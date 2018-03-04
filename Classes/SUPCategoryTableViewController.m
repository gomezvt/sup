//
//  SUPCategoryTableViewController.m
//  Sup? City
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPCategoryTableViewController.h"

#import "SUPHeaderTitleView.h"
#import "SUPSubCategoryTableViewController.h"
#import "SUPStyles.h"
#import "AppDelegate.h"

#import "YLPClient+Search.h"
#import "YLPSortType.h"
#import "YLPSearch.h"
#import "YLPBusiness.h"
#import "SUPHUDView.h"
#import "SUPStyles.h"

@interface SUPCategoryTableViewController ()
<SUPHUDViewDelegate, SUPSubCategoryTableViewControllerDelegate>

@property (nonatomic, strong) SUPHUDView *hud;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;
@property (nonatomic, strong) UITextField *alertTextField;

@end

static NSArray *categories;
static NSArray *businessesToDisplay;
static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kShowSubCategorySegue = @"ShowSubCategory";

@implementation SUPCategoryTableViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
//    self.headerTitleView.leadingEdgeConstraint.constant = 0.f;
    self.navigationItem.titleView = self.headerTitleView;
    self.headerTitleView.cityNameLabel.text = @"Sup? City";

    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (kCity && ![kCity isEqualToString:@"(null), (null)"])
    {
        self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@"Sup? City:  %@", [kCity capitalizedString]];
    }
    
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    if (mainScreen.size.width == 1024.f)
    {
        [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
    }
    else if (mainScreen.size.width < 1024.f && mainScreen.size.width > 414.f)
    {
        [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
    }
    else
    {
        if (mainScreen.size.width > 375.f)
        {
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
        }
        else if (mainScreen.size.width == 375.f)
        {
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:21]];
        }
        else
        {
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:18]];
        }
    }
}

- (void)didTapBackWithDetails:(NSMutableDictionary *)details
{
    self.cachedDetails = details;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    categories = @[ ];
    
    self.titleLabel.text = self.categoryTitle;
    
    if ([self.categoryTitle isEqualToString:@"Arts, Museums, & Music"])
    {
        categories = kArtsMuseums;
    }
    else if ([self.categoryTitle isEqualToString:@"Coffee, Sweets, & Bakeries"])
    {
        categories = kCoffeeSweetsBakeries;
    }
    else if ([self.categoryTitle isEqualToString:@"Hotels, Hostels, Bed & Breakfast"])
    {
        categories = kHotelsHostelsBB;
    }
    else if ([self.categoryTitle isEqualToString:@"Entertainment & Recreation"])
    {
        categories = kEntertainmentRecreation;
    }
    else if ([self.categoryTitle isEqualToString:@"Bars & Lounges"])
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
    else if ([self.categoryTitle isEqualToString:@"Tours & Festivals"])
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

- (void)didTapHUDCancelButton
{
    self.didCancelRequest = YES;
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    [self.hud removeFromSuperview];
}

- (IBAction)didTapPlusButton:(id)sender
{
    //    self.headerTitleView.cityNameLabel.text = @":  San Francisco";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Your Search Location" message:@"Enter city, state, or zip code." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
        self.alertTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (kCity && ![kCity isEqualToString:@"(null), (null)"])
        {
            self.alertTextField.placeholder = [kCity capitalizedString];
        }
    }];
    
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *city = self.alertTextField.text;
        if (city.length > 0 && ![[city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            kCity = city;
            if (kCity && ![kCity isEqualToString:@"(null), (null)"])
            {
                            self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@"Sup? City:  %@", [self.alertTextField.text capitalizedString]];
            }

        }
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (kCity && ![kCity isEqualToString:@"(null), (null)"])
    {
        self.hud = [SUPHUDView hudWithView:self.navigationController.view];
        self.hud.delegate = self;
        self.didCancelRequest = NO;
        
        self.tableView.userInteractionEnabled = NO;
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        
        self.backChevron.enabled = NO;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *selectionTitle = cell.textLabel.text;
        
        __weak typeof(self) weakSelf = self;
        [[AppDelegate yelp] searchWithLocation:kCity term:selectionTitle limit:50 offset:0 sort:YLPSortTypeDistance completionHandler:^
         (YLPSearch *searchResults, NSError *error){
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 NSString *string = error.userInfo[@"NSLocalizedDescription"];
                 
                 if ([string isEqualToString:@"The Internet connection appears to be offline."])
                 {
                     [weakSelf _hideHUD];
                     
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Check your connection and try again" preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [weakSelf presentViewController:alertController animated:YES completion:nil];
                     
                 }
                 else if (searchResults.businesses.count == 0 || searchResults == nil)
                 {
                     [weakSelf _hideHUD];
                     
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No search results found" message:@"Try selecting another category, or modify your search location" preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [weakSelf presentViewController:alertController animated:YES completion:nil];
                     
                 }
                 else if (searchResults.businesses.count > 0)
                 {
                     NSMutableArray *filteredArray = [NSMutableArray array];
                     for (YLPBusiness *biz in searchResults.businesses)
                     {
                         if ([[biz.categories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", selectionTitle]] lastObject] && biz.closed == NO)
                         {
                             if (filteredArray.count > 0)
                             {
                                 if (![filteredArray containsObject:biz])
                                 {
                                     [filteredArray addObject:biz];
                                 }
                             }
                             else
                             {
                                 [filteredArray addObject:biz];
                                 
                             }
                         }
                     }
                     
                     if (filteredArray.count > 0)
                     {
                         NSArray *descriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
                         NSArray *sortedArray = [filteredArray sortedArrayUsingDescriptors:descriptor];
                         
                         SUPSubCategoryTableViewController *subCat = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"SubCat"];
                         subCat.subCategoryTitle = selectionTitle;
                         subCat.filteredResults = sortedArray;
                         subCat.cachedDetails = weakSelf.cachedDetails;
                         subCat.delegate = weakSelf;
                         
                         if (!weakSelf.didCancelRequest)
                         {
                             [weakSelf _hideHUD];
                             
                             [weakSelf.navigationController pushViewController:subCat animated:YES];
                         }
                     }
                     else
                     {
                         [weakSelf _hideHUD];
                         
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No results match the selected category" message:@"Please select another category" preferredStyle:UIAlertControllerStyleAlert];
                         
                         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                         [alertController addAction:ok];
                         
                         [weakSelf presentViewController:alertController animated:YES completion:nil];
                     }
                 }
             });
         }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Search Location Entered" message:@"Please enter a city, state, or zip code to search and try again." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            self.alertTextField = textField;
            
        }];
        
        
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *city = self.alertTextField.text;
            if (city.length > 0 && ![[city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
            {
                kCity = city;
                if (kCity && ![kCity isEqualToString:@"(null), (null)"])
                {
                                    self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@"Sup? City:  %@", [self.alertTextField.text capitalizedString]];
                }

            }
        }];
        [alertController addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)_hideHUD
{
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;

    [self.hud removeFromSuperview];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapBackWithDetails:)])
    {
        [self.delegate didTapBackWithDetails:self.cachedDetails];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
