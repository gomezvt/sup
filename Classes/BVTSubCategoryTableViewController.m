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

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kThumbNailCell = @"BVTThumbNailTableViewCell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation BVTSubCategoryTableViewController

- (IBAction)didTapPriceButton:(id)sender
{
    NSString *filterKey;
    NSArray *sortedArray;
    
    if ([self.priceButton.titleLabel.text isEqualToString:@"Any $"])
    {
        filterKey = @"$";
        [self.priceButton setTitle:filterKey forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:@"$"])
    {
        filterKey = @"$$";
        [self.priceButton setTitle:filterKey forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:@"$$"])
    {
        filterKey = @"$$$";
        [self.priceButton setTitle:filterKey forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:@"$$$"])
    {
        filterKey = @"$$$$";
        [self.priceButton setTitle:filterKey forState:UIControlStateNormal];
    }
    else if ([self.priceButton.titleLabel.text isEqualToString:@"$$$$"])
    {
        filterKey = @"Any $";
        [self.priceButton setTitle:filterKey forState:UIControlStateNormal];
    }
    
    sortedArray = [self.filteredArrayCopy filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"price = %@", filterKey]];
    
    
    
    self.filteredResults = sortedArray;
    
    [self evaluateSortedItemsState:self.filteredResults];
}

- (IBAction)didTapDistanceButton:(id)sender
{
    if ([self.distanceButton.titleLabel.text isEqualToString:@"5 miles"])
    {
        [self.distanceButton setTitle:@"10 miles" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"10 miles"])
    {
        [self.distanceButton setTitle:@"25 miles" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"25 miles"])
    {
        [self.distanceButton setTitle:@"50 miles" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"50 miles"])
    {
        [self.distanceButton setTitle:@"100 miles" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"100 miles"])
    {
        [self.distanceButton setTitle:@"5 miles" forState:UIControlStateNormal];
    }
    
    NSArray *sortedArray; // need to work this TODO:
    self.filteredResults = sortedArray;

    [self evaluateSortedItemsState:self.filteredResults];
}

- (IBAction)didTapOpenButton:(id)sender
{
        NSArray *sortedArray;
    if ([self.openNowButton.titleLabel.text isEqualToString:@"Closed"])
    {
        [self.openNowButton setTitle:@"Open" forState:UIControlStateNormal];
        sortedArray = [self.filteredArrayCopy filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isOpenNow = %@", @(YES)]];
    }
    else if ([self.openNowButton.titleLabel.text isEqualToString:@"Open"])
    {
        [self.openNowButton setTitle:@"Closed" forState:UIControlStateNormal];
        sortedArray = [self.filteredArrayCopy filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isOpenNow = %@", @(NO)]];
    }
    
    self.filteredResults = sortedArray;
    
    [self evaluateSortedItemsState:self.filteredResults];
}

- (void)evaluateSortedItemsState:(NSArray *)items
{
    
    if (items.count == 0)
    {
        self.label.hidden = NO;
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
    }
    else
    {
        self.label.hidden = YES;
    }
    
    
    [self.tableView reloadData];
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

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveBusinessesNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"BVTReceivedBusinessesIdNotification"])
    {
        YLPBusiness *business = notification.object;
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
        
        [self.filteredArray addObject:business];
        
        
        if (self.filteredArray.count == self.filteredResults.count)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *descriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
                NSArray *sortedArray = [self.filteredArray sortedArrayUsingDescriptors:descriptor];
                self.filteredResults = sortedArray;
                [self.cachedDetails setObject:self.filteredResults forKey:self.subCategoryTitle];
                [self.tableView reloadData];
                [self _hideHUD];
                
                [self.openNowButton setHidden:NO];

//                [self performSegueWithIdentifier:kShowSubCategorySegue sender:@[ self.selectionTitle, sortedArray ]];
            });
        }
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.filteredArrayCopy = self.filteredResults;

    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%lu)", self.subCategoryTitle, (unsigned long)self.filteredArrayCopy.count];
    
    if (!self.cachedDetails)
    {
        self.cachedDetails = [NSMutableDictionary dictionary];
    }
    
    [self.openNowButton setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveBusinessesNotification:)
                                                 name:@"BVTReceivedBusinessesIdNotification"
                                               object:nil];
    
    NSArray *details = [self.cachedDetails valueForKey:self.subCategoryTitle];
    if (details.count > 0)
    {
        self.filteredResults = details;
        [self.openNowButton setHidden:NO];

    }
    else
    {
        self.filteredArray = [NSMutableArray array];

        if (self.filteredResults.count > 0)
        {
//            self.hud = [BVTHUDView hudWithView:self.navigationController.view];
//            self.hud.delegate = self;
//            
//            self.didCancelRequest = NO;
//            self.tableView.userInteractionEnabled = NO;
//            self.backChevron.enabled = NO;
            for (YLPBusiness *selectedBusiness in self.filteredResults)
            {
                
                
                [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
                 (YLPBusiness *business, NSError *error) {
                     
                     if (error) {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
//                             [self _hideHUD];
                             
                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                             [alertController addAction:ok];
                             
                             [self presentViewController:alertController animated:YES completion:nil];
                             
                         });
                     }
                     
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

                 
                 [[AppDelegate sharedClient] reviewsForBusinessWithId:selectedBusiness.identifier
                                                    completionHandler:^(YLPBusinessReviews * _Nullable reviews, NSError * _Nullable error) {
                                                        if (error)
                                                        {
                                                            
                                                        }
                                                        dispatch_async(dispatch_get_main_queue(), ^{
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
    cell.business = business;
    
    UIImage *image = [UIImage imageNamed:@"placeholder"];
    cell.thumbNailView.image = image;
    
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
