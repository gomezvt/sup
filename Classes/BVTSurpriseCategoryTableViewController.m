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
@property (nonatomic, strong) NSMutableArray *subCats;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kShowCategorySegue = @"ShowCategory";
static NSString *const kShowShoppingCartSegue = @"ShowShoppingCart";

@implementation BVTSurpriseCategoryTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
    


}

- (IBAction)didTapBack:(id)sender
{
//    if ([self.delegate respondsToSelector:@selector(didTapBackWithSubCategories:withCategories:)])
//    {
//        [self.delegate didTapBackWithSubCategories:self.subCats withCategories:self.selectedCategories];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)didTapBackWithSubCategories:(NSMutableArray *)array withCategories:(NSMutableDictionary *)categories
{
    self.subCats = array;
    self.selectedCategories = categories;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    if (!self.selectedCategories)
    {
        self.selectedCategories = [[NSMutableDictionary alloc] init];
    }
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
        vc.selectedCategories = self.selectedCategories;
        vc.subCats = self.subCats;
    }
    else
    {
        BVTSurpriseSubCategoryTableViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.selectedCategories = self.selectedCategories;
        vc.subCats = self.subCats;
        vc.categoryTitle = sender;
    }
}

@end
