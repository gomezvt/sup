//
//  BVTSurpriseCategoryTableViewController.m
//  bvt
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTSurpriseSubCategoryTableViewController.h"

#import "BVTSurpriseShoppingCartTableViewController.h"
#import "BVTHeaderTitleView.h"
#import "BVTStyles.h"

@interface BVTSurpriseSubCategoryTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
//@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSMutableArray *subCats;

@end

static NSArray *categories;

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kShowShoppingCartSegue = @"ShowShoppingCart";
static NSString *const kCheckMarkGraphic = @"green_check";

@implementation BVTSurpriseSubCategoryTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.dict = [NSDictionary dictionary];
    
    [self.goButton setEnabled:[self evaluateButtonState]];
}

- (BOOL)evaluateButtonState
{
    BOOL isEnabled = NO;
    NSArray *selectedCats = [self.selectedCategories allValues];
    
    for (NSArray *array in selectedCats)
    {
        if (array.count > 0)
        {
            isEnabled = YES;
            
            break;
        }
    }
    
    return isEnabled;
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapBackChevron:withCategories:)])
    {
        [self.delegate didTapBackChevron:sender withCategories:self.selectedCategories];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.subCats = [NSMutableArray array];

    
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *category = [categories objectAtIndex:indexPath.row];
    
    if (cell.accessoryView)
    {
        if ([self.subCats containsObject:category])
        {
            [self.subCats removeObject:category];
        }
        cell.accessoryView = nil;
    }
    else
    {
        UIImageView *checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCheckMarkGraphic]];
        cell.accessoryView = checkView;
        [self.subCats addObject:category];
    }

    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.subCats forKey:self.categoryTitle];
    [self.selectedCategories addEntriesFromDictionary:dict];

    [self.goButton setEnabled:[self evaluateButtonState]];
}

- (IBAction)didTapButton:(id)sender
{
    // Not wired directly from button as this will cause a double presentation
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get destination view
    BVTSurpriseShoppingCartTableViewController *vc = [segue destinationViewController];
    vc.selectedCategories = self.selectedCategories;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *title = [categories objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.numberOfLines = 0;
    
    NSArray *array = [self.selectedCategories allValues];
    NSString *btitle = [[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self CONTAINS[c] %@", title]] lastObject];
    if (!btitle)
    {
        cell.accessoryView = nil;
    }
    else
    {
        UIImageView *checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green_check"]];
        cell.accessoryView = checkView;
    }
    

    return cell;
}
@end
