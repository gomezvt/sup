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

#import "BVTStyles.h"

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
        NSDateFormatter *dateFormatter;
        if (!dateFormatter)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
        }
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd  HH':'mm':'ss"];
        
        NSDictionary *reviewDict = [self.business.reviews objectAtIndex:indexPath.row];
        NSDate *date = [dateFormatter dateFromString:reviewDict[@"time_created"]];
        [dateFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
        reviewsCell.dateLabel.text = [dateFormatter stringFromDate:date];
        reviewsCell.reviewLabel.text = reviewDict[@"text"];

        NSDictionary *user = reviewDict[@"user"];
        reviewsCell.nameLabel.text = user[@"name"];
        
        reviewsCell.userImageView.image = [UIImage imageNamed:@"placeholder"];
        dispatch_async(dispatch_get_main_queue(), ^{
            id userId = user[@"image_url"];
            NSString *userStr = @"";
            if ([userId isKindOfClass:[NSString class]])
            {
                userStr = user[@"image_url"];
            }
            NSURL *url = [NSURL URLWithString:userStr];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:imageData];
            if (image)
            {
                reviewsCell.userImageView.image = image;
            }
        });
        
        NSString *ratingString;
        NSNumber *rating = reviewDict[@"rating"];
        if ([rating integerValue] == 0)
        {
            ratingString = star_zero_mini;
        }
        else if ([rating integerValue] == 1)
        {
            ratingString = star_one_mini;
        }
        else if ([rating integerValue] == 1.5)
        {
            ratingString = star_one_half_mini;
        }
        else if ([rating integerValue] == 2)
        {
            ratingString = star_two_mini;
        }
        else if ([rating integerValue] == 2.5)
        {
            ratingString = star_two_half_mini;
        }
        else if ([rating integerValue] == 3)
        {
            ratingString = star_three_mini;
        }
        else if ([rating integerValue] == 3.5)
        {
            ratingString = star_three_half_mini;
        }
        else if ([rating integerValue] == 4)
        {
            ratingString = star_four_mini;
        }
        else if ([rating integerValue] == 4.5)
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
        photoCell.photoView.image = [self.business.photos objectAtIndex:indexPath.row];
    }
 
    return cell;
}

@end
