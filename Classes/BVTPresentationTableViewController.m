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

NSString *const kstar_zero_mini          = @"star_zero_mini.png";
NSString *const kstar_one_mini           = @"star_one_mini.png";
NSString *const kstar_one_half_mini      = @"star_one_half_mini.png";
NSString *const kstar_two_mini           = @"star_two_mini.png";
NSString *const kstar_two_half_mini      = @"star_two_half_mini.png";
NSString *const kstar_three_mini         = @"star_three_mini.png";
NSString *const kstar_three_half_mini    = @"star_three_half_mini.png";
NSString *const kstar_four_mini          = @"star_four_mini.png";
NSString *const kstar_four_half_mini     = @"star_four_half_mini.png";
NSString *const kstar_five_mini          = @"star_five_mini.png";

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
        if ([button.titleLabel.text containsString:@"Reviews"])
        {
            return self.business.reviews.count;
        }
        else if ([button.titleLabel.text containsString:@"Photos"])
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
        if ([button.titleLabel.text containsString:@"Reviews"])
        {
            identifier = kReviewsCellID;
        }
        else if ([button.titleLabel.text containsString:@"Photos"])
        {
            identifier = kPhotoCellID;
        }
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
            NSString *userStr;
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
            ratingString = kstar_zero_mini;
        }
        else if ([rating integerValue] == 1)
        {
            ratingString = kstar_one_mini;
        }
        else if ([rating integerValue] == 1.5)
        {
            ratingString = kstar_one_half_mini;
        }
        else if ([rating integerValue] == 2)
        {
            ratingString = kstar_two_mini;
        }
        else if ([rating integerValue] == 2.5)
        {
            ratingString = kstar_two_half_mini;
        }
        else if ([rating integerValue] == 3)
        {
            ratingString = kstar_three_mini;
        }
        else if ([rating integerValue] == 3.5)
        {
            ratingString = kstar_three_half_mini;
        }
        else if ([rating integerValue] == 4)
        {
            ratingString = kstar_four_mini;
        }
        else if ([rating integerValue] == 4.5)
        {
            ratingString = kstar_four_half_mini;
        }
        else
        {
            // 5 star rating
            ratingString = kstar_five_mini;
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
