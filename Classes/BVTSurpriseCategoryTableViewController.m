//
//  BVTSurpriseTableViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTSurpriseCategoryTableViewController.h"
#import "BVTHeaderTitleView.h"
#import "BVTSurpriseSubCategoryTableViewController.h"
#import "BVTSurpriseShoppingCartTableViewController.h"
#import "BVTStyles.h"

@interface BVTSurpriseCategoryTableViewController ()
<BVTSurpriseSubCategoryTableViewControllerDelegate>

@property (nonatomic, strong) BVTHeaderTitleView *headerTitleView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kShowCategorySegue = @"ShowCategory";
static NSString *const kShowShoppingCartSegue = @"ShowShoppingCart";


@implementation BVTSurpriseCategoryTableViewController

- (void)didTapBackWithDetails:(NSMutableArray *)details
{
    self.cachedDetails = details;
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
}

- (void)didTapBackWithCategories:(NSMutableDictionary *)categories
{
    self.catDict = categories;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.f, 0);
    
    UIView *view = self.tabBarController.selectedViewController.view;
    UIView *adBannerSpace = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 51.f, view.frame.size.width, 51.f)];
    
    [view addSubview:adBannerSpace];
    adBannerSpace.backgroundColor = [UIColor redColor];
    
    self.tableView.tableFooterView = [UIView new];
    
    CALayer * layer = [self.goButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.goButton setEnabled:[self evaluateButtonState]];
    if (self.goButton.enabled)
    {
        [self.goButton.layer setBorderColor:[[BVTStyles iconGreen] CGColor]];
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
    if ([segue.identifier isEqualToString:kShowShoppingCartSegue])
    {
        // Get destination view
        BVTSurpriseShoppingCartTableViewController *vc = [segue destinationViewController];
        vc.cachedDetails = self.cachedDetails;
        vc.catDict = self.catDict;
    }
    else
    {
        BVTSurpriseSubCategoryTableViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.catDict = self.catDict;
        vc.categoryTitle = sender;
        vc.cachedDetails = self.cachedDetails;
    }
}

@end
