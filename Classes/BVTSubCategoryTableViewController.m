//
//  BVTDetailTableViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTSubCategoryTableViewController.h"

#import "BVTDetailTableViewController.h"
#import "BVTHeaderTitleView.h"
#import "BVTThumbNailTableViewCell.h"
#import "YLPBusiness.h"
#import "AppDelegate.h"
#import "YLPClient+Business.h"
#import "YLPBusiness.h"
#import "YLPSearch.h"
#import "BVTHUDView.h"
#import "YLPClient+Reviews.h"
#import "YLPBusinessReviews.h"
#import "BVTStyles.h"
#import "YLPReview.h"
#import "YLPUser.h"

@interface BVTSubCategoryTableViewController ()
<BVTHUDViewDelegate>


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) BVTHUDView *hud;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, weak) IBOutlet UIButton *starSortIcon;
@property (nonatomic, strong) NSMutableArray *sortedArray;
@property (nonatomic, weak) IBOutlet UIButton *priceButton;
@property (nonatomic, weak) IBOutlet UIButton *distanceButton;
@property (nonatomic, weak) IBOutlet UIButton *openNowButton;
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic) double milesKeyValue;
@property (nonatomic, strong) NSString *priceKeyValue;
@property (nonatomic, strong) NSString *openCloseKeyValue;
@property (nonatomic, strong) NSArray *detailsArray;
@property (nonatomic, strong) NSMutableArray *displayArray;
@property (nonatomic) BOOL gotDetails;
@property (nonatomic, strong) NSMutableArray *originalFilteredResults;
@property (nonatomic) BOOL isLargePhone;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kThumbNailCell = @"BVTThumbNailTableViewCell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation BVTSubCategoryTableViewController

- (IBAction)didTapPriceButton:(id)sender
{
    if ([self.priceButton.titleLabel.text isEqualToString:@"Any $"])
    {
        self.priceKeyValue = @"$";
        [self.priceButton setTitle:@"$" forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:@"$"])
    {
        self.priceKeyValue = @"$$";
        [self.priceButton setTitle:@"$$" forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:@"$$"])
    {
        self.priceKeyValue = @"$$$";
        [self.priceButton setTitle:@"$$$" forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:@"$$$"])
    {
        self.priceKeyValue = @"$$$$";
        [self.priceButton setTitle:@"$$$$" forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:@"$$$$"])
    {
        self.priceKeyValue = @"Any $";
        [self.priceButton setTitle:@"Any $" forState:UIControlStateNormal];
    }
    
    [self sortArrayWithPredicates];
}

- (void)sortArrayWithPredicates
{
 
        NSPredicate *pricePredicate;
        
        NSMutableArray *arrayPred = [NSMutableArray array];
        if (!self.priceKeyValue)
        {
            self.priceKeyValue = @"Any $";
        }
        
        if ([self.priceKeyValue isEqualToString:@"Any $"])
        {
            pricePredicate = [NSPredicate predicateWithFormat:@"price = %@ OR price = %@ OR price = %@ OR price = %@ OR price = %@", nil, @"$", @"$$", @"$$$", @"$$$$"];
        }
        else
        {
            pricePredicate = [NSPredicate predicateWithFormat:@"price = %@", self.priceKeyValue];
        }
        
        [arrayPred addObject:pricePredicate];
        
        NSPredicate *distancePredicate;
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDel.userLocation)
        {
            self.distanceButton.hidden = NO;
            if (self.milesKeyValue == 0)
            {
                distancePredicate = [NSPredicate predicateWithFormat:@"miles >= 0"];
            }
            else
            {
                distancePredicate = [NSPredicate predicateWithFormat:@"miles <= %g", self.milesKeyValue];
            }
            
            [arrayPred addObject:distancePredicate];
        }
        else
        {
            self.distanceButton.hidden = YES;
        }
        
        NSPredicate *openClosePredicate;
        //    if (self.openNowButton.hidden == NO)
        //    {
        if (!self.openCloseKeyValue)
        {
            self.openCloseKeyValue = @"Open/Closed";
        }
        
        if ([self.openCloseKeyValue isEqualToString:@"Open"])
        {
            openClosePredicate = [NSPredicate predicateWithFormat:@"isOpenNow = %@", @(YES)];
        }
        else if ([self.openCloseKeyValue isEqualToString:@"Closed"])
        {
            openClosePredicate = [NSPredicate predicateWithFormat:@"isOpenNow = %@ && hoursItem != %@", @(NO), nil];
        }
        else if ([self.openCloseKeyValue isEqualToString:@"Open/Closed"])
        {
            openClosePredicate = [NSPredicate predicateWithFormat:@"isOpenNow = %@ OR isOpenNow = %@", @(NO), @(YES)];
        }
        
        if (openClosePredicate)
        {
            [arrayPred addObject:openClosePredicate];
        }
        //    }
    
        NSPredicate *comboPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:arrayPred];
        self.filteredResults  = [[self.originalFilteredResults filteredArrayUsingPredicate:comboPredicate] mutableCopy];
        
        if (self.filteredResults.count == 0)
        {
            self.titleLabel.text = [NSString stringWithFormat:@"%@ (0)", self.subCategoryTitle];
            self.label.text = @"No sorted results found.";
        }
        else
        {
            self.titleLabel.text = [NSString stringWithFormat:@"%@ (%lu)", self.subCategoryTitle, (unsigned long)self.filteredResults.count];
            self.label.text = @"";
        }
        
        
        [self.tableView reloadData];
    
}

- (IBAction)didTapDistanceButton:(id)sender
{
    if ([self.distanceButton.titleLabel.text isEqualToString:@"5 Miles"])
    {
        self.milesKeyValue = 10;
        [self.distanceButton setTitle:@"10 Miles" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"10 Miles"])
    {
        self.milesKeyValue = 25;
        [self.distanceButton setTitle:@"25 Miles" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"25 Miles"])
    {
        self.milesKeyValue = 50;
        [self.distanceButton setTitle:@"50 Miles" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"50 Miles"])
    {
        self.milesKeyValue = 100;
        [self.distanceButton setTitle:@"100 Miles" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"100 Miles"])
    {
        self.milesKeyValue = 0;
        [self.distanceButton setTitle:@"Any Miles" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"Any Miles"])
    {
        self.milesKeyValue = 5;
        [self.distanceButton setTitle:@"5 Miles" forState:UIControlStateNormal];
    }
    
    [self sortArrayWithPredicates];
}

- (IBAction)didTapOpenButton:(id)sender
{
    if ([self.openNowButton.titleLabel.text isEqualToString:@"Closed"])
    {
        self.openCloseKeyValue = @"Open";
        [self.openNowButton setTitle:@"Open" forState:UIControlStateNormal];
    }
    else if ([self.openNowButton.titleLabel.text isEqualToString:@"Open"])
    {
        self.openCloseKeyValue = @"Open/Closed";
        [self.openNowButton setTitle:@"Open/Closed" forState:UIControlStateNormal];
    }
    else if ([self.openNowButton.titleLabel.text isEqualToString:@"Open/Closed"])
    {
        self.openCloseKeyValue = @"Closed";
        [self.openNowButton setTitle:@"Closed" forState:UIControlStateNormal];
    }
    
    [self sortArrayWithPredicates];
}

- (IBAction)didTapStarSortIcon:(id)sender
{
    self.starSortIcon.selected = ![self.starSortIcon isSelected];
    
    if (self.gotDetails)
    {
        if (self.starSortIcon.isSelected)
        {
            NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:YES];
            self.displayArray = [[self.displayArray sortedArrayUsingDescriptors: @[nameDescriptor]] mutableCopy];
            
        }
        else
        {
            NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
            self.displayArray = [[self.displayArray sortedArrayUsingDescriptors: @[nameDescriptor]] mutableCopy];
        }
    }
    else
    {
        if (self.starSortIcon.isSelected)
        {
            NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:YES];
            self.filteredResults = [[self.filteredResults sortedArrayUsingDescriptors: @[nameDescriptor]] mutableCopy];
            
        }
        else
        {
            NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
            self.filteredResults = [self.filteredResults sortedArrayUsingDescriptors: @[nameDescriptor]];
        }
    }
    

    
    [self.tableView reloadData];
}

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.sortedArray = [NSMutableArray array];
    
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.displayArray = [[NSMutableArray alloc] init];
    
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

    self.label.text = @"";
    self.originalFilteredResults = [self.filteredResults mutableCopy];
    
    NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.filteredResults = [self.originalFilteredResults sortedArrayUsingDescriptors: @[nameDescriptor]];
    
    
    if (!self.cachedDetails)
    {
        self.cachedDetails = [[NSMutableDictionary alloc] init];
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%lu)", self.subCategoryTitle, (unsigned long)self.filteredResults.count];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDel.userLocation)
    {
        [self.distanceButton setHidden:YES];
    }
    else
    {
        [self.distanceButton setHidden:NO];
    }

    
    UINib *cellNib = [UINib nibWithNibName:kThumbNailCell bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    CALayer * layer = [self.priceButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[BVTStyles iconGreen] CGColor]];
    
    CALayer * layer2 = [self.distanceButton layer];
    [layer2 setMasksToBounds:YES];
    [layer2 setCornerRadius:10.0];
    [layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[BVTStyles iconGreen] CGColor]];
    
    CALayer * layer3 = [self.openNowButton layer];
    [layer3 setMasksToBounds:YES];
    [layer3 setCornerRadius:10.0];
    [layer3 setBorderWidth:1.0];
    [layer3 setBorderColor:[[BVTStyles iconGreen] CGColor]];
}

- (void)didTapHUDCancelButton
{
    self.didCancelRequest = YES;
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;

    [self.hud removeFromSuperview];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.hud = [BVTHUDView hudWithView:self.navigationController.view];
    self.hud.delegate = self;
    
    self.didCancelRequest = NO;
    self.tableView.userInteractionEnabled = NO;
    self.tabBarController.tabBar.userInteractionEnabled = NO;

    self.backChevron.enabled = NO;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;

    YLPBusiness *business;
    if (self.gotDetails)
    {
        business = [self.displayArray objectAtIndex:indexPath.row];
        [[AppDelegate sharedClient] reviewsForBusinessWithId:business.identifier
                                           completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   NSString *string = error.userInfo[@"NSLocalizedDescription"];
                                                   
                                                   if ([string isEqualToString:@"The Internet connection appears to be offline."])
                                                   {
                                                       [weakSelf _hideHUD];
                                                       
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
                                                               UIImage *image = [UIImage imageWithData:imageData];
                                                               [userPhotos addObject:[NSDictionary dictionaryWithObject:image forKey:user.imageURL]];
                                                           }
                                                       }
                                                       business.reviews = reviews.reviews;
                                                       business.userPhotosArray = userPhotos;
                                                       
                                                       if (!weakSelf.didCancelRequest)
                                                       {
                                                           [weakSelf _hideHUD];

                                                           // get biz photos here if we dont have them?
                                                           [weakSelf performSegueWithIdentifier:kShowDetailSegue sender:business];
                                                       }
                                                   }
                                               });
                                           }];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        business = [self.filteredResults objectAtIndex:indexPath.row];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[AppDelegate sharedClient] businessWithId:business.identifier completionHandler:^
             (YLPBusiness *detailBiz, NSError *error) {
                 NSString *string = error.userInfo[@"NSLocalizedDescription"];
                 
                 if ([string isEqualToString:@"The Internet connection appears to be offline."])
                 {
                     [weakSelf _hideHUD];
                     
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [weakSelf presentViewController:alertController animated:YES completion:nil];
                     
                 }
                 else if (detailBiz.photos.count > 0)
                 {
                     NSMutableArray *photosArray = [NSMutableArray array];
                     for (NSString *photoStr in detailBiz.photos)
                     {
                         NSURL *url = [NSURL URLWithString:photoStr];
                         NSData *imageData = [NSData dataWithContentsOfURL:url];
                         UIImage *image = [UIImage imageWithData:imageData];

                         [photosArray addObject:image];
                     }
                     
                     detailBiz.photos = photosArray;
                 }
                 
                 [[AppDelegate sharedClient] reviewsForBusinessWithId:detailBiz.identifier
                                                    completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            NSString *string = error.userInfo[@"NSLocalizedDescription"];
                                                            
                                                            if ([string isEqualToString:@"The Internet connection appears to be offline."])
                                                            {
                                                                [weakSelf _hideHUD];
                                                                
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
                                                                        UIImage *image = [UIImage imageWithData:imageData];
                                                                        [userPhotos addObject:[NSDictionary dictionaryWithObject:image forKey:user.imageURL]];
                                                                    }
                                                                }
                                                                detailBiz.reviews = reviews.reviews;
                                                                detailBiz.userPhotosArray = userPhotos;
                                                                
                                                                if (!weakSelf.didCancelRequest)
                                                                {
                                                                    [weakSelf _hideHUD];
                                                                    
                                                                    // get biz photos here if we dont have them?
                                                                    [weakSelf performSegueWithIdentifier:kShowDetailSegue sender:detailBiz];
                                                                }
                                                            }
                                                            
                                                        });
                                                    }];
             }];
        });
                       }
    

    
}

- (void)_hideHUD
{
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;

    [self.hud removeFromSuperview];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BVTThumbNailTableViewCell *cell = (BVTThumbNailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    cell.openCloseLabel.text = @"";
    cell.secondaryOpenCloseLabel.text = @"";
    
    YLPBusiness *biz = [self.filteredResults objectAtIndex:indexPath.row];
    YLPBusiness *cachedBiz = [[self.displayArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", biz.identifier]] lastObject];
    
    if (cachedBiz)
    {
        biz = cachedBiz;
        
        cell.thumbNailView.image = cachedBiz.bizThumbNail;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        
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
    else
    {
        cell.thumbNailView.image = [UIImage imageNamed:@"placeholder"];
        
        __weak typeof(self) weakSelf = self;
        
        [[AppDelegate sharedClient] businessWithId:biz.identifier completionHandler:^
         (YLPBusiness *business, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSString *string = error.userInfo[@"NSLocalizedDescription"];
                 
                 if ([string isEqualToString:@"The Internet connection appears to be offline."])
                 {
                     [weakSelf _hideHUD];
                     
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [weakSelf presentViewController:alertController animated:YES completion:nil];
                     
                 }
                 else
                 {
                     if (business)
                     {
                         business.didGetDetails = YES;
                         
                         YLPBusiness *match = [[self.originalFilteredResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", business.identifier]] lastObject];
                         if (match)
                         {
                             NSInteger index = [self.originalFilteredResults indexOfObject:match];
                             [self.originalFilteredResults replaceObjectAtIndex:index withObject:business];
                         }
                         
                         
                         
                         if (!self.isLargePhone)
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
                         
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                             
                             // Your Background work
                             NSData *imageData = [NSData dataWithContentsOfURL:business.imageURL];
                             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
                                     
                                     if (business.photos.count > 0)
                                     {
                                         NSMutableArray *photosArray = [NSMutableArray array];
                                         for (NSString *photoStr in business.photos)
                                         {
                                             NSURL *url = [NSURL URLWithString:photoStr];
                                             NSData *imageData = [NSData dataWithContentsOfURL:url];
                                             UIImage *image = [UIImage imageWithData:imageData];
                                             [photosArray addObject:image];
                                         }
                                         
                                         business.photos = photosArray;
                                     }
                                     
                                     [self.displayArray addObject:business];
                                     
                                     [self.cachedDetails setObject:self.displayArray forKey:self.subCategoryTitle];
                                     
                                 }
                             });
                         });
                     }
                     
                 }
             });
         }];
    }
    
    cell.business = biz;
    
    return cell;
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapBackWithDetails:)])
    {
        [self.delegate didTapBackWithDetails:self.cachedDetails];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowDetailSegue])
    {
        // Get destination view
        BVTDetailTableViewController *vc = [segue destinationViewController];
        vc.selectedBusiness = sender;
    }
}

@end
