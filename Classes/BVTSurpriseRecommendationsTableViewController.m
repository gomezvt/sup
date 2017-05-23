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

@interface BVTSurpriseRecommendationsTableViewController ()
<BVTHUDViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) BVTHUDView *hud;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, strong) NSMutableDictionary *orderedDict;
@property (nonatomic, strong) BVTTableViewSectionHeaderView *headerView;
@property (nonatomic) BOOL isLargePhone;

@end

static NSString *const kTableViewSectionHeaderView = @"BVTTableViewSectionHeaderView";

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kThumbNailCell = @"BVTThumbNailTableViewCell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation BVTSurpriseRecommendationsTableViewController

- (void)didTapHUDCancelButton
{
    self.didCancelRequest = YES;
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.hud removeFromSuperview];
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
    
    UINib *headerView = [UINib nibWithNibName:kTableViewSectionHeaderView bundle:nil];
    [self.tableView registerNib:headerView forHeaderFooterViewReuseIdentifier:kTableViewSectionHeaderView];
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
    
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    NSLog(@"HEIGHT %f. WIDTH %f", mainScreen.size.height, mainScreen.size.width);
    
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
        
        YLPBusiness *biz = [sortedArray2 objectAtIndex:indexPath.row];
        YLPBusiness *cachedBiz = [[self.cachedDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"phone = %@", biz.phone]] lastObject];
        if (cachedBiz)
        {
            biz = cachedBiz;
        }
        cell.business = biz;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Your Background work
            NSData *imageData = [NSData dataWithContentsOfURL:biz.imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update your UI
                if (cell.tag == indexPath.row)
                {
                    if (imageData)
                    {
                        UIImage *image = [UIImage imageWithData:imageData];
                        cell.thumbNailView.image = image;
                    }
                    else
                    {
                        cell.thumbNailView.image = [UIImage imageNamed:@"placeholder"];
                    }
                }
            });
        });
        
        if (!self.isLargePhone)
        {
            cell.openCloseLabel.hidden = YES;
            cell.secondaryOpenCloseLabel.hidden = NO;
            cell.secondaryOpenCloseLabel.text = @"";
        }
        else
        {
            cell.openCloseLabel.hidden = NO;
            cell.openCloseLabel.text = @"";
            cell.secondaryOpenCloseLabel.hidden = YES;
        }
        
        if (!cachedBiz)
        {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[AppDelegate sharedClient] businessWithId:biz.identifier completionHandler:^
                 (YLPBusiness *business, NSError *error) {
                     
                     // *** Get business photos in advance if they exist, to display from Presentation VC
                     if (business.photos.count > 0)
                     {
                         NSMutableArray *photosArray = [NSMutableArray array];
                         for (NSString *photoStr in business.photos)
                         {
                             NSURL *url = [NSURL URLWithString:photoStr];
                             NSData *imageData = [NSData dataWithContentsOfURL:url];
                             UIImage *image = [UIImage imageNamed:@"placeholder"];
                             if (imageData)
                             {
                                 image = [UIImage imageWithData:imageData];
                             }
                             [photosArray addObject:image];
                         }
                         
                         business.photos = photosArray;
                     }
                     
                     if (![weakSelf.cachedDetails containsObject:business])
                     {
                         if (business)
                         {
                             [weakSelf.cachedDetails addObject:business];
                         }
                     }
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if (!self.isLargePhone)
                         {
                             if (!business.hoursItem)
                             {
                                 cell.secondaryOpenCloseLabel.text = @"";
                             }
                             else if (business.isOpenNow)
                             {
                                 cell.secondaryOpenCloseLabel.text = @"Open Now";
                                 cell.secondaryOpenCloseLabel.textColor = [BVTStyles iconGreen];
                             }
                             else
                             {
                                 cell.secondaryOpenCloseLabel.text = @"Closed Now";
                                 cell.secondaryOpenCloseLabel.textColor = [UIColor redColor];
                             }
                         }
                         else
                         {
                             if (!business.hoursItem)
                             {
                                 cell.openCloseLabel.text = @"";
                             }
                             else if (business.isOpenNow)
                             {
                                 cell.openCloseLabel.text = @"Open Now";
                                 cell.openCloseLabel.textColor = [BVTStyles iconGreen];
                             }
                             else
                             {
                                 cell.openCloseLabel.text = @"Closed Now";
                                 cell.openCloseLabel.textColor = [UIColor redColor];
                             }
                         }
                         [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                     });
                 }];
            });
        }
        else
        {
            if (!self.isLargePhone)
            {
                if (!cachedBiz.hoursItem)
                {
                    cell.secondaryOpenCloseLabel.text = @"";
                }
                else if (cachedBiz.isOpenNow)
                {
                    cell.secondaryOpenCloseLabel.text = @"Open Now";
                    cell.secondaryOpenCloseLabel.textColor = [BVTStyles iconGreen];
                }
                else
                {
                    cell.secondaryOpenCloseLabel.text = @"Closed Now";
                    cell.secondaryOpenCloseLabel.textColor = [UIColor redColor];
                }
            }
            else
            {
                if (!cachedBiz.hoursItem)
                {
                    cell.openCloseLabel.text = @"";
                }
                else if (cachedBiz.isOpenNow)
                {
                    cell.openCloseLabel.text = @"Open Now";
                    cell.openCloseLabel.textColor = [BVTStyles iconGreen];
                }
                else
                {
                    cell.openCloseLabel.text = @"Closed Now";
                    cell.openCloseLabel.textColor = [UIColor redColor];
                }
                
            }
        }
        
    }
    
    return cell;
}

- (void)_hideHud
{
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.hud removeFromSuperview];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.hud = [BVTHUDView hudWithView:self.navigationController.view];
    self.hud.delegate = self;
    
    self.didCancelRequest = NO;
    self.tableView.userInteractionEnabled = NO;
    self.backChevron.enabled = NO;
    
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
    YLPBusiness *cachedBiz = [[self.cachedDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"phone = %@", selectedBusiness.phone]] lastObject];
    if (cachedBiz)
    {
        selectedBusiness = cachedBiz;
        __weak typeof(self) weakSelf = self;
        [[AppDelegate sharedClient] reviewsForBusinessWithId:selectedBusiness.identifier
                                           completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   if (error) {
                                                       [weakSelf _hideHud];
                                                       
                                                       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                       
                                                       UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                       [alertController addAction:ok];
                                                       
                                                       [weakSelf presentViewController:alertController animated:YES completion:nil];
                                                       
                                                   }
                                                   else
                                                   {
                                                       // *** Get review user photos in advance if they exist, to display from Presentation VC
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
                                                       selectedBusiness.reviews = reviews.reviews;
                                                       selectedBusiness.userPhotosArray = userPhotos;
                                                       
                                                       if (!weakSelf.didCancelRequest)
                                                       {
                                                           [weakSelf _hideHud];
                                                           
                                                           [weakSelf performSegueWithIdentifier:kShowDetailSegue sender:selectedBusiness];
                                                       }
                                                   }
                                                   
                                               });
                                           }];
        
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
         (YLPBusiness *business, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error) {
                     [weakSelf _hideHud];
                     
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [weakSelf presentViewController:alertController animated:YES completion:nil];
                 }
                 else
                 {
                     // *** Get business photos in advance if they exist, to display from Presentation VC
                     if (business.photos.count > 0)
                     {
                         NSMutableArray *photosArray = [NSMutableArray array];
                         for (NSString *photoStr in business.photos)
                         {
                             NSURL *url = [NSURL URLWithString:photoStr];
                             NSData *imageData = [NSData dataWithContentsOfURL:url];
                             UIImage *image = [UIImage imageNamed:@"placeholder"];
                             if (imageData)
                             {
                                 image = [UIImage imageWithData:imageData];
                             }
                             [photosArray addObject:image];
                         }
                         
                         business.photos = photosArray;
                     }
                     
                     [[AppDelegate sharedClient] reviewsForBusinessWithId:business.identifier
                                                        completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                if (error) {
                                                                    [weakSelf _hideHud];
                                                                    
                                                                    
                                                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                                    
                                                                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                                    [alertController addAction:ok];
                                                                    
                                                                    [weakSelf presentViewController:alertController animated:YES completion:nil];
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // *** Get review user photos in advance if they exist, to display from Presentation VC
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
                                                                    
                                                                    if (!weakSelf.didCancelRequest)
                                                                    {
                                                                        [weakSelf _hideHud];
                                                                        
                                                                        [weakSelf performSegueWithIdentifier:kShowDetailSegue sender:business];
                                                                    }
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
