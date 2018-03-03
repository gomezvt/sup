//
//  SUPFavoritesTableViewController.m
//  sup
//
//  Created by Greg on 3/1/18.
//  Copyright © 2018 gms. All rights reserved.
//

#import "SUPFavoritesTableViewController.h"

#import "SUPHeaderTitleView.h"
#import "SUPStyles.h"
#import "YLPBusiness.h"
#import "SUPThumbNailTableViewCell.h"
#import "SUPHUDView.h"
#import "AppDelegate.h"
#import "YLPReview.h"
#import "YLPUser.h"
#import "YLPBusinessReviews.h"
#import "YLPClient+Reviews.h"
#import "YLPClient+Business.h"
#import "SUPDetailTableViewController.h"
#import "SUPTableViewSectionHeaderView.h"
#import "SUPThumbNailTableViewCell.h"

@interface SUPFavoritesTableViewController ()
<SUPHUDViewDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) SUPHUDView *hud;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic) BOOL isLargePhone;
@property (nonatomic) BOOL didSelectBiz;
@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;
@property (nonatomic, strong) NSMutableArray *faves;

@end

static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kThumbNailCell = @"SUPThumbNailTableViewCell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation SUPFavoritesTableViewController

- (void)didTapHUDCancelButton
{
    self.didCancelRequest = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.backChevron.enabled = YES;
        self.tableView.userInteractionEnabled = YES;
        self.tabBarController.tabBar.userInteractionEnabled = YES;
        [self.hud removeFromSuperview];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *unarchived = [[NSUserDefaults standardUserDefaults] objectForKey:@"faves"];
    self.faves = [NSKeyedUnarchiver unarchiveObjectWithData:unarchived];
    if (!self.faves)
    {
        self.faves = [[NSMutableArray alloc] init];
    }
    
    self.tableView.sectionHeaderHeight = 44.f;
    
    UINib *cellNib = [UINib nibWithNibName:kThumbNailCell bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.faves.count;
}

- (void)_hideHud
{
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    
    [self.hud removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SUPThumbNailTableViewCell *cell = (SUPThumbNailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    if (self.faves.count > 0)
    {
        __block YLPBusiness *biz = [self.faves objectAtIndex:indexPath.row];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            cell.openCloseLabel.text = @"";
            cell.secondaryOpenCloseLabel.text = @"";
            cell.thumbNailView.image = [UIImage imageNamed:@"placeholder"];
        });
        
        __weak typeof(self) weakSelf = self;
        
        [[AppDelegate yelp] businessWithId:biz.identifier completionHandler:^
         (YLPBusiness *business, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (cell.tag == indexPath.row)
                 {
                     if ([biz.identifier isEqualToString:business.identifier])
                     {
                         business.miles = biz.miles;
                     }
                     
                     if (!weakSelf.isLargePhone)
                     {
                         if (business.isOpenNow)
                         {
                             cell.secondaryOpenCloseLabel.text = @"Open Now";
                             cell.secondaryOpenCloseLabel.textColor = [SUPStyles iconBlue];
                         }
                         else if (business.hoursItem && !business.isOpenNow)
                         {
                             cell.secondaryOpenCloseLabel.text = @"Closed Now";
                             cell.secondaryOpenCloseLabel.textColor = [UIColor redColor];
                         }
                     }
                     else
                     {
                         if (business.isOpenNow)
                         {
                             cell.openCloseLabel.text = @"Open Now";
                             cell.openCloseLabel.textColor = [SUPStyles iconBlue];
                         }
                         else if (business.hoursItem && !business.isOpenNow)
                         {
                             cell.openCloseLabel.text = @"Closed Now";
                             cell.openCloseLabel.textColor = [UIColor redColor];
                         }
                     }
                 }
             });
             
             NSString *string = error.userInfo[@"NSLocalizedDescription"];
             
             if ([string isEqualToString:@"The Internet connection appears to be offline."])
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [weakSelf _hideHud];
                     
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Check your connection and try again" preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [weakSelf presentViewController:alertController animated:YES completion:nil];
                 });
             }
             else
             {
                 if (business)
                 {
                     dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                         if (cell.tag == indexPath.row)
                         {
                             // Your Background work
                             if (business.photos.count > 0)
                             {
                                 NSMutableArray *photosArray = [NSMutableArray array];
                                 for (NSString *photoStr in business.photos)
                                 {
                                     NSURL *url = [NSURL URLWithString:photoStr];
                                     
                                     NSData *imageData = [NSData dataWithContentsOfURL:url];
                                     UIImage *image = [UIImage imageWithData:imageData];
                                     
                                     if (imageData)
                                     {
                                         [photosArray addObject:image];
                                     }
                                 }
                                 
                                 business.photos = photosArray;
                             }
                             
                             NSData *imageData = [NSData dataWithContentsOfURL:biz.imageURL];
                             dispatch_async(dispatch_get_main_queue(), ^(void){
                                 // Update your UI
                                 if (cell.tag == indexPath.row)
                                 {
                                     if (imageData)
                                     {
                                         UIImage *image = [UIImage imageWithData:imageData];
                                         business.bizThumbNail = image;
                                         cell.thumbNailView.image = image;
                                     }
                                     else
                                     {
                                         business.bizThumbNail = [UIImage imageNamed:@"placeholder"];
                                     }
                                     business.didGetDetails = YES;
                                     
                                     biz = business;
                                 }
                             });
                         }
                     });
                 }
             }
         }];
        
        cell.business = biz;
    }
    
    return cell;
}



@end
