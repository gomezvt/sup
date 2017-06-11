//
//  BVTCategoryTableViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTSearchTableViewController.h"

#import "BVTHeaderTitleView.h"
#import "BVTSubCategoryTableViewController.h"
#import "BVTStyles.h"
#import "AppDelegate.h"
#import "YLPBusinessReviews.h"
#import "YLPClient+Reviews.h"
#import "YLPReview.h"
#import "YLPUser.h"
#import "YLPClient+Search.h"
#import "YLPSortType.h"
#import "YLPSearch.h"
#import "YLPBusiness.h"
#import "BVTHUDView.h"
#import "BVTStyles.h"
#import "BVTThumbNailTableViewCell.h"
#import "YLPClient+Business.h"
#import "BVTDetailTableViewController.h"

//#import "BVTHeaderTitleView.h"
//#import "BVTStyles.h"
//#import "YLPBusiness.h"
//#import "BVTThumbNailTableViewCell.h"
//#import "BVTHUDView.h"
//#import "AppDelegate.h"
//#import "YLPReview.h"
//#import "YLPUser.h"
//#import "YLPBusinessReviews.h"
//#import "YLPClient+Reviews.h"
//#import "YLPClient+Business.h"
//#import "BVTDetailTableViewController.h"
//#import "BVTTableViewSectionHeaderView.h"
//#import "BVTThumbNailTableViewCell.h"

@interface BVTSearchTableViewController ()
<BVTHUDViewDelegate>

@property (nonatomic, strong) BVTHUDView *hud;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, strong) NSArray *recentSearches;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIView *titleView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *sortView;
@property (nonatomic, weak) IBOutlet UIButton *starButton;

@property (nonatomic, weak) IBOutlet UIButton *priceButton;
@property (nonatomic, weak) IBOutlet UIButton *distanceButton;
@property (nonatomic, weak) IBOutlet UIButton *openNowButton;
@property (nonatomic) double milesKeyValue;
@property (nonatomic, strong) NSString *priceKeyValue;
@property (nonatomic, strong) NSString *openCloseKeyValue;
@property (nonatomic, strong) NSArray *originalDisplayResults;
@property (nonatomic) BOOL gotDetails;
@property (nonatomic, strong) NSArray *detailsArray;
@property (nonatomic, strong) NSArray *originalDetailsArray;
@property (nonatomic) BOOL didSelectBiz;
@property (nonatomic) BOOL isLargePhone;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kThumbNailCell = @"BVTThumbNailTableViewCell";
static NSString *const kShowDetailSegue = @"ShowDetail";
static NSString *const kTableViewSectionHeaderView = @"BVTTableViewSectionHeaderView";

@implementation BVTSearchTableViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = 0.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton = YES;
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    
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

    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDel.userLocation)
    {
        [self.distanceButton setHidden:YES];
    }
    else
    {
        [self.distanceButton setHidden:NO];
    }
    
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

    
    self.starButton.hidden = YES;
    self.sortView.hidden = YES;
    self.titleView.hidden = YES;
    [self.view bringSubviewToFront:self.label];
    
    UINib *cellNib = [UINib nibWithNibName:kThumbNailCell bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.recentSearches.count == 0)
    {
        self.label.text = @"Go ahead, search away...";
    }
 
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didTapHUDCancelButton
{
    self.didCancelRequest = YES;
    self.searchBar.userInteractionEnabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;

    [self.hud removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    self.hud = [BVTHUDView hudWithView:self.navigationController.view];
    self.hud.delegate = self;
    self.gotDetails = NO;
    self.tableView.userInteractionEnabled = NO;
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    self.searchBar.userInteractionEnabled = NO;

    self.didSelectBiz = NO;
    
    __weak typeof(self) weakSelf = self;
    [[AppDelegate sharedClient] searchWithLocation:@"Burlington, VT" term:searchBar.text limit:50 offset:0 sort:YLPSortTypeDistance completionHandler:^
     (YLPSearch *searchResults, NSError *error){
         dispatch_async(dispatch_get_main_queue(), ^{
             // code here
             if (error)
             {
                 [weakSelf _hideHUD];
                 
                 NSString *string = error.userInfo[@"NSDebugDescription"];
                 
                 if (![string isEqualToString:@"JSON text did not start with array or object and option to allow fragments not set."] && ![string isEqualToString:@"The data couldn't be read because it isn't in the correct format."])
                 {
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     
                     [weakSelf presentViewController:alertController animated:YES completion:nil];
                 }
             }
             else if (searchResults.businesses.count == 0)
             {
                 [weakSelf _hideHUD];
                 
                 weakSelf.label.hidden = NO;
                 weakSelf.recentSearches = @[];
                 weakSelf.detailsArray = @[];
                 [weakSelf.tableView reloadData];
                 weakSelf.label.text = @"No search results found.";
                 weakSelf.titleLabel.text = [NSString stringWithFormat:@"Recent Search Results (0)"];

             }
             else if (searchResults.businesses.count > 0)
             {
                 [weakSelf _hideHUD];
                 
                 weakSelf.label.hidden = YES;
                 weakSelf.titleLabel.text = [NSString stringWithFormat:@"Recent Search Results (%lu)", (unsigned long)searchResults.businesses.count];
                 
                 weakSelf.starButton.hidden = NO;
                 weakSelf.sortView.hidden = NO;
                 weakSelf.titleView.hidden = NO;
                 
                 weakSelf.originalDisplayResults = searchResults.businesses;
                 
                 NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                 NSArray *sortedArray = [searchResults.businesses sortedArrayUsingDescriptors: @[descriptor]];
                 
                 weakSelf.recentSearches = sortedArray;
                 [weakSelf.tableView reloadData];
                 
                 if (self.recentSearches.count > 0)
                 {
                     NSMutableArray *bizAdd = [NSMutableArray array];
                     for (YLPBusiness *selectedBusiness in self.recentSearches)
                     {

                         [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
                          (YLPBusiness *business, NSError *error) {
                              if (error)
                              {
                                  [weakSelf _hideHUD];

                                  NSString *string = error.userInfo[@"NSDebugDescription"];
                                  
                                                   if (![string isEqualToString:@"JSON text did not start with array or object and option to allow fragments not set."] && ![string isEqualToString:@"The data couldn't be read because it isn't in the correct format."])
                                  {
                                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                      [alertController addAction:ok];
                                      
                                      [weakSelf presentViewController:alertController animated:YES completion:nil];
                                  }
                              }
                              else if (business.photos.count > 0)
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
                              
                              if (business)
                              {
                                  NSData *imageData = [NSData dataWithContentsOfURL:business.imageURL];
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      // Update your UI
                                      
                                      if (imageData)
                                      {
                                          UIImage *image = [UIImage imageWithData:imageData];
                                          business.bizThumbNail = image;
                                      }
                                      else
                                      {
                                          business.bizThumbNail = [UIImage imageNamed:@"placeholder"];
                                      }
                                  });
                                  
                                  [bizAdd addObject:business];
                                  
                                  if (bizAdd.count == weakSelf.recentSearches.count)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                                          if (!weakSelf.didSelectBiz)
                                          {
                                              [weakSelf _hideHUD];
                                          }
                                          weakSelf.detailsArray = [bizAdd sortedArrayUsingDescriptors: @[nameDescriptor]];
                                          weakSelf.gotDetails = YES;
                                          weakSelf.originalDetailsArray = weakSelf.detailsArray;
                                          [weakSelf sortArrayWithPredicates];
                                      });
                                  }
                              }
                          }];
                     }
                 }
             }
         });
     }];

    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}



- (IBAction)didTapStarSortIcon:(id)sender
{
    self.starButton.selected = ![self.starButton isSelected];
    
    if (self.gotDetails)
    {
        if (self.starButton.isSelected)
        {
            NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:YES];
            self.detailsArray = [self.detailsArray sortedArrayUsingDescriptors: @[nameDescriptor]];
            
        }
        else
        {
            NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
            self.detailsArray = [self.detailsArray sortedArrayUsingDescriptors: @[nameDescriptor]];
        }
    }
    else
    {
        if (self.starButton.isSelected)
        {
            NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:YES];
            self.recentSearches = [self.recentSearches sortedArrayUsingDescriptors: @[nameDescriptor]];
            
        }
        else
        {
            NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
            self.recentSearches = [self.recentSearches sortedArrayUsingDescriptors: @[nameDescriptor]];
        }
    }
    
    
    
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.hud = [BVTHUDView hudWithView:self.navigationController.view];
    self.hud.delegate = self;
    self.didCancelRequest = NO;

    self.tableView.userInteractionEnabled = NO;
    self.tabBarController.tabBar.userInteractionEnabled = NO;

    self.didSelectBiz = YES;
    
    YLPBusiness *selectedBusiness = [self.recentSearches objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;

        [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
         (YLPBusiness *business, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error) {
                     
                     [weakSelf _hideHUD];

                     NSString *string = error.userInfo[@"NSDebugDescription"];
                     
                                      if (![string isEqualToString:@"JSON text did not start with array or object and option to allow fragments not set."] && ![string isEqualToString:@"The data couldn't be read because it isn't in the correct format."])
                     {
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                         
                         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                         [alertController addAction:ok];
                         
                         [weakSelf presentViewController:alertController animated:YES completion:nil];
                     }
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
                             UIImage *image = [UIImage imageWithData:imageData];

                             [photosArray addObject:image];
                         }
    
                         business.photos = photosArray;
                     }
    
                     [[AppDelegate sharedClient] reviewsForBusinessWithId:business.identifier
                                                        completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                if (error) {
                                                                    
                                                                    [weakSelf _hideHUD];

                                                                    NSString *string = error.userInfo[@"NSDebugDescription"];
                                                                    
                                                                                     if (![string isEqualToString:@"JSON text did not start with array or object and option to allow fragments not set."] && ![string isEqualToString:@"The data couldn't be read because it isn't in the correct format."])
                                                                    {
                                                                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                                        
                                                                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                                        [alertController addAction:ok];
                                                                        
                                                                        [weakSelf presentViewController:alertController animated:YES completion:nil];
                                                                    }
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
                                                                        [weakSelf _hideHUD];
    
                                                                        [weakSelf performSegueWithIdentifier:kShowDetailSegue sender:business];
                                                                    }
                                                                }
                                                                
                                                            });
                                                        }];
                 }
                 
             });
             
         }];
    
}

- (void)_hideHUD
{
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    self.searchBar.userInteractionEnabled = YES;

    [self.hud removeFromSuperview];
}


#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger i = 0;
    if (self.gotDetails)
    {
        i = self.detailsArray.count;
    }
    else
    {
        i = self.recentSearches.count;
    }
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BVTThumbNailTableViewCell *cell = (BVTThumbNailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    YLPBusiness *biz = [self.detailsArray objectAtIndex:indexPath.row];
    if (biz)
    {
        self.openNowButton.hidden = NO;
    }
    else
    {
        self.openNowButton.hidden = YES;
        biz =  [self.recentSearches objectAtIndex:indexPath.row];
    }
    
    cell.business = biz;

    cell.openCloseLabel.text = @"";
    cell.secondaryOpenCloseLabel.text = @"";
    
    if (!self.isLargePhone)
    {
        if (biz.isOpenNow)
        {
            cell.secondaryOpenCloseLabel.text = @"Open Now";
            cell.secondaryOpenCloseLabel.textColor = [BVTStyles iconGreen];
        }
        else if (biz.hoursItem && !biz.isOpenNow)
        {
            cell.secondaryOpenCloseLabel.text = @"Closed Now";
            cell.secondaryOpenCloseLabel.textColor = [UIColor redColor];
        }
    }
    else
    {
        if (biz.isOpenNow)
        {
            cell.openCloseLabel.text = @"Open Now";
            cell.openCloseLabel.textColor = [BVTStyles iconGreen];
        }
        else if (biz.hoursItem && !biz.isOpenNow)
        {
            cell.openCloseLabel.text = @"Closed Now";
            cell.openCloseLabel.textColor = [UIColor redColor];
        }
    }
    
    if (biz.bizThumbNail)
    {
        cell.thumbNailView.image = biz.bizThumbNail;
    }
    else
    {
        cell.thumbNailView.image = [UIImage imageNamed:@"placeholder"];
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
                        biz.bizThumbNail = image;
                        cell.thumbNailView.image = image;
                    }
                    else
                    {
                        biz.bizThumbNail = [UIImage imageNamed:@"placeholder"];
                    }
                }
            });
        });
    }
    
    return cell;
}

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
    if (self.openNowButton.hidden == NO)
    {
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
    }
    
    NSPredicate *comboPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:arrayPred];
    
    if (self.gotDetails)
    {
//        NSArray *values = self.cachedDetails[self.subCategoryTitle];
        
        self.detailsArray = [self.originalDetailsArray filteredArrayUsingPredicate:comboPredicate];
        self.titleLabel.text = [NSString stringWithFormat:@"Recent Search Results (%lu)", (unsigned long)self.detailsArray.count];
        
        if (self.detailsArray.count == 0)
        {
            self.titleLabel.text = [NSString stringWithFormat:@"Recent Search Results (0)"];

                self.label.text = @"No sorted results found.";

            
            self.label.hidden = NO;
        }
        else
        {
            self.titleLabel.text = [NSString stringWithFormat:@"Recent Search Results (%lu)", (unsigned long)self.detailsArray.count];
            self.label.hidden = YES;
        }
        
    }
    else
    {
        self.recentSearches  = [self.originalDisplayResults filteredArrayUsingPredicate:comboPredicate];

        if (self.recentSearches.count == 0)
        {
            self.titleLabel.text = [NSString stringWithFormat:@"Recent Search Results (0)"];
            self.label.text = @"No sorted results found.";
            self.label.hidden = NO;
        }
        else
        {
            self.titleLabel.text = [NSString stringWithFormat:@"Recent Search Results (%lu)", (unsigned long)self.recentSearches.count];
            self.label.hidden = YES;
        }
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

@end
