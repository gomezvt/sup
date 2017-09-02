//
//  SUPSurpriseCategoryTableViewController.m
//  SUP
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "SUPSurpriseSubCategoryTableViewController.h"

#import "SUPSurpriseShoppingCartTableViewController.h"
#import "SUPHeaderTitleView.h"
#import "SUPStyles.h"
#import "SUPPresentationTableViewController.h"
@import GoogleMobileAds;

@interface SUPSurpriseSubCategoryTableViewController ()
    <SUPSurpriseShoppingCartTableViewControllerDelegate,
     UIPopoverPresentationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic, strong) NSMutableArray *mut;
@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;
@property (nonatomic, strong) UITextField *alertTextField;

@end

static NSArray *categories;

static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kShowShoppingCartSegue = @"ShowShoppingCart";
static NSString *const kCheckMarkGraphic = @"green_check";

@implementation SUPSurpriseSubCategoryTableViewController

- (IBAction)didTapPlusButton:(id)sender
{
    //    self.headerTitleView.cityNameLabel.text = @":  San Francisco";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter City, State, or Zip Code" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
        
    }];
    
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *city = self.alertTextField.text;
        if (city.length > 0 && ![[city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            kCity = city;
            self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@":  %@", [self.alertTextField.text capitalizedString]];
        }
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didRemoveObjectsFromArray:(NSArray *)array
{
    self.mut = [array mutableCopy];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
}

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController;
{
    //
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller
{
    return UIModalPresentationNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (kCity)
    {
        self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@":  %@", [kCity capitalizedString]];
    }
    
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    if ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
         self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) && mainScreen.size.width == 1024.f)
    {
        [self.headerTitleView.supLabel setFont:[UIFont boldSystemFontOfSize:24]];
        [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
    }
    else
    {
        if (mainScreen.size.width > 375.f)
        {
            [self.headerTitleView.supLabel setFont:[UIFont boldSystemFontOfSize:24]];
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
        }
        else if (mainScreen.size.width == 375.f)
        {
            [self.headerTitleView.supLabel setFont:[UIFont boldSystemFontOfSize:21]];
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:21]];
        }
        else
        {
            [self.headerTitleView.supLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:18]];
            
        }
    }
    

    
    NSArray *previousValues = [self.catDict objectForKey:self.categoryTitle];
    if (previousValues.count > 0)
    {
        self.mut = [previousValues mutableCopy];
    }
    
    // Reload table either way, especially in the case if we come back from
    // shopping cart after all items have been deleted and we need to clear checkmarks
    [self.tableView reloadData];
    
    [self.goButton setEnabled:[self evaluateButtonState]];
    if (self.goButton.enabled)
    {
        [self.goButton.layer setBorderColor:[[SUPStyles iconBlue] CGColor]];
    }
    else
    {
        [self.goButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    }
}

- (BOOL)evaluateButtonState
{
    BOOL isEnabled = NO;
    NSArray *allValues = [self.catDict allValues];
    for (NSArray *array in allValues)
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
    if ([self.delegate respondsToSelector:@selector(didTapBackWithCategories:)])
    {
        [self.delegate didTapBackWithCategories:self.catDict];
    }
    
    if ([self.delegate respondsToSelector:@selector(didTapBackWithDetails:)])
    {
        [self.delegate didTapBackWithDetails:self.cachedDetails];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTapBackWithCategories:(NSMutableDictionary *)categories
{
    self.catDict = categories;
}

- (void)viewDidLoad
{
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
        self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
    {
        self.headerTitleView.titleViewLabelConstraint.constant = 0.f;
    }
    self.tableView.tableFooterView = [UIView new];

    CALayer * layer = [self.goButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[SUPStyles iconBlue] CGColor]];
    
    [super viewDidLoad];
    
    if (!self.mut)
    {
        self.mut = [NSMutableArray array];
    }
    
    if (!self.catDict)
    {
        self.catDict = [[NSMutableDictionary alloc] init];
    }
    
    categories = @[ ];
    
    if ([self.categoryTitle isEqualToString:@"Arts, Museums, & Music"])
    {
        categories = kArtsMuseums;
    }
    else if ([self.categoryTitle isEqualToString:@"Coffee, Sweets, & Bakeries"])
    {
        categories = kCoffeeSweetsBakeries;
    }
//    else if ([self.categoryTitle isEqualToString:@"Music"])
//    {
//        categories = kMusic;
//    }
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
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *category = [categories objectAtIndex:indexPath.row];
    if (cell.accessoryView)
    {
        [self.mut removeObject:category];
        cell.accessoryView = nil;
    }
    else
    {
        UIImageView *checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCheckMarkGraphic]];
        cell.accessoryView = checkView;
        [self.mut addObject:category];
    }
    
    self.catDict[self.categoryTitle] = self.mut;
    [self.goButton setEnabled:[self evaluateButtonState]];
    if (self.goButton.enabled)
    {
        [self.goButton.layer setBorderColor:[[SUPStyles iconBlue] CGColor]];
    }
    else
    {
        [self.goButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    }
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

- (void)didTapBackWithDetails:(NSMutableArray *)details
{
    
    self.cachedDetails = details;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get destination view
    SUPSurpriseShoppingCartTableViewController *vc = [segue destinationViewController];
    vc.catDict = self.catDict;
    vc.delegate = self;
    vc.cachedDetails = self.cachedDetails;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *title = [categories objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.numberOfLines = 0;
    
    NSArray *array = [self.catDict valueForKey:self.categoryTitle];
    NSString *btitle = [[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", title]] lastObject];
    if (!btitle)
    {
        cell.accessoryView = nil;
    }
    else
    {
        UIImageView *checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCheckMarkGraphic]];
        cell.accessoryView = checkView;
    }
    
    return cell;
}
@end
