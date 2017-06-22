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
#import "YLPReview.h"
#import "BVTStyles.h"
#import "YLPUser.h"
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

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.preferredContentSize = CGSizeMake(320, self.tableView.contentSize.height);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.title containsString:@"Reviews"])
    {
        return self.business.reviews.count;
    }
    else if ([self.title containsString:@"Photos"])
    {
        return self.business.photos.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";

    if ([self.title containsString:@"Reviews"])
    {
        identifier = kReviewsCellID;
    }
    else if ([self.title containsString:@"Photos"])
    {
        identifier = kPhotoCellID;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if ([identifier isEqualToString:kReviewsCellID])
    {
        BVTYelpReviewsTableViewCell *reviewsCell = (BVTYelpReviewsTableViewCell *)cell;
        reviewsCell.tag = cell.tag;
        
        YLPReview *review = [self.business.reviews objectAtIndex:indexPath.row];
        NSDateFormatter *dateFormatter;
        if (!dateFormatter)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
        }
        [dateFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
        
        reviewsCell.dateLabel.text = [dateFormatter stringFromDate:review.timeCreated];
        reviewsCell.reviewLabel.text = review.excerpt;
        reviewsCell.nameLabel.text = review.user.name;
        
        UIImage *image = [UIImage imageNamed:@"placeholder"];
        for (NSDictionary *dict in self.business.userPhotosArray)
        {
            NSString *key = [[dict allKeys] lastObject];
            if ([key isEqual:review.user.imageURL])
            {
                image = dict[key];
            }
        }
        reviewsCell.userImageView.image = image;

        NSString *ratingString;
        if (review.rating == 0)
        {
            ratingString = star_zero_mini;
        }
        else if (review.rating == 1)
        {
            ratingString = star_one_mini;
        }
        else if (review.rating == 1.5)
        {
            ratingString = star_one_half_mini;
        }
        else if (review.rating == 2)
        {
            ratingString = star_two_mini;
        }
        else if (review.rating == 2.5)
        {
            ratingString = star_two_half_mini;
        }
        else if (review.rating == 3)
        {
            ratingString = star_three_mini;
        }
        else if (review.rating == 3.5)
        {
            ratingString = star_three_half_mini;
        }
        else if (review.rating == 4)
        {
            ratingString = star_four_mini;
        }
        else if (review.rating == 4.5)
        {
            ratingString = star_four_half_mini;
        }
        else
        {
            // 5 star rating
            ratingString = star_five_mini;
        }
        
        [reviewsCell.ratingView setImage:[UIImage imageNamed:ratingString]];
    }
    else if ([identifier isEqualToString:kPhotoCellID])
    {
        BVTYelpPhotoTableViewCell *photoCell = (BVTYelpPhotoTableViewCell *)cell;
        photoCell.tag = indexPath.row;

        UIImage *image = [self.business.photos objectAtIndex:indexPath.row];
        photoCell.photoView.image = image;
    }
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
