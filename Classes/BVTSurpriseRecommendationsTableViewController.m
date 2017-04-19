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

@interface BVTSurpriseRecommendationsTableViewController ()
    <BVTHUDViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backChevron;
@property (nonatomic, strong) BVTHUDView *hud;
@property (nonatomic) BOOL didCancelRequest;
@property (nonatomic, strong) NSMutableDictionary *orderedDict;
@property (nonatomic, strong) BVTTableViewSectionHeaderView *headerView;

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
    NSString *key = [self.businessOptions allKeys][section];
    NSArray *array = [self.businessOptions valueForKey:key];
    
    NSString *title;
    if (array.count > 0)
    {
        title = key;
    }

    return title;
}

- (IBAction)didTapBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionFooterHeight = 0.0f;
    
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
    NSString *key = [self.businessOptions allKeys][section];
    NSArray *k = [self.businessOptions objectForKey:key];

    return k.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BVTThumbNailTableViewCell *cell = (BVTThumbNailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    NSString *key = [self.businessOptions allKeys][indexPath.section];

    NSArray *allValues = [self.businessOptions valueForKey:key];
    NSDictionary *bizDict = allValues[indexPath.row];
    YLPBusiness *biz = [[bizDict allValues] lastObject];
    

    
    cell.business = biz;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.numberOfLines = 0;
    
    UIImage *image = [UIImage imageNamed:@"placeholder"];
    cell.thumbNailView.image = image;
    
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
            }
        });
    });

    return cell;
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
    
    NSArray *sectionValues = [self.businessOptions allValues][indexPath.section];
    NSDictionary *businessDict = sectionValues[indexPath.row];
    YLPBusiness *selectedBusiness = [[businessDict allValues] lastObject];
    
    [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
     (YLPBusiness *business, NSError *error) {
         if (error) {
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alertController addAction:ok];
             
             [self presentViewController:alertController animated:YES completion:nil];
             self.backChevron.enabled = YES;
             self.tableView.userInteractionEnabled = YES;
             [self.hud removeFromSuperview];
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
                                                                    [userPhotos addObject:[NSDictionary dictionaryWithObject:image forKey:user.imageURL]];                                                                }
                                                            }
                                                            business.reviews = reviews.reviews;
                                                            business.userPhotosArray = userPhotos;
                                                            self.backChevron.enabled = YES;
                                                            self.tableView.userInteractionEnabled = YES;
                                                            [self.hud removeFromSuperview];
                                                            
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
