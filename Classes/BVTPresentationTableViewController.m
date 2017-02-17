//
//  BVTPresentationTableViewController.m
//  bvt
//
//  Created by Greg on 2/15/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTPresentationTableViewController.h"

#import "BVTYelpPhotoTableViewCell.h"
#import "BVTYelpReviewsTableViewCell.h"

@interface BVTPresentationTableViewController ()

@end

static NSString *const kPhotoNib = @"BVTYelpPhotoTableViewCell";
static NSString *const kPhotoCellID = @"BVTYelpPhotoCellIdentifier";
static NSString *const kReviewsNib = @"BVTYelpReviewsTableViewCell";
static NSString *const kReviewsCellID = @"BVTReviewsPhotoCellIdentifier";

@implementation BVTPresentationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *yelpPhotoCellNib = [UINib nibWithNibName:kPhotoNib bundle:nil];
    [self.tableView registerNib:yelpPhotoCellNib forCellReuseIdentifier:kPhotoCellID];
    
    UINib *yelpReviewsCellNib = [UINib nibWithNibName:kReviewsNib bundle:nil];
    [self.tableView registerNib:yelpReviewsCellNib forCellReuseIdentifier:kReviewsCellID];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.sender isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton *)self.sender;
        if ([button.titleLabel.text isEqualToString:@"Reviews"])
        {
            return self.business.reviews.count;
        }
        else if ([button.titleLabel.text isEqualToString:@"Photos"])
        {
            return self.business.photos.count;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;

    if ([self.sender isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton *)self.sender;
        if ([button.titleLabel.text isEqualToString:@"Reviews"])
        {
            identifier = kReviewsCellID;
        }
        else if ([button.titleLabel.text isEqualToString:@"Photos"])
        {
            identifier = kPhotoCellID;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if ([identifier isEqualToString:kReviewsCellID])
    {
        NSDictionary *reviewDict = [self.business.reviews objectAtIndex:indexPath.row];
        BVTYelpReviewsTableViewCell *reviewsCell = (BVTYelpReviewsTableViewCell *)cell;
        reviewsCell.reviewLabel.text = reviewDict[@"text"];
    }
    else if ([identifier isEqualToString:kPhotoCellID])
    {
        BVTYelpPhotoTableViewCell *photoCell = (BVTYelpPhotoTableViewCell *)cell;
        photoCell.photoView.image = [self.business.photos objectAtIndex:indexPath.row];
    }
 
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
