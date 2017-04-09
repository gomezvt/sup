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
#import "YLPClient+Search.h"
#import "BVTHUDView.h"

@interface BVTSurpriseShoppingCartTableViewController ()
<BVTHUDViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, strong) BVTHUDView *hud;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) NSMutableDictionary *mutDict;
@property (nonatomic, strong) NSMutableArray *subCategories;

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
    
    self.tableView.userInteractionEnabled = NO;
    self.backChevron.enabled = NO;
    
    for (NSString *subCatTitle in categoryArray)
    {
        [[AppDelegate sharedClient] searchWithLocation:@"Burlington, VT" term:subCatTitle limit:50 offset:0 sort:YLPSortTypeDistance completionHandler:^
         (YLPSearch *searchResults, NSError *error){
             if (subCatTitle == [categoryArray lastObject])
             {
                 [self _hideHUD];
             }
             else if (error)
             {
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 
                 [self _hideHUD];
             }
         }];
    }
}

- (void)_hideHUD
{
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
//    [self.hud removeFromSuperview];
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
    
    self.subCategories = [NSMutableArray array];
    self.mutDict = [[NSMutableDictionary alloc] init];;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveBusinessesNotification:)
                                                 name:@"BVTReceivedBusinessesNotification"
                                               object:nil];

    
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

}

- (void)_presentBusinessOptions:(NSMutableArray *)array
{

}

- (void)didReceiveBusinessesNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"BVTReceivedBusinessesNotification"])
    {
        static int i = 0;
        i++;
        NSMutableArray *resultsArray = [NSMutableArray array];
        YLPSearch *searchObject = notification.object;
        for (YLPBusiness *biz in searchObject.businesses)
        {
            for (YLPCategory *category in biz.categories)
            {
                if ([self.subCategories containsObject:category.name])
                {
                    [resultsArray addObject:[NSDictionary dictionaryWithObject:biz forKey:category.name]];
                }
            }
        }
        
        if (i == self.subCategories.count)
        {
            i = 0;
            [self performSegueWithIdentifier:@"ShowRecommendations" sender:resultsArray];
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
    NSString *key = [self.catDict allKeys][section];
    NSArray *k = [self.catDict objectForKey:key];
    for (NSString *category in k)
    {
        if (![self.subCategories containsObject:category])
        {
            [self.subCategories addObject:category];
        }
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get destination view
    BVTSurpriseRecommendationsTableViewController *vc = [segue destinationViewController];
}

@end
