//
//  SUPDetailTableViewController.m
//  Sup? City
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPSubCategoryTableViewController.h"

#import "SUPDetailTableViewController.h"
#import "SUPHeaderTitleView.h"
#import "SUPThumbNailTableViewCell.h"
#import "YLPBusiness.h"
#import "AppDelegate.h"
#import "YLPClient+Business.h"
#import "YLPBusiness.h"
#import "YLPSearch.h"
#import "SUPHUDView.h"
#import "YLPClient+Reviews.h"
#import "YLPBusinessReviews.h"
#import "SUPStyles.h"
#import "YLPReview.h"
#import "YLPUser.h"
#import "YLPLocation.h"
#import "YLPCoordinate.h"
@interface SUPSubCategoryTableViewController ()
<SUPHUDViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) SUPHUDView *hud;
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
@property (nonatomic, strong) NSMutableArray *displayArray;
@property (nonatomic) BOOL gotDetails;
@property (nonatomic, strong) NSMutableArray *originalFilteredResults;
@property (nonatomic) BOOL isLargePhone;
@property (nonatomic) BOOL didSelectBiz;
@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;
@property (nonatomic, strong) NSString *moneySymbol;
@end

static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kThumbNailCell = @"SUPThumbNailTableViewCell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation SUPSubCategoryTableViewController

- (IBAction)didTapPriceButton:(id)sender
{
    if ([self.priceButton.titleLabel.text isEqualToString:[NSString stringWithFormat:@"Any %@", self.moneySymbol]])
    {
        self.priceKeyValue = [NSString stringWithFormat:@"%@", self.moneySymbol];
        [self.priceButton setTitle:[NSString stringWithFormat:@"%@", self.moneySymbol] forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%@", self.moneySymbol]])
    {
        self.priceKeyValue = [NSString stringWithFormat:@"%@%@", self.moneySymbol,self.moneySymbol];
        [self.priceButton setTitle:[NSString stringWithFormat:@"%@%@", self.moneySymbol,self.moneySymbol] forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%@%@", self.moneySymbol,self.moneySymbol]])
    {
        self.priceKeyValue = [NSString stringWithFormat:@"%@%@%@", self.moneySymbol,self.moneySymbol,self.moneySymbol];
        [self.priceButton setTitle:[NSString stringWithFormat:@"%@%@%@", self.moneySymbol,self.moneySymbol,self.moneySymbol] forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%@%@%@", self.moneySymbol,self.moneySymbol,self.moneySymbol]])
    {
        self.priceKeyValue = [NSString stringWithFormat:@"%@%@%@%@", self.moneySymbol,self.moneySymbol,self.moneySymbol,self.moneySymbol];
        [self.priceButton setTitle:[NSString stringWithFormat:@"%@%@%@%@", self.moneySymbol,self.moneySymbol,self.moneySymbol,self.moneySymbol] forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%@%@%@%@", self.moneySymbol,self.moneySymbol,self.moneySymbol,self.moneySymbol]])
    {
        self.priceKeyValue = [NSString stringWithFormat:@"Any %@", self.moneySymbol];
        [self.priceButton setTitle:[NSString stringWithFormat:@"Any %@", self.moneySymbol] forState:UIControlStateNormal];
    }
    
    [self sortArrayWithPredicates];
}

- (void)sortArrayWithPredicates
{
    
    NSPredicate *pricePredicate;
    

    
    NSMutableArray *arrayPred = [NSMutableArray array];
    if (!self.priceKeyValue)
    {
        self.priceKeyValue = [NSString stringWithFormat:@"Any %@", self.moneySymbol];
    }
    
    if ([self.priceKeyValue isEqualToString:[NSString stringWithFormat:@"Any %@", self.moneySymbol]])
    {
        pricePredicate = [NSPredicate predicateWithFormat:@"price = %@ OR price = %@ OR price = %@ OR price = %@ OR price = %@", nil, [NSString stringWithFormat:@"%@", self.moneySymbol], [NSString stringWithFormat:@"%@%@", self.moneySymbol, self.moneySymbol], [NSString stringWithFormat:@"%@%@%@", self.moneySymbol, self.moneySymbol, self.moneySymbol], [NSString stringWithFormat:@"%@%@%@%@", self.moneySymbol, self.moneySymbol, self.moneySymbol, self.moneySymbol]];
    }
    else
    {
        if ([self.priceKeyValue containsString:@"¥"])
        {
            pricePredicate = [NSPredicate predicateWithFormat:@"price MATCHES[c] %@", self.priceKeyValue];
        }
        else
        {
            pricePredicate = [NSPredicate predicateWithFormat:@"price = %@", self.priceKeyValue];
        }
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
    
    for (YLPBusiness *biz in self.originalFilteredResults)
    {
//        NSString *price = biz.price;
//        NSString *newPrice = [price stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        
//        biz.price = newPrice;
        if (biz.location.coordinate.latitude && biz.location.coordinate.longitude)
        {
            CLLocation *bizLocation = [[CLLocation alloc] initWithLatitude:biz.location.coordinate.latitude longitude:biz.location.coordinate.longitude];
            
            CLLocationDistance meters = [appDel.userLocation distanceFromLocation:bizLocation];
            double miles = meters / 1609.34;
            biz.miles = miles;
        }
    }
    
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
    
    if (self.starSortIcon.isSelected)
    {
        NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:YES];
        self.filteredResults = [[self.filteredResults sortedArrayUsingDescriptors: @[nameDescriptor]] mutableCopy];
        
    }
    else
    {
        NSSortDescriptor *nameDescriptor =  [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
        self.filteredResults = [[self.filteredResults sortedArrayUsingDescriptors: @[nameDescriptor]] mutableCopy];
    }
    
    [self.tableView reloadData];
}

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    

    
    if (kCity)
    {
        self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@"Sup? City:  %@", [kCity capitalizedString]];
    }
    
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
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.sortedArray = [NSMutableArray array];
    
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];

    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:kCity completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            return; // Bail!
        }
        
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject]; // firstObject is iOS7 only.
            NSString *countryCode = placemark.ISOcountryCode;
            NSDictionary *components = [NSDictionary dictionaryWithObject:countryCode forKey:NSLocaleCountryCode];
            NSString *localeIdent = [NSLocale localeIdentifierFromComponents:components];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdent];
            NSString *symbol = locale.currencySymbol;
            if (symbol.length > 1)
            {
                self.moneySymbol = [symbol substringFromIndex:[symbol length] - 1];
            }
            else
            {
                self.moneySymbol = symbol;
            }
            [self.priceButton setTitle:[NSString stringWithFormat:@"Any %@", self.moneySymbol] forState:UIControlStateNormal];
            NSLog(@"Location is: %@", placemark.location);
            
        }
    }];
    
    self.displayArray = [[NSMutableArray alloc] init];
    
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
    [layer setBorderColor:[[SUPStyles iconBlue] CGColor]];
    
    CALayer * layer2 = [self.distanceButton layer];
    [layer2 setMasksToBounds:YES];
    [layer2 setCornerRadius:10.0];
    [layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[SUPStyles iconBlue] CGColor]];
    
    CALayer * layer3 = [self.openNowButton layer];
    [layer3 setMasksToBounds:YES];
    [layer3 setCornerRadius:10.0];
    [layer3 setBorderWidth:1.0];
    [layer3 setBorderColor:[[SUPStyles iconBlue] CGColor]];
}

- (void)didTapHUDCancelButton
{
    dispatch_async(dispatch_get_main_queue(), ^(void){

    self.didCancelRequest = YES;
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    
    [self.hud removeFromSuperview];
    });
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.didCancelRequest = NO;
    self.didSelectBiz = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.backChevron.enabled = NO;
        self.hud = [SUPHUDView hudWithView:self.navigationController.view];
        self.hud.delegate = self;
        self.tableView.userInteractionEnabled = NO;
        self.tabBarController.tabBar.userInteractionEnabled = NO;
    });
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YLPBusiness *selectedBusiness = [self.filteredResults objectAtIndex:indexPath.row];
    
    YLPBusiness *cachedBiz;
    id cachedBizArray = [self.cachedDetails valueForKey:self.subCategoryTitle];
    if ([cachedBizArray isKindOfClass:[YLPBusiness class]])
    {
        YLPBusiness *potential = (YLPBusiness *)cachedBizArray;
        if ([potential.identifier isEqualToString:selectedBusiness.identifier])
        {
            cachedBiz = potential;
        }
    }
    else
    {
        cachedBiz = [[cachedBizArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", selectedBusiness.identifier]] lastObject];
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (cachedBiz)
    {
        
        [[AppDelegate yelp] reviewsForBusinessWithId:cachedBiz.identifier
                                           completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   NSString *string = error.userInfo[@"NSLocalizedDescription"];
                                                   
                                                   if ([string isEqualToString:@"The Internet connection appears to be offline."])
                                                   {
                                                       [weakSelf _hideHUD];
                                                       
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
                                                           cachedBiz.reviews = reviews.reviews;
                                                           cachedBiz.userPhotosArray = userPhotos;
                                                           dispatch_async(dispatch_get_main_queue(), ^(void){

                                                           [[NSNotificationCenter defaultCenter]
                                                            postNotificationName:@"receivedBizReviews"
                                                            object:self];
                                                           });
                                                       });
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^(void){

                                                           if (!weakSelf.didCancelRequest)
                                                           {
                                                               [weakSelf _hideHUD];
                                                               
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
                     [weakSelf _hideHUD];
                     
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
                                                                    [weakSelf _hideHUD];
                                                                    
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
                                                                        [weakSelf.cachedDetails setObject:business forKey:weakSelf.subCategoryTitle];
                                                                        dispatch_async(dispatch_get_main_queue(), ^(void){

                                                                        [[NSNotificationCenter defaultCenter]
                                                                         postNotificationName:@"receivedBizReviews"
                                                                         object:self];
                                                                        });
                                                                    });
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                        
                                                                        if (!weakSelf.didCancelRequest)
                                                                        {
                                                                            [weakSelf _hideHUD];
                                                                            
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
    SUPThumbNailTableViewCell *cell = (SUPThumbNailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (cell.tag == indexPath.row)
        {
            cell.openCloseLabel.text = @"";
            cell.secondaryOpenCloseLabel.text = @"";
            cell.thumbNailView.image = [UIImage imageNamed:@"placeholder"];
        }
    });
    
    __block YLPBusiness *biz = [self.filteredResults objectAtIndex:indexPath.row];
    
    YLPBusiness *cachedBiz;
    id cachedBizArray = [self.cachedDetails valueForKey:self.subCategoryTitle];
    if ([cachedBizArray isKindOfClass:[YLPBusiness class]])
    {
        YLPBusiness *potential = (YLPBusiness *)cachedBizArray;
        if ([potential.identifier isEqualToString:biz.identifier])
        {
            cachedBiz = potential;
        }
    }
    else
    {
       cachedBiz = [[cachedBizArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", biz.identifier]] lastObject];
    }
    
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
                        cell.secondaryOpenCloseLabel.textColor = [SUPStyles iconBlue];
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
                        cell.openCloseLabel.textColor = [SUPStyles iconBlue];
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
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (cell.tag == indexPath.row)
                 {
//                     if ([biz.identifier isEqualToString:business.identifier])
//                     {
//                         business.miles = biz.miles;
//                     }
                     
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
                     
                     [weakSelf _hideHUD];
                     
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
                         // Your Background work
                         if (cell.tag == indexPath.row)
                         {
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
                             
                             NSData *imageData = [NSData dataWithContentsOfURL:business.imageURL];
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
                                     
                                     YLPBusiness *match = [[weakSelf.originalFilteredResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", business.identifier]] lastObject];
                                     
                                     if (match)
                                     {
                                         business.didGetDetails = YES;
                                         [weakSelf.displayArray addObject:business];
                                         [weakSelf.cachedDetails setObject:weakSelf.displayArray forKey:weakSelf.subCategoryTitle];
                                         biz = business;
                                         
                                         NSInteger index = [weakSelf.originalFilteredResults indexOfObject:match];
                                         [weakSelf.originalFilteredResults replaceObjectAtIndex:index withObject:business];
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
    self.didSelectBiz = NO;

    if ([[segue identifier] isEqualToString:kShowDetailSegue])
    {
        // Get destination view
        SUPDetailTableViewController *vc = [segue destinationViewController];
        vc.selectedBusiness = sender;
    }
}

@end
