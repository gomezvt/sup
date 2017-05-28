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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleView.hidden = YES;
    [self.view bringSubviewToFront:self.label];
    
    UINib *cellNib = [UINib nibWithNibName:kThumbNailCell bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.recentSearches.count == 0)
    {
        self.label.text = @"Perform a search to get started.";
    }
//    self.tableView.sectionHeaderHeight = 44.f;

//    UINib *headerView = [UINib nibWithNibName:kTableViewSectionHeaderView bundle:nil];
//    [self.tableView registerNib:headerView forHeaderFooterViewReuseIdentifier:kTableViewSectionHeaderView];
    
    self.tableView.tableFooterView = [UIView new];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Search Results";
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat height;
//    if (self.recentSearches.count == 0)
//    {
//        height = 0.f;
//    }
//    else
//    {
//        height = 44.f;
//    }
//    return height;
//}

- (void)didTapHUDCancelButton
{
    self.didCancelRequest = YES;
    self.tableView.userInteractionEnabled = YES;
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

    __weak typeof(self) weakSelf = self;
    [[AppDelegate sharedClient] searchWithLocation:@"Burlington, VT" term:searchBar.text limit:50 offset:0 sort:YLPSortTypeDistance completionHandler:^
     (YLPSearch *searchResults, NSError *error){
         dispatch_async(dispatch_get_main_queue(), ^{
             // code here
             if (error)
             {
                 [weakSelf _hideHUD];
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 
                 [weakSelf presentViewController:alertController animated:YES completion:nil];
             }
             else if (searchResults.businesses.count == 0)
             {
                 [weakSelf _hideHUD];
                 
                 weakSelf.label.hidden = NO;
                 weakSelf.label.text = @"No search results found.";
                 
//                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No search results found" message:@"Please select another category" preferredStyle:UIAlertControllerStyleAlert];
//                 
//                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//                 [alertController addAction:ok];
//                 
//                 [weakSelf presentViewController:alertController animated:YES completion:nil];
//                 
             }
             else if (searchResults.businesses.count > 0)
             {
                 [weakSelf _hideHUD];
                 weakSelf.titleView.hidden = NO;
                 weakSelf.label.hidden = YES;
                 weakSelf.titleLabel.text = [NSString stringWithFormat:@"Search Results (%lu)", (unsigned long)searchResults.businesses.count];
                 
                 NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                 NSArray *sortedArray = [searchResults.businesses sortedArrayUsingDescriptors: @[descriptor]];
                 
                 weakSelf.recentSearches = sortedArray;
                 [weakSelf.tableView reloadData];
                 
//                 [weakSelf.tableView setSectionHeaderHeight:44.f];

             }
         });
     }];

    [searchBar resignFirstResponder];
//    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.hud = [BVTHUDView hudWithView:self.navigationController.view];
    self.hud.delegate = self;
    self.didCancelRequest = NO;

    self.tableView.userInteractionEnabled = NO;
    
    YLPBusiness *selectedBusiness = [self.recentSearches objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;

        [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
         (YLPBusiness *business, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error) {
                     [weakSelf _hideHUD];
    
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
    [self.hud removeFromSuperview];
}


#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recentSearches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BVTThumbNailTableViewCell *cell = (BVTThumbNailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    YLPBusiness *biz =  [self.recentSearches objectAtIndex:indexPath.row];
    cell.business = biz;
    
    cell.openCloseLabel.text = @"";
    cell.secondaryOpenCloseLabel.text = @"";
    
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

@end
