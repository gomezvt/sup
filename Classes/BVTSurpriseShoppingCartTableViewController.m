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
#import "YLPLocation.h"
#import "YLPCoordinate.h"

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
    
    self.clearButton.enabled = NO;
    self.goButton.enabled = NO;
    
    self.clearButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.goButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self presentMessage];
}


- (void)didTapHUDCancelButton
{
    self.didCancelRequest = YES;
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    [self evaluateButtonStateForButton:self.goButton];
    [self evaluateButtonStateForButton:self.clearButton];
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
    
    self.goButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.clearButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
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
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error)
                 {
                     [self _hideHUD];
                     
                     NSLog(@"Error %@", error.localizedDescription);
                     
                     [self.goButton setEnabled:YES];
                     [self.clearButton setEnabled:YES];
                     
                     self.goButton.layer.borderColor = [[BVTStyles iconGreen] CGColor];
                     self.clearButton.layer.borderColor = [[BVTStyles iconGreen] CGColor];
                 }
             });
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
    label.text = @"Add a category to submit.";
    [super.view addSubview:label];
    label.center = self.tableView.center;
    self.tableView.separatorColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
//        NSArray *sortedArray2 = [[self.businessOptions allKeys] sortedArrayUsingDescriptors: @[descriptor]];
//        NSString *key = [sortedArray2 objectAtIndex:indexPath.section];
//        NSArray *values = [self.businessOptions valueForKey:key];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        NSArray *sortedArray2 = [[self.catDict allKeys] sortedArrayUsingDescriptors: @[descriptor]];
        NSString *key = [sortedArray2 objectAtIndex:indexPath.section];
        
        NSMutableArray *array = [self.catDict valueForKey:key];
        [array removeObjectAtIndex:indexPath.row];
        [self.subCategories removeObjectAtIndex:indexPath.row];
        
        // tell table to refresh now
        [self evaluateButtonStateForButton:self.goButton];
        [self evaluateButtonStateForButton:self.clearButton];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];

        BOOL containsValues = [[[self.catDict allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"@count > 0"]] lastObject];

        if (!containsValues)
        {
            [self presentMessage];
        }
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

- (void)evaluateButtonStateForButton:(UIButton *)button
{
    CALayer *layer = [button layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    
    NSArray *allValues = [self.catDict allValues];
    BOOL containsValues = [[allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"@count > 0"]] lastObject];
    
    if (containsValues)
    {
        [button setEnabled:YES];
        [button.layer setBorderColor:[[BVTStyles iconGreen] CGColor]];
    }
    else
    {
        [button setEnabled:NO];
        [button.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    }
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
                                                 name:@"BVTReceivedBusinessesSearchNotification"
                                               object:nil];
    
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self evaluateButtonStateForButton:self.goButton];
    [self evaluateButtonStateForButton:self.clearButton];
}

- (void)didReceiveBusinessesNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"BVTReceivedBusinessesSearchNotification"])
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
                        if ([biz.phone isEqualToString:bizz.phone] && [[dict allKeys] lastObject] == category)
                        {
                            isDuplicate = YES;
                        }
                    }
                }
                
                if (isDuplicate == NO)
                {
                    if ([[biz.categories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", category]] lastObject])
                    {
                        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        
                        CLLocation *bizLocation = [[CLLocation alloc] initWithLatitude:biz.location.coordinate.latitude longitude:biz.location.coordinate.longitude];
                        CLLocationDistance meters = [appDel.userLocation distanceFromLocation:bizLocation];
                        
                        double miles = meters / 1609.34;
                        biz.miles = miles;
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    // code here
                    [self.goButton setEnabled:YES];
                    [self.clearButton setEnabled:YES];
                    
                    self.goButton.layer.borderColor = [[BVTStyles iconGreen] CGColor];
                    self.clearButton.layer.borderColor = [[BVTStyles iconGreen] CGColor];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No results were found for the selected category(s)" message:@"Please select another category" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            }
            else
            {
                
                
                for (NSString *category in self.subCategories)
                {
                    NSArray *array = [self.resultsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self CONTAINS[cd] %K", category]];
                    
 
                    
                    // TODO:figure out sorting here
                    [dict setObject:array forKey:category];
                }
                
                for (NSString *key in [dict allKeys])
                {

                    
                    NSArray *values = [dict valueForKey:key];

                    
                    if (values.count > 3)
                    {
                        NSDictionary *values1 = [values objectAtIndex:arc4random()%[values count]];
                        YLPBusiness *biz = [[values1 allValues] lastObject];
                        
                        NSDictionary *values2 = [values objectAtIndex:arc4random()%[values count]];
                        YLPBusiness *biz2 = [[values2 allValues] lastObject];
                        
                        NSDictionary *values3 = [values objectAtIndex:arc4random()%[values count]];
                        YLPBusiness *biz3 = [[values3 allValues] lastObject];
                        
                        if (![biz isKindOfClass:[NSNull class]] && ![biz2 isKindOfClass:[NSNull class]] && ![biz3 isKindOfClass:[NSNull class]])
                        {
                            if ([biz.phone isEqualToString:biz2.phone] || [biz.phone isEqualToString:biz3.phone] ||
                                [biz2.phone isEqualToString:biz.phone] || [biz2.phone isEqualToString:biz3.phone] ||
                                [biz3.phone isEqualToString:biz.phone] || [biz3.phone isEqualToString:biz2.phone])
                            {
                                return;
                            }
                            
                            NSMutableArray *ar2 = [NSMutableArray array];
                            [ar2 addObject:biz];
                            [ar2 addObject:biz2];
                            [ar2 addObject:biz3];
                            
                            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                            NSArray *sortedArray2 = [ar2 sortedArrayUsingDescriptors: @[descriptor]];
                            
                            NSMutableArray *ar = [NSMutableArray array];
                            for (YLPBusiness *biz in sortedArray2)
                            {
                                [ar addObject:[NSDictionary dictionaryWithObject:biz forKey:key]];
                            }
                            
                            if (ar.count == 3)
                            {
                                [dict setValue:ar forKey:key];
                            }
                        }
                        
                    }
                    else if (values.count > 0)
                    {
                        NSMutableArray *arra = [NSMutableArray array];
                        for (NSDictionary *dict in values)
                        {
                            YLPBusiness *biz = [[dict allValues] lastObject];
                            [arra addObject:biz];
                        }
                        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                        NSArray *sortedArray2 = [arra sortedArrayUsingDescriptors: @[descriptor]];
                        
                        NSMutableArray *ar = [NSMutableArray array];
                        for (YLPBusiness *biz in sortedArray2)
                        {
                            [ar addObject:[NSDictionary dictionaryWithObject:biz forKey:key]];
                        }
                        
                        [dict setValue:ar forKey:key];
                    }
                }
                [self performSegueWithIdentifier:@"ShowRecommendations" sender:dict];

                
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self _hideHUD];
                });
            }
            

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
