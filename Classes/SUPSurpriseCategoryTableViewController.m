//
//  SUPSurpriseTableViewController.m
//  Sup? City
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPSurpriseCategoryTableViewController.h"
#import "SUPHeaderTitleView.h"
#import "SUPSurpriseSubCategoryTableViewController.h"
#import "SUPSurpriseShoppingCartTableViewController.h"
#import "SUPStyles.h"

@interface SUPSurpriseCategoryTableViewController ()
<SUPSurpriseSubCategoryTableViewControllerDelegate>

@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic, strong) UITextField *alertTextField;

@end

static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kShowCategorySegue = @"ShowCategory";
static NSString *const kShowShoppingCartSegue = @"ShowShoppingCart";


@implementation SUPSurpriseCategoryTableViewController

- (void)didTapBackWithDetails:(NSMutableArray *)details
{
    self.cachedDetails = details;
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.headerTitleView.leadingEdgeConstraint.constant = 40.f;

    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
}

- (void)didTapBackWithCategories:(NSMutableDictionary *)categories
{
    self.catDict = categories;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.tableFooterView = [UIView new];
    
    CALayer * layer = [self.goButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}

- (IBAction)didTapPlusButton:(id)sender
{
    //    self.headerTitleView.cityNameLabel.text = @":  San Francisco";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter City, State, or Zip Code" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
    }];
    
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *city = self.alertTextField.text;
        if (city.length > 0)
        {
            kCity = city;
            self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@"Sup? City:  %@", [self.alertTextField.text capitalizedString]];
        }
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (kCity)
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

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectionTitle = [kSUPCategories objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:kShowCategorySegue sender:selectionTitle];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kSUPCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [kSUPCategories objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowShoppingCartSegue])
    {
        // Get destination view
        SUPSurpriseShoppingCartTableViewController *vc = [segue destinationViewController];
        vc.cachedDetails = self.cachedDetails;
        vc.catDict = self.catDict;
    }
    else
    {
        SUPSurpriseSubCategoryTableViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.catDict = self.catDict;
        vc.categoryTitle = sender;
        vc.cachedDetails = self.cachedDetails;
    }
}

@end
