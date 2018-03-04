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

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) SUPHUDView *hud;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic) BOOL isLargePhone;
@property (nonatomic) BOOL didSelectBiz;
@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;
@property (nonatomic, strong) NSMutableArray *faves;
@property (nonatomic, weak) IBOutlet UILabel *faveslabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kThumbNailCell = @"SUPThumbNailTableViewCell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation SUPFavoritesTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowDetailSegue])
    {
        // Get destination view
        SUPDetailTableViewController *vc = [segue destinationViewController];
        vc.isViewingFavorites = YES;
        vc.selectedBusiness = sender;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.didCancelRequest = NO;
    self.didSelectBiz = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backChevron.enabled = NO;
        self.hud = [SUPHUDView hudWithView:self.navigationController.view];
        self.hud.delegate = self;
        self.tableView.userInteractionEnabled = NO;
        self.tabBarController.tabBar.userInteractionEnabled = NO;
    });
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YLPBusiness *selectedBusiness = [self.faves objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    
    [[AppDelegate yelp] businessWithId:selectedBusiness.identifier completionHandler:^
     (YLPBusiness *business, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *string = error.userInfo[@"NSLocalizedDescription"];
             
             if ([string isEqualToString:@"The Internet connection appears to be offline."])
             {
                 [weakSelf _hideHud];
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Check your connection and try again" preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 
                 [weakSelf presentViewController:alertController animated:YES completion:nil];
                 
             }
             else
             {
                 dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                     [[AppDelegate yelp] reviewsForBusinessWithId:business.identifier
                                                completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^(void){
                                                        NSString *string = error.userInfo[@"NSLocalizedDescription"];
                                                        
                                                        if ([string isEqualToString:@"The Internet connection appears to be offline."])
                                                        {
                                                            [weakSelf _hideHud];
                                                            
                                                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Check your connection and try again" preferredStyle:UIAlertControllerStyleAlert];
                                                            
                                                            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                            [alertController addAction:ok];
                                                            
                                                            [weakSelf presentViewController:alertController animated:YES completion:nil];
                                                            
                                                        }
                                                        else
                                                        {
                                                            // *** Get review user photos in advance if they exist, to display from Presentation VC
                                                            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                                                                
                                                                NSMutableArray *userPhotos = [NSMutableArray array];
                                                                for (YLPReview *review in reviews.reviews)
                                                                {
                                                                    YLPUser *user = review.user;
                                                                    if (user.imageURL)
                                                                    {
                                                                        NSData *imageData = [NSData dataWithContentsOfURL:user.imageURL];
                                                                        UIImage *image = [UIImage imageNamed:@"placeholder"];
                                                                        if (imageData)
                                                                        {
                                                                            image = [UIImage imageWithData:imageData];
                                                                        }
                                                                        [userPhotos addObject:[NSDictionary dictionaryWithObject:image forKey:user.imageURL]];                                                                }
                                                                }
                                                                business.reviews = reviews.reviews;
                                                                business.userPhotosArray = userPhotos;
                                                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                    // *** Get business photos in advance if they exist, to display from Presentation VC
                                                                    if (business.photos.count > 0)
                                                                    {
                                                                        if ([[business.photos firstObject] isKindOfClass:[NSString class]])
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
                                                                            
                                                                            if ([[business.photos lastObject] isKindOfClass:[UIImage class]])
                                                                            {
                                                                                [[NSNotificationCenter defaultCenter]
                                                                                 postNotificationName:@"receivedBizPhotos"
                                                                                 object:self];
                                                                            }
                                                                            
                                                                            if (!weakSelf.didCancelRequest)
                                                                            {
                                                                                [weakSelf _hideHud];
                                                                                
                                                                                [weakSelf performSegueWithIdentifier:kShowDetailSegue sender:business];
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                    else
                                                                    {
                                                                        
                                                                        
                                                                        if (!weakSelf.didCancelRequest)
                                                                        {
                                                                            [weakSelf _hideHud];
                                                                            
                                                                            [weakSelf performSegueWithIdentifier:kShowDetailSegue sender:business];
                                                                        }
                                                                    }
                                                                    
                                                                });
                                                            });
                                                            
                                                            
                                                        }
                                                        
                                                    });
                                                }];
                     
                     
                 });
                 
             }
             
         });
         
     }];
}

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionHeaderHeight = 44.f;
    
    UINib *cellNib = [UINib nibWithNibName:kThumbNailCell bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.headerTitleView.cityNameLabel.text = @"Sup? City";
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
    
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
        self.headerTitleView.leadingEdgeConstraint.constant = -15.f;
        
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
    
    NSData *unarchived = [[NSUserDefaults standardUserDefaults] objectForKey:@"faves"];
    self.faves = [NSKeyedUnarchiver unarchiveObjectWithData:unarchived];
    if (!self.faves)
    {
        self.faves = [[NSMutableArray alloc] init];
    }
    
    [self.tableView reloadData];
    
    if (self.faves.count == 0)
    {
        self.faveslabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.faveslabel.numberOfLines = 0.f;
        self.faveslabel.center = super.view.center;
        self.tableView.separatorColor = [UIColor clearColor];
        self.faveslabel.textAlignment = NSTextAlignmentCenter;
        self.faveslabel.textColor = [UIColor lightGrayColor];
        self.faveslabel.text = @"You have no favorites to display. To add a place, tap one to navigate to its details screen and then toggle the 'Add to my Favorites' switch.";
        [self.view bringSubviewToFront:self.faveslabel];
    }
    else
    {
        self.faveslabel.text = @"";
    }
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
