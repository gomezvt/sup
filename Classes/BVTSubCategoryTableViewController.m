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

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kThumbNailCell = @"BVTThumbNailTableViewCell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation BVTSubCategoryTableViewController

- (IBAction)didTapPriceButton:(id)sender
{
    NSString *filterKey;
    NSArray *sortedArray;
    if ([self.priceButton.titleLabel.text isEqualToString:@"$$$$"])
    {
        filterKey = @"Any price";
        [self.priceButton setTitle:filterKey forState:UIControlStateNormal];
        sortedArray = self.filteredArrayCopy;
    }
    else
    {
        if ([self.priceButton.titleLabel.text isEqualToString:@"Any price"])
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
        
        sortedArray = [self.filteredArrayCopy filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"price = %@", filterKey]];
    }
    
    if (sortedArray.count == 0)
    {
        [self presentMessage];
    }

    self.filteredResults = sortedArray;
    
    [self.tableView reloadData];
}

- (void)presentMessage
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30.f)];
    label.text = @"No sorted results found.";
    [super.view addSubview:label];
    label.center = self.tableView.center;
    self.tableView.separatorColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
}

- (IBAction)didTapDistanceButton:(id)sender
{
    if ([self.distanceButton.titleLabel.text isEqualToString:@"5 mi. away"])
    {
        [self.distanceButton setTitle:@"10 mi. away" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"10 mi. away"])
    {
        [self.distanceButton setTitle:@"25 mi. away" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"25 mi. away"])
    {
        [self.distanceButton setTitle:@"50 mi. away" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"50 mi. away"])
    {
        [self.distanceButton setTitle:@"100 mi. away" forState:UIControlStateNormal];
    }
    else if ([self.distanceButton.titleLabel.text isEqualToString:@"100 mi. away"])
    {
        [self.distanceButton setTitle:@"5 mi. away" forState:UIControlStateNormal];
    }
}

- (IBAction)didTapOpenButton:(id)sender
{
    if ([self.openNowButton.titleLabel.text isEqualToString:@"Open now"])
    {
        [self.openNowButton setTitle:@"Closed now" forState:UIControlStateNormal];
    }
    else if ([self.openNowButton.titleLabel.text isEqualToString:@"Closed now"])
    {
        [self.openNowButton setTitle:@"Open now" forState:UIControlStateNormal];
    }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filteredArrayCopy = self.filteredResults;
    
    self.titleLabel.text = self.subCategoryTitle;

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
    [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
     (YLPBusiness *business, NSError *error) {
         if (error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self _hideHUD];

             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alertController addAction:ok];
             
             [self presentViewController:alertController animated:YES completion:nil];

             });
         }
         else
         {
             // *** Get business photos in advance if they exist, to display from Presentation VC
             dispatch_async(dispatch_get_main_queue(), ^{
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

                                                            [self _hideHUD];
                                                            if (!self.didCancelRequest)
                                                            {
                                                                [self performSegueWithIdentifier:kShowDetailSegue sender:business];
                                                            }
                                                        });
                                                    }];
             });
         }

         
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
