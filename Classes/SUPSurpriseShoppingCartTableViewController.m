//
//  SUPSurpriseShoppingCartTableViewController.m
//  SUP
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "SUPSurpriseShoppingCartTableViewController.h"

#import "SUPSurpriseCategoryTableViewController.h"
#import "SUPHeaderTitleView.h"
#import "SUPSurpriseRecommendationsTableViewController.h"
#import "SUPStyles.h"
#import "AppDelegate.h"
#import "YLPCategory.h"
#import "YLPSearch.h"
#import "YLPBusiness.h"
#import "YLPLocation.h"
#import "YLPClient+Search.h"
#import "SUPHUDView.h"
#import "YLPLocation.h"
#import "YLPCoordinate.h"

@interface SUPSurpriseShoppingCartTableViewController ()
<SUPHUDViewDelegate, SUPSurpriseRecommendationsTableViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;

@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, strong) SUPHUDView *hud;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) NSMutableArray *subCategories;
@property (nonatomic, strong) NSMutableArray *resultsArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;

@end

static int i = 0;
static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
//static NSString *const kTableViewSectionHeaderView = @"SUPTableViewSectionHeaderView";

@implementation SUPSurpriseShoppingCartTableViewController

- (void)didTapBackWithDetails:(NSMutableArray *)details
{
    self.cachedDetails = details;
}

- (IBAction)didTapClearAllButton:(id)sender
{
    [self.catDict removeAllObjects];
    [self.subCategories removeAllObjects];
    [self.resultsArray removeAllObjects];
    
    if ([self.delegate respondsToSelector:@selector(didRemoveObjectsFromArray:)])
    {
        [self.delegate didRemoveObjectsFromArray:self.subCategories];
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
    i = 0;
    self.didCancelRequest = YES;
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;

    [self evaluateButtonStateForButton:self.goButton];
    [self evaluateButtonStateForButton:self.clearButton];
    [self.hud removeFromSuperview];
}

- (IBAction)didTapSubmit:(id)sender
{
    [self.resultsArray removeAllObjects];
    
    i = 0;
    NSArray *array = [self.catDict allValues];
    self.hud = [SUPHUDView hudWithView:self.navigationController.view];
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
    self.tabBarController.tabBar.userInteractionEnabled = NO;

    self.backChevron.enabled = NO;
    
    __weak typeof(self) weakSelf = self;

    __block BOOL didError = NO;
    for (NSString *subCatTitle in categoryArray)
    {
        if (didError)
        {
            break;
        }
        
        [[AppDelegate yelp] searchWithLocation:kCity term:subCatTitle limit:50 offset:0 sort:YLPSortTypeDistance completionHandler:^
         (YLPSearch *searchResults, NSError *error){
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (error)
                 {
                     [weakSelf _hideHUD];

                     [weakSelf.goButton setEnabled:YES];
                     [weakSelf.clearButton setEnabled:YES];
                     
                     weakSelf.goButton.layer.borderColor = [[SUPStyles iconBlue] CGColor];
                     weakSelf.clearButton.layer.borderColor = [[SUPStyles iconBlue] CGColor];
                     
                     NSString *string = error.userInfo[@"NSLocalizedDescription"];
                     if ([string isEqualToString:@"The Internet connection appears to be offline."])
                     {
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Check your connection and try again" preferredStyle:UIAlertControllerStyleAlert];
                         
                         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                         [alertController addAction:ok];
                         
                         [weakSelf presentViewController:alertController animated:YES completion:nil];
                     }

                 }
             });
         }];
    }
}


- (void)_hideHUD
{
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;

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
    NSMutableArray *values = [[[self.catDict valueForKey:key] sortedArrayUsingDescriptors: @[descriptor]] mutableCopy];
    if (values.count > 0)
    {
        return key;
    }
    return nil;
}

- (void)presentMessage
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30.f)];
    label.text = @"Add one or more categories to submit.";
    [super.view addSubview:label];
    label.center = self.tableView.center;
    self.tableView.separatorColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];

        NSArray *sort = [[[self.catDict allKeys] sortedArrayUsingDescriptors: @[descriptor]] mutableCopy];
        NSString *key = [sort objectAtIndex:indexPath.section];
        NSMutableArray *sortedArray2 = [[self.subCategories sortedArrayUsingDescriptors: @[descriptor]] mutableCopy];

        NSString *category = [sortedArray2 objectAtIndex:indexPath.row];

        [sortedArray2 removeObject:category];
        [self.subCategories removeObject:category];
        
        NSMutableArray *array = [[[self.catDict valueForKey:key] sortedArrayUsingDescriptors: @[descriptor]] mutableCopy];
        NSString *cat = [array objectAtIndex:indexPath.row];

        [array removeObject:cat];
        
        
        [self.catDict setValue:array forKey:key];
        if ([self.delegate respondsToSelector:@selector(didRemoveObjectsFromArray:)])
        {
            [self.delegate didRemoveObjectsFromArray:self.subCategories];
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                      withRowAnimation:UITableViewRowAnimationFade];
        
        [self evaluateButtonStateForButton:self.goButton];
        [self evaluateButtonStateForButton:self.clearButton];
        

        NSArray *allValues = [self.catDict allValues];
        if (![[allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"@count > 0"]] lastObject])
        {
            [self presentMessage];
        }
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44.f;
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
    
//    UINib *headerView = [UINib nibWithNibName:kTableViewSectionHeaderView bundle:nil];
//    [self.tableView registerNib:headerView forHeaderFooterViewReuseIdentifier:kTableViewSectionHeaderView];
}

- (void)evaluateButtonStateForButton:(UIButton *)button
{
    CALayer *layer = [button layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    
    NSArray *allValues = [self.catDict allValues];
    if ([[allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"@count > 0"]] lastObject])
    {
        [button setEnabled:YES];
        [button.layer setBorderColor:[[SUPStyles iconBlue] CGColor]];
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
    
    if ([self.delegate respondsToSelector:@selector(didTapBackWithDetails:)])
    {
        [self.delegate didTapBackWithDetails:self.cachedDetails];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
        self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
    {
        self.headerTitleView.titleViewLabelConstraint.constant = 0.f;
    }
    self.tempArray = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [UIView new];

    self.tableView.sectionHeaderHeight = 44.f;
    
    self.resultsArray = [NSMutableArray array];
    self.subCategories = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveBusinessesNotification:)
                                                 name:@"SUPReceivedBusinessesSearchNotification"
                                               object:nil];
    
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (kCity)
    {
        self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@":  %@", [kCity capitalizedString]];
    }
    
    [self.tempArray removeAllObjects];
    
    [self evaluateButtonStateForButton:self.goButton];
    [self evaluateButtonStateForButton:self.clearButton];
}

- (void)didReceiveBusinessesNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"SUPReceivedBusinessesSearchNotification"])
    {
        i++;
        YLPSearch *searchObject = notification.object;
        
        for (NSString *category in self.subCategories)
        {
            for (YLPBusiness *biz in searchObject.businesses)
            {
                if ([[biz.categories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", category]] lastObject])
                {
                    if (![self.tempArray containsObject:[NSString stringWithFormat:@"%@%@", biz.identifier, category]])
                    {
                        [self.resultsArray addObject:[NSDictionary dictionaryWithObject:biz forKey:category]];
                        [self.tempArray addObject:[NSString stringWithFormat:@"%@%@", biz.identifier, category]];
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
                    [self _hideHUD];
                    [self.goButton setEnabled:YES];
                    [self.clearButton setEnabled:YES];
                    
                    self.goButton.layer.borderColor = [[SUPStyles iconBlue] CGColor];
                    self.clearButton.layer.borderColor = [[SUPStyles iconBlue] CGColor];
                    
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
                
                NSArray *allkeys = [dict allKeys];
                if (allkeys.count > 0)
                {
                    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
                    NSArray *keys = [allkeys sortedArrayUsingDescriptors: @[descriptor]];
                    
                    for (NSString *key in keys)
                    {
                        NSArray *values = [dict valueForKey:key];
                        
                        if (values.count >= 3)
                        {
                            NSDictionary *values1 = [values objectAtIndex:arc4random()%[values count]];
                            YLPBusiness *biz = [[values1 allValues] lastObject];
                            
                            NSDictionary *values2 = [values objectAtIndex:arc4random()%[values count]];
                            YLPBusiness *biz2 = [[values2 allValues] lastObject];
                            
                            NSDictionary *values3 = [values objectAtIndex:arc4random()%[values count]];
                            YLPBusiness *biz3 = [[values3 allValues] lastObject];
                            
                            if (values.count == 3 &&
                                ([biz.identifier isEqualToString:biz2.identifier] && [biz.identifier isEqualToString:biz3.identifier] &&
                                [biz2.identifier isEqualToString:biz.identifier] && [biz2.identifier isEqualToString:biz3.identifier] &&
                                [biz3.identifier isEqualToString:biz.identifier] && [biz3.identifier isEqualToString:biz2.identifier]))
                            {
                                NSMutableArray *ar = [NSMutableArray array];
                                [ar addObject:[NSDictionary dictionaryWithObject:biz forKey:key]];
                                [dict setValue:ar forKey:key];                                
                            }
                            else
                            {
                                while ([biz.identifier isEqualToString:biz2.identifier] || [biz.identifier isEqualToString:biz3.identifier] ||
                                       [biz2.identifier isEqualToString:biz.identifier] || [biz2.identifier isEqualToString:biz3.identifier] ||
                                       [biz3.identifier isEqualToString:biz.identifier] || [biz3.identifier isEqualToString:biz2.identifier])
                                {
                                    NSDictionary *values1 = [values objectAtIndex:arc4random()%[values count]];
                                    biz = [[values1 allValues] lastObject];
                                    
                                    NSDictionary *values2 = [values objectAtIndex:arc4random()%[values count]];
                                    biz2 = [[values2 allValues] lastObject];
                                    
                                    NSDictionary *values3 = [values objectAtIndex:arc4random()%[values count]];
                                    biz3 = [[values3 allValues] lastObject];
                                }
                                
                                NSArray *bizzes = @[ biz, biz2, biz3 ];
                                
                                NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                                NSArray *sortedArray2 = [bizzes sortedArrayUsingDescriptors: @[descriptor]];
                                
                                NSMutableArray *ar = [NSMutableArray array];
                                for (YLPBusiness *biz in sortedArray2)
                                {
                                    [ar addObject:[NSDictionary dictionaryWithObject:biz forKey:key]];
                                }
                                
                                [dict setValue:ar forKey:key];
                            }
                        }
                        else if (values.count == 2)
                        {
                            NSDictionary *values1 = [values firstObject];
                            YLPBusiness *biz = [[values1 allValues] firstObject];
                            
                            NSDictionary *values2 = [values lastObject];
                            YLPBusiness *biz2 = [[values2 allValues] lastObject];

                            if ([biz.identifier isEqualToString:biz2.identifier])
                            {
                                NSMutableArray *ar = [NSMutableArray array];
                                [ar addObject:[NSDictionary dictionaryWithObject:biz forKey:key]];
                                [dict setValue:ar forKey:key];
                            }
                            else
                            {
                                NSArray *bizzes = @[ biz, biz2 ];
                                
                                NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                                NSArray *sortedArray2 = [bizzes sortedArrayUsingDescriptors: @[descriptor]];
                                
                                NSMutableArray *ar = [NSMutableArray array];
                                for (YLPBusiness *biz in sortedArray2)
                                {
                                    [ar addObject:[NSDictionary dictionaryWithObject:biz forKey:key]];
                                }
                                
                                [dict setValue:ar forKey:key];
                            }

                        }
                        
                        if (!self.didCancelRequest)
                        {
                            if (key == [allkeys lastObject])
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self _hideHUD];
                                    
                                    [self performSegueWithIdentifier:@"ShowRecommendations" sender:dict];
                                });
                            }
                        }
                    }
                }
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
    NSMutableArray *values = [[[self.catDict valueForKey:key] sortedArrayUsingDescriptors: @[descriptor]] mutableCopy];
    
    
//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
//    NSMutableArray *sortedArray2 = [[self.subCategories sortedArrayUsingDescriptors: @[descriptor]] mutableCopy];

    
    
    
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
    NSMutableArray *values = [[[self.catDict valueForKey:key] sortedArrayUsingDescriptors: @[descriptor]] mutableCopy];
    
    cell.textLabel.text = [values objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get destination view
    SUPSurpriseRecommendationsTableViewController *vc = [segue destinationViewController];
    vc.delegate = self;
    vc.businessOptions = sender;
    vc.cachedDetails = self.cachedDetails;
}

@end
