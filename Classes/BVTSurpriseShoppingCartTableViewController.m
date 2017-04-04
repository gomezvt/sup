//
//  BVTSurpriseShoppingCartTableViewController.m
//  bvt
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTSurpriseShoppingCartTableViewController.h"

#import "BVTSurpriseCategoryTableViewController.h"
#import "BVTHeaderTitleView.h"
#import "BVTStyles.h"
#import "AppDelegate.h"
#import "YLPSearch.h"
#import "YLPBusiness.h"
#import "YLPClient+Search.h"
#import "BVTHUDView.h"

@interface BVTSurpriseShoppingCartTableViewController ()
<BVTHUDViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, strong) BVTHUDView *hud;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";


@implementation BVTSurpriseShoppingCartTableViewController

- (void)didTapHUDCancelButton
{
    self.didCancelRequest = YES;
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.hud removeFromSuperview];
}

- (IBAction)didTapSubmit:(id)sender
{
    
    NSArray *array = [self.catDict allValues];
    self.hud = [BVTHUDView hudWithView:self.navigationController.view];
    self.hud.delegate = self;
    self.didCancelRequest = NO;
    
    NSMutableArray *categoryArray = [NSMutableArray array];
    for (NSArray *subCat in array)
    {
        [categoryArray addObjectsFromArray:subCat];
    }
    
    NSMutableArray *categoryResults = [NSMutableArray array];
    
    self.tableView.userInteractionEnabled = NO;
    self.backChevron.enabled = NO;
    for (NSString *subCatTitle in categoryArray)
    {
        [[AppDelegate sharedClient] searchWithLocation:@"New York, NY" term:subCatTitle limit:50 offset:0 sort:YLPSortTypeDistance completionHandler:^
         (YLPSearch *searchResults, NSError *error){
             dispatch_async(dispatch_get_main_queue(), ^{
                 for (YLPBusiness *biz in searchResults.businesses)
                 {
                     YLPCategory *matchingCategory = [[biz.categories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", subCatTitle]] lastObject];
                     
                     if (matchingCategory && biz.closed == NO)
                     {
                         [categoryResults addObject:biz];
                     }
                     
                     if ([subCatTitle isEqualToString:[categoryArray lastObject]]  && biz == [searchResults.businesses lastObject])
                     {
                         [self _hideHUD];
                         
                         if (categoryResults.count == 0)
                         {
                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No results match the selected category(s)" message:@"Please select another category" preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                             [alertController addAction:ok];
                             
                             [self presentViewController:alertController animated:YES completion:nil];
                         }
                         else
                         {
                             // Alphabetize and then Assign values to mutable dict key?
                             [self _displayBusinesses:categoryResults];
                         }
                     }
                 }
                 
                 if ([subCatTitle isEqualToString:[categoryArray lastObject]] && categoryResults.count == 0)
                 {
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No search results found" message:@"Please select another category" preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [self presentViewController:alertController animated:YES completion:nil];
                     
                     [self _hideHUD];
                 }
             });
             
             if (error)
             {
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 
                 [self _hideHUD];
             }
         }];
    }
}

- (void)_displayBusinesses:(NSArray *)array
{
    NSLog(@"%@", array);
}

- (void)_hideHUD
{
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.hud removeFromSuperview];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *key = [self.catDict allKeys][indexPath.section];
        NSMutableArray *k = [self.catDict objectForKey:key];
        id object = [k objectAtIndex:indexPath.row];
        [k removeObject:object];
        
        [tableView reloadData]; // tell table to refresh now
        [self.goButton setEnabled:[self evaluateButtonState]];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
    
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
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.catDict.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.catDict allKeys][section];
    NSArray *k = [self.catDict objectForKey:key];

    return k.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = [self.catDict allValues][section];
    if (array.count > 0)
    {
        return [self.catDict allKeys][section];
    }

        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSArray *sectionValues = [self.catDict allValues][indexPath.section];

    cell.textLabel.text = sectionValues[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.numberOfLines = 0;

    return cell;
}

@end
