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
#import "BVTSurpriseRecommendationsTableViewController.h"
#import "BVTStyles.h"
#import "AppDelegate.h"
#import "YLPCategory.h"
#import "YLPSearch.h"
#import "YLPBusiness.h"
#import "YLPLocation.h"
#import "YLPClient+Search.h"
#import "BVTHUDView.h"
#import "BVTTableViewSectionHeaderView.h"

@interface BVTSurpriseShoppingCartTableViewController ()
    <BVTHUDViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;

@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, strong) BVTHUDView *hud;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) NSMutableArray *subCategories;
@property (nonatomic, strong) NSMutableArray *resultsArray;
@property (nonatomic, strong) BVTTableViewSectionHeaderView *headerView;

@end

static int i = 0;
static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kTableViewSectionHeaderView = @"BVTTableViewSectionHeaderView";

@implementation BVTSurpriseShoppingCartTableViewController

- (IBAction)didTapClearAllButton:(id)sender
{
    [self.catDict removeAllObjects];
    [self.subCategories removeAllObjects];
    [self.resultsArray removeAllObjects];
    
    if ([self.delegate respondsToSelector:@selector(didClearShoppingCart)])
    {
        [self.delegate didClearShoppingCart];
    }
    [self.tableView reloadData];
    [self.clearButton setEnabled:[self evaluateButtonState]];
    [self.goButton setEnabled:[self evaluateButtonState]];
    
    [self presentMessage];
}


- (void)didTapHUDCancelButton
{
    self.didCancelRequest = YES;
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.goButton setEnabled:[self evaluateButtonState]];
    [self.clearButton setEnabled:[self evaluateButtonState]];
    [self.hud removeFromSuperview];
}

- (IBAction)didTapSubmit:(id)sender
{
    [self.resultsArray removeAllObjects];
    
    i = 0;
    NSArray *array = [self.catDict allValues];
    self.hud = [BVTHUDView hudWithView:self.navigationController.view];
    self.hud.delegate = self;
    self.didCancelRequest = NO;
    [self.goButton setEnabled:NO];
    [self.clearButton setEnabled:NO];

    NSMutableArray *categoryArray = [NSMutableArray array];
    for (NSArray *subCat in array)
    {
        [categoryArray addObjectsFromArray:subCat];
    }
    
    self.tableView.userInteractionEnabled = NO;
    self.backChevron.enabled = NO;
    
    for (NSString *subCatTitle in categoryArray)
    {
        [[AppDelegate sharedClient] searchWithLocation:@"Burlington, VT" term:subCatTitle limit:50 offset:0 sort:YLPSortTypeDistance completionHandler:^
         (YLPSearch *searchResults, NSError *error){
             if (error)
             {
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 [self presentViewController:alertController animated:YES completion:nil];
                 [self.goButton setEnabled:[self evaluateButtonState]];
                 [self.clearButton setEnabled:[self evaluateButtonState]];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // code here
                     [self _hideHUD];
                 });
             }
         }];
    }
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedArray2 = [[self.catDict allKeys] sortedArrayUsingDescriptors: @[descriptor]];
    NSString *key = [sortedArray2 objectAtIndex:section];
    NSArray *array = [self.catDict valueForKey:key];
    if (array.count > 0)
    {
        return key;
    }
    return nil;
}

- (void)presentMessage
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30.f)];
    label.text = @"Add a sub category to proceed.";
    [super.view addSubview:label];
    label.center = self.tableView.center;
    self.tableView.separatorColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        NSArray *sortedArray2 = [[self.catDict allKeys] sortedArrayUsingDescriptors: @[descriptor]];
        NSString *key = [sortedArray2 objectAtIndex:indexPath.section];
        
        NSMutableArray *array = [self.catDict valueForKey:key];
        [array removeObjectAtIndex:indexPath.row];
        [self.subCategories removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (array.count == 0)
        {
            [tableView reloadData];
            
            [self presentMessage];
        }
        // tell table to refresh now
        [self.goButton setEnabled:[self evaluateButtonState]];
        [self.clearButton setEnabled:[self evaluateButtonState]];
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
    
    UINib *headerView = [UINib nibWithNibName:kTableViewSectionHeaderView bundle:nil];
    [self.tableView registerNib:headerView forHeaderFooterViewReuseIdentifier:kTableViewSectionHeaderView];
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
    
    self.tableView.sectionHeaderHeight = 44.f;
    
    self.resultsArray = [NSMutableArray array];
    self.subCategories = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveBusinessesNotification:)
                                                 name:@"BVTReceivedBusinessesNotification"
                                               object:nil];
    
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.goButton setEnabled:[self evaluateButtonState]];
    [self.clearButton setEnabled:[self evaluateButtonState]];
}

- (void)didReceiveBusinessesNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"BVTReceivedBusinessesNotification"])
    {
        i++;
        YLPSearch *searchObject = notification.object;
        
        for (NSString *category in self.subCategories)
        {
            for (YLPBusiness *biz in searchObject.businesses)
            {
                BOOL isDuplicate = NO;
                if (self.resultsArray.count > 0)
                {
                    for (NSDictionary *dict in self.resultsArray)
                    {
                        YLPBusiness *bizz = [[dict allValues] lastObject];
                        if ([[biz.location.address lastObject] isEqualToString:[bizz.location.address lastObject]] && [[dict allKeys] lastObject] == category)
                        {
                            isDuplicate = YES;
                        }
                    }
                }

                if (isDuplicate == NO)
                {
                    if ([[biz.categories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", category]] lastObject])
                    {
                        [self.resultsArray addObject:[NSDictionary dictionaryWithObject:biz forKey:category]];
                    }
                }
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (i == self.subCategories.count)
        {
            if (self.resultsArray.count == 0)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No results were found for the selected category(s)" message:@"Please select another category" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
//                [self.goButton setEnabled:YES];
            }
            else
            {
                for (NSString *category in self.subCategories)
                {
                    NSArray *array = [self.resultsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self CONTAINS[cd] %K", category]];
                    // TODO:figure out sorting here
                    [dict setObject:array forKey:category];
                }
                
                [self performSegueWithIdentifier:@"ShowRecommendations" sender:dict];
//                [self.goButton setEnabled:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // code here
                [self _hideHUD];
            });
        }
    }
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedArray2 = [[self.catDict allKeys] sortedArrayUsingDescriptors: @[descriptor]];
    NSString *key = [sortedArray2 objectAtIndex:section];
    NSArray *values = [self.catDict valueForKey:key];
    for (NSString *category in values)
    {
        if (![self.subCategories containsObject:category])
        {
            [self.subCategories addObject:category];
        }
    }
    return values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedArray2 = [[self.catDict allKeys] sortedArrayUsingDescriptors: @[descriptor]];
    NSString *key = [sortedArray2 objectAtIndex:indexPath.section];
    NSArray *values = [self.catDict valueForKey:key];
    NSArray *valuesToDisplay = [values sortedArrayUsingDescriptors: @[descriptor]];
    
    cell.textLabel.text = [valuesToDisplay objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get destination view
    BVTSurpriseRecommendationsTableViewController *vc = [segue destinationViewController];
    vc.businessOptions = sender;
}

@end
