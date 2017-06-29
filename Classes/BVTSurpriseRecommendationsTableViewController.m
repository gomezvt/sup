//
//  BVTSurpriseRecommendationsTableViewController.m
//  bvt
//
//  Created by Greg on 4/8/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTSurpriseRecommendationsTableViewController.h"

#import "BVTHeaderTitleView.h"
#import "BVTStyles.h"
#import "YLPBusiness.h"
#import "BVTThumbNailTableViewCell.h"
#import "BVTHUDView.h"
#import "AppDelegate.h"
#import "YLPReview.h"
#import "YLPUser.h"
#import "YLPBusinessReviews.h"
#import "YLPClient+Reviews.h"
#import "YLPClient+Business.h"
#import "BVTDetailTableViewController.h"
#import "BVTTableViewSectionHeaderView.h"
#import "BVTThumbNailTableViewCell.h"
@import GoogleMobileAds;

@interface BVTSurpriseRecommendationsTableViewController ()
<BVTHUDViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) BVTHUDView *hud;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, strong) NSMutableDictionary *orderedDict;
@property (nonatomic) BOOL isLargePhone;
@property (nonatomic) BOOL didSelectBiz;
@property (nonatomic, strong) GADBannerView *bannerView;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kThumbNailCell = @"BVTThumbNailTableViewCell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation BVTSurpriseRecommendationsTableViewController

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

    self.orderedDict = [NSMutableDictionary dictionary];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedArray2 = [[self.businessOptions allKeys] sortedArrayUsingDescriptors: @[descriptor]];
    NSString *key = [sortedArray2 objectAtIndex:section];
    NSArray *values = [self.businessOptions valueForKey:key];
    
    if (values.count > 0)
    {
        return key;
    }
    
    return nil;
}

- (IBAction)didTapBack:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapBackWithDetails:)])
    {
        [self.delegate didTapBackWithDetails:self.cachedDetails];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *view = self.tabBarController.selectedViewController.view;
    UIView *bannerSpace = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 61.f, view.frame.size.width, 61.f)];
    bannerSpace.backgroundColor = [UIColor whiteColor];
    [view addSubview:bannerSpace];
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    
    [bannerSpace addSubview:self.bannerView];
    
    [self.bannerView setFrame:CGRectMake(0, 0, bannerSpace.frame.size.width, self.bannerView.frame.size.height)];
    
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60.f, 0);

    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    if (mainScreen.size.width > 375.f)
    {
        self.isLargePhone = YES;
    }
    else
    {
        self.isLargePhone = NO;
    }
    
    self.tableView.tableFooterView = [UIView new];
    
    
    if (!self.cachedDetails)
    {
        self.cachedDetails = [[NSMutableArray alloc] init];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.businessOptions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedArray2 = [[self.businessOptions allKeys] sortedArrayUsingDescriptors: @[descriptor]];
    NSString *key = [sortedArray2 objectAtIndex:section];
    NSArray *values = [self.businessOptions valueForKey:key];
    
    return values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BVTThumbNailTableViewCell *cell = (BVTThumbNailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedArray2 = [[self.businessOptions allKeys] sortedArrayUsingDescriptors: @[descriptor]];
    NSString *key = [sortedArray2 objectAtIndex:indexPath.section];
    NSArray *values = [self.businessOptions valueForKey:key];
    
    if (values.count > 0)
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in values)
        {
            [tempArray addObject:[[dict allValues] lastObject]];
        }
        
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortedArray2 = [tempArray sortedArrayUsingDescriptors: @[descriptor]];
        
        __block YLPBusiness *biz = [sortedArray2 objectAtIndex:indexPath.row];
        YLPBusiness *cachedBiz = [[self.cachedDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", biz.identifier]] lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            cell.openCloseLabel.text = @"";
            cell.secondaryOpenCloseLabel.text = @"";
            cell.thumbNailView.image = [UIImage imageNamed:@"placeholder"];
        });
        
        if (cachedBiz && cachedBiz.didGetDetails)
        {
            biz = cachedBiz;
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (cell.tag == indexPath.row)
                {
                    cell.thumbNailView.image = cachedBiz.bizThumbNail;
                    
                    if (!self.isLargePhone)
                    {
                        if (cachedBiz.isOpenNow)
                        {
                            cell.secondaryOpenCloseLabel.text = @"Open Now";
                            cell.secondaryOpenCloseLabel.textColor = [BVTStyles iconGreen];
                        }
                        else if (cachedBiz.hoursItem && !cachedBiz.isOpenNow)
                        {
                            cell.secondaryOpenCloseLabel.text = @"Closed Now";
                            cell.secondaryOpenCloseLabel.textColor = [UIColor redColor];
                        }
                    }
                    else
                    {
                        if (cachedBiz.isOpenNow)
                        {
                            cell.openCloseLabel.text = @"Open Now";
                            cell.openCloseLabel.textColor = [BVTStyles iconGreen];
                        }
                        else if (cachedBiz.hoursItem && !cachedBiz.isOpenNow)
                        {
                            cell.openCloseLabel.text = @"Closed Now";
                            cell.openCloseLabel.textColor = [UIColor redColor];
                        }
                    }
                }
            });
        }
        else if (!self.didSelectBiz)
        {
            __weak typeof(self) weakSelf = self;
            
            [[AppDelegate yelp] businessWithId:biz.identifier completionHandler:^
             (YLPBusiness *business, NSError *error) {
                 
                 if ([biz.identifier isEqualToString:business.identifier])
                 {
                     business.miles = biz.miles;
                 }
                 
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
                                         [weakSelf.cachedDetails addObject:business];
                                         
                                         biz = business;
                                         
                                         if (!weakSelf.isLargePhone)
                                         {
                                             if (business.isOpenNow)
                                             {
                                                 cell.secondaryOpenCloseLabel.text = @"Open Now";
                                                 cell.secondaryOpenCloseLabel.textColor = [BVTStyles iconGreen];
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
                                                 cell.openCloseLabel.textColor = [BVTStyles iconGreen];
                                             }
                                             else if (business.hoursItem && !business.isOpenNow)
                                             {
                                                 cell.openCloseLabel.text = @"Closed Now";
                                                 cell.openCloseLabel.textColor = [UIColor redColor];
                                             }
                                         }
                                     }
                                 });
                             }
                         });
                     }
                 }
             }];
        }
        
        cell.business = biz;
    }
    
    return cell;
}

- (void)_hideHud
{
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    
    [self.hud removeFromSuperview];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.didCancelRequest = NO;
    self.didSelectBiz = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backChevron.enabled = NO;
        self.hud = [BVTHUDView hudWithView:self.navigationController.view];
        self.hud.delegate = self;
        self.tableView.userInteractionEnabled = NO;
        self.tabBarController.tabBar.userInteractionEnabled = NO;
    });

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedArray2 = [[self.businessOptions allKeys] sortedArrayUsingDescriptors: @[descriptor]];
    NSString *key = [sortedArray2 objectAtIndex:indexPath.section];
    NSArray *values = [self.businessOptions valueForKey:key];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    if (values.count > 0)
    {
        for (NSDictionary *dict in values)
        {
            [tempArray addObject:[[dict allValues] lastObject]];
        }
    }
    
    NSSortDescriptor *descriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors: @[descriptor2]];
    
    YLPBusiness *selectedBusiness = [sortedArray objectAtIndex:indexPath.row];
    YLPBusiness *cachedBiz = [[self.cachedDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", selectedBusiness.identifier]] lastObject];
            __weak typeof(self) weakSelf = self;

    if (cachedBiz)
    {
        [[AppDelegate yelp] reviewsForBusinessWithId:cachedBiz.identifier
                                           completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
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
                                                       // *** Get review user photos in advance if they exist, to display from Presentation VC
                                                       dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                                                           
                                                           NSMutableArray *userPhotos = [NSMutableArray array];
                                                           for (YLPReview *review in reviews.reviews)
                                                           {
                                                               YLPUser *user = review.user;
                                                               if (user.imageURL)
                                                               {
                                                                   NSData *imageData = [NSData dataWithContentsOfURL:user.imageURL];
                                                                   UIImage *image = [UIImage imageNamed:@"user"];
                                                                   if (imageData)
                                                                   {
                                                                       image = [UIImage imageWithData:imageData];
                                                                   }
                                                                   [userPhotos addObject:[NSDictionary dictionaryWithObject:image forKey:user.imageURL]];
                                                                   }
                                                           }
                                                           cachedBiz.reviews = reviews.reviews;
                                                           cachedBiz.userPhotosArray = userPhotos;
                                                       });
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^(void){

                                                           if (!weakSelf.didCancelRequest)
                                                           {
                                                               [weakSelf _hideHud];
                                                               
                                                               [weakSelf performSegueWithIdentifier:kShowDetailSegue sender:cachedBiz];
                                                           }
                                                       });
                                                   }
                                                   
                                               });
                                           }];
    }
    else
    {
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
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^(void){
                                     if ([[business.photos lastObject] isKindOfClass:[UIImage class]])
                                     {
                                         [[NSNotificationCenter defaultCenter]
                                          postNotificationName:@"receivedBizPhotos"
                                          object:self];
                                     }
                                 });
                             }
                         }
                     });
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
                                                                                UIImage *image = [UIImage imageNamed:@"user"];
                                                                                if (imageData)
                                                                                {
                                                                                    image = [UIImage imageWithData:imageData];
                                                                                }
                                                                                [userPhotos addObject:[NSDictionary dictionaryWithObject:image forKey:user.imageURL]];                                                                }
                                                                        }
                                                                        business.reviews = reviews.reviews;
                                                                        business.userPhotosArray = userPhotos;
                                                                        if ([[business.userPhotosArray lastObject] isKindOfClass:[UIImage class]])
                                                                        {
                                                                            [[NSNotificationCenter defaultCenter]
                                                                             postNotificationName:@"receivedBizReviews"
                                                                             object:self];
                                                                        }
                                                                    });
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                        
                                                                        if (!weakSelf.didCancelRequest)
                                                                        {
                                                                            [weakSelf _hideHud];
                                                                            
                                                                            [weakSelf performSegueWithIdentifier:kShowDetailSegue sender:business];
                                                                        }
                                                                    });
                                                                }
                                                                
                                                            });
                                                        }];
                 }
                 
             });
             
         }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowDetailSegue])
    {
        // Get destination view
        BVTDetailTableViewController *vc = [segue destinationViewController];
        vc.selectedBusiness = sender;
    }
}

@end
