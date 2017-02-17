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

#import "BVTStyles.h"

@interface BVTSubCategoryTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kThumbNailCell = @"BVTThumbNailTableViewCell";
static NSString *const kDefaultCellIdentifier = @"Cell";
static NSString *const kShowDetailSegue = @"ShowDetail";

@implementation BVTSubCategoryTableViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.subCategoryTitle;

    UINib *cellNib = [UINib nibWithNibName:kThumbNailCell bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kDefaultCellIdentifier];

    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    YLPBusiness *selectedBusiness = [self.filteredResults objectAtIndex:indexPath.row];
    [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
     (YLPBusiness *business, NSError *error) {

         dispatch_async(dispatch_get_main_queue(), ^{
             NSMutableArray *photosArray = [NSMutableArray array];
             if (business.photos.count > 0)
             {
                 for (NSString *photoStr in business.photos)
                 {
                     NSURL *url = [NSURL URLWithString:photoStr];
                     NSData *imageData = [NSData dataWithContentsOfURL:url];
                     UIImage *image = [UIImage imageWithData:imageData];
                     [photosArray addObject:image];
                 }
             }
             business.photos = photosArray;
             
             [[AppDelegate sharedClient] reviewsWithId:business.identifier completionHandler:^
              (YLPBusiness *reviewsBiz, NSError *error) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      business.reviews = reviewsBiz.reviews;
                      [self performSegueWithIdentifier:kShowDetailSegue sender:business ];
                  });
              }];
         });
     }];
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
    BVTThumbNailTableViewCell *cell = (BVTThumbNailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
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
