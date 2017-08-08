//
//  SUPPresentationTableViewController.m
//  SUP
//
//  Created by Greg on 2/15/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "SUPPresentationTableViewController.h"

#import "SUPYelpPhotoTableViewCell.h"
#import "SUPYelpReviewsTableViewCell.h"
#import "YLPReview.h"
#import "SUPStyles.h"
#import "YLPUser.h"

@interface SUPPresentationTableViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@end

static NSString *const kPhotoNib = @"SUPYelpPhotoTableViewCell";
static NSString *const kPhotoCellID = @"SUPYelpPhotoCellIdentifier";
static NSString *const kReviewsNib = @"SUPYelpReviewsTableViewCell";
static NSString *const kReviewsCellID = @"SUPReviewsPhotoCellIdentifier";

@implementation SUPPresentationTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receivedData
{
    [self.tableView reloadData];
    
    self.preferredContentSize = CGSizeMake(320, self.tableView.contentSize.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedData)
                                                 name:@"receivedBizPhotos"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedData)
                                                 name:@"receivedBizReviews"
                                               object:nil];
    
    self.popoverPresentationController.sourceRect = CGRectMake(0.f,0.f,160.f,300.f);
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *yelpPhotoCellNib = [UINib nibWithNibName:kPhotoNib bundle:nil];
    [self.tableView registerNib:yelpPhotoCellNib forCellReuseIdentifier:kPhotoCellID];
    
    UINib *yelpReviewsCellNib = [UINib nibWithNibName:kReviewsNib bundle:nil];
    [self.tableView registerNib:yelpReviewsCellNib forCellReuseIdentifier:kReviewsCellID];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.title containsString:@"Reviews"])
    {
        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_review_large"]];
        [self.tableView addSubview:self.imgView];
        
        self.preferredContentSize = CGSizeMake(320, 266);
        
        self.imgView.center = self.view.center;
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.imgView removeFromSuperview];
    
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
        SUPYelpReviewsTableViewCell *reviewsCell = (SUPYelpReviewsTableViewCell *)cell;
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
        SUPYelpPhotoTableViewCell *photoCell = (SUPYelpPhotoTableViewCell *)cell;
        photoCell.tag = indexPath.row;

        id shouldBeAnImage = [self.business.photos objectAtIndex:indexPath.row];
        
        UIImage *image;
        if ([shouldBeAnImage isKindOfClass:[NSString class]])
        {
            image = [UIImage imageNamed:@"placeholder_photo_large"];
        }
        else if ([shouldBeAnImage isKindOfClass:[UIImage class]])
        {
            image = shouldBeAnImage;
        }
        photoCell.photoView.image = image; // issue here as image can be a string
    }
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
