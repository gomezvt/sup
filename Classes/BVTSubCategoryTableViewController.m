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
@property (nonatomic, strong) NSArray *filteredArrayCopy;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic) double milesKeyValue;
@property (nonatomic, strong) NSString *priceKeyValue;
@property (nonatomic, strong) NSString *openCloseKeyValue;

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
    
    if (!self.priceKeyValue)
    {
        self.priceKeyValue = @"Any $";
    }
    
    if (!self.openCloseKeyValue)
    {
        self.openCloseKeyValue = @"Open/Closed";
    }
    
    NSMutableArray *arrayPred = [NSMutableArray array];
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
    if ([self.openCloseKeyValue isEqualToString:@"Open"])
    {
        openClosePredicate = [NSPredicate predicateWithFormat:@"isOpenNow = %@", @(YES)];
    }
    else if ([self.openCloseKeyValue isEqualToString:@"Closed"])
    {
        openClosePredicate = [NSPredicate predicateWithFormat:@"isOpenNow = %@", @(NO)];
    }
    else if ([self.openCloseKeyValue isEqualToString:@"Open/Closed"])
    {
        openClosePredicate = [NSPredicate predicateWithFormat:@"isOpenNow = %@ OR isOpenNow = %@", @(NO), @(YES)];
    }
    
    [arrayPred addObject:openClosePredicate];
    
    NSPredicate *comboPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[arrayPred copy]];
    
    NSArray *sortedArray = [self.filteredArrayCopy filteredArrayUsingPredicate:comboPredicate];
    self.filteredResults = sortedArray;
    if (self.filteredResults.count == 0)
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ (0)", self.subCategoryTitle];
        if (!self.label)
        {
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30.f)];
            self.label.text = @"No sorted results found";
            [self.view addSubview:self.label];
            self.label.center = self.tableView.center;
            self.tableView.separatorColor = [UIColor clearColor];
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.textColor = [UIColor lightGrayColor];
        }
        
        self.label.hidden = NO;
    }
    else
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ (%lu)", self.subCategoryTitle, (unsigned long)self.filteredResults.count];
        self.label.hidden = YES;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self sortArrayWithPredicates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDel.userLocation)
    {
        [self.distanceButton setHidden:YES];
    }
    else
    {
        [self.distanceButton setHidden:NO];
    }
    self.filteredArrayCopy = self.filteredResults;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%lu)", self.subCategoryTitle, (unsigned long)self.filteredResults.count];
    
    if (!self.cachedDetails)
    {
        self.cachedDetails = [[NSMutableArray alloc] init];
    }
    
    if (self.filteredResults.count > 0)
    {
        for (YLPBusiness *selectedBusiness in self.filteredResults)
        {
            if (![[self.cachedDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"phone = %@", selectedBusiness.phone]] lastObject])
            {
                [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
                 (YLPBusiness *business, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
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
                         
                         if (business)
                         {
                             [self.cachedDetails addObject:business];
                         }
                     });
                 }];
            }
        }
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
    
    YLPBusiness *selectedBusiness = [self.filteredResults objectAtIndex:indexPath.row];
    YLPBusiness *cachedBiz = [[self.cachedDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"phone = %@", selectedBusiness.phone]] lastObject];
    if (cachedBiz)
    {
        selectedBusiness = cachedBiz;
    }
    
    [[AppDelegate sharedClient] reviewsForBusinessWithId:selectedBusiness.identifier
                                       completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               if (error)
                                               {
                                                   [self _hideHUD];
                                                   
                                                   NSLog(@"Error %@", error.localizedDescription);
                                               }
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
                                               selectedBusiness.reviews = reviews.reviews;
                                               selectedBusiness.userPhotosArray = userPhotos;
                                               
                                               [self _hideHUD];
                                               if (!self.didCancelRequest)
                                               {
                                                   // get biz photos here if we dont have them?
                                                   [self performSegueWithIdentifier:kShowDetailSegue sender:selectedBusiness];
                                               }
                                           });
                                       }];
    
}

- (void)_hideHUD
{
    self.backChevron.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
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
    BVTThumbNailTableViewCell *cell = (BVTThumbNailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    YLPBusiness *business = [self.filteredResults objectAtIndex:indexPath.row];
    
    YLPBusiness *cachedBiz = [[self.cachedDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"phone = %@", business.phone]] lastObject];
    if (cachedBiz)
    {
        business = cachedBiz;
    }
    
    cell.business = business;
    
    UIImage *image = [UIImage imageNamed:@"placeholder"];
    cell.thumbNailView.image = image;
 
    if (!business.hoursItem)
    {
        cell.openCloseLabel.text = @"";
    }
    else if (business.isOpenNow)
    {
        cell.openCloseLabel.text = @"Open";
        cell.openCloseLabel.textColor = [BVTStyles iconGreen];
    }
    else
    {
        cell.openCloseLabel.text = @"Closed";
        cell.openCloseLabel.textColor = [UIColor redColor];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Your Background work
        NSData *imageData = [NSData dataWithContentsOfURL:business.imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update your UI
            if (cell.tag == indexPath.row)
            {
                if (imageData)
                {
                    UIImage *image = [UIImage imageWithData:imageData];
                    cell.thumbNailView.image = image;
                }
            }
        });
    });
    
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
