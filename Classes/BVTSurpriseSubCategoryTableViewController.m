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
    <BVTSurpriseShoppingCartTableViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic, strong) NSMutableArray *mut;

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
    self.mut = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.goButton setEnabled:[self evaluateButtonState]];
}

- (BOOL)evaluateButtonState
{
    BOOL isEnabled = NO;
    if (self.subCats.count > 0)
    {
        isEnabled = YES;
    }

    return isEnabled;
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapBackWithSubCategories:withCategories:)])
    {
        [self.delegate didTapBackWithSubCategories:self.subCats withCategories:self.selectedCategories];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didTapBackWithSubCategories:(NSMutableArray *)array withCategories:(NSMutableDictionary *)categories
{
    self.subCats = array;
    self.selectedCategories = categories;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.subCats)
    {
        self.subCats = [NSMutableArray array];

    }

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
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *category = [categories objectAtIndex:indexPath.row];    
    if (cell.accessoryView)
    {
        if ([self.mut containsObject:category])
        {
            [self.mut removeObject:category];

        }
        
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
        [self.mut addObject:category];[self.goButton setEnabled:[self evaluateButtonState]];
        [self.subCats addObject:category];
    }

    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.mut forKey:self.categoryTitle];
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
    vc.subCats = self.subCats;
    vc.delegate = self;
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
