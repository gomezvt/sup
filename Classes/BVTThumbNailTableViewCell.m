//
//  BVTThumbNailTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTThumbNailTableViewCell.h"

#import "YLPLocation.h"

NSString *const star_zero_mini          = @"star_zero_mini.png";
NSString *const star_one_mini           = @"star_one_mini.png";
NSString *const star_one_half_mini      = @"star_one_half_mini.png";
NSString *const star_two_mini           = @"star_two_mini.png";
NSString *const star_two_half_mini      = @"star_two_half_mini.png";
NSString *const star_three_mini         = @"star_three_mini.png";
NSString *const star_three_half_mini    = @"star_three_half_mini.png";
NSString *const star_four_mini          = @"star_four_mini.png";
NSString *const star_four_half_mini     = @"star_four_half_mini.png";
NSString *const star_five_mini          = @"star_five_mini.png";

@interface BVTThumbNailTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *ratingStarsView;

@end

@implementation BVTThumbNailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setBusiness:(YLPBusiness *)business
{
    _business = business;
    
    YLPLocation *location = business.location;
    self.titleLabel.text = business.name;
    
    if (location.address.count > 0)
    {
        self.addressLabel.text = location.address[0];
        self.addressLabel2.text = [NSString stringWithFormat:@"%@, %@ %@", location.city, location.stateCode, location.postalCode];
    }
    else
    {
        self.addressLabel.text = [NSString stringWithFormat:@"%@, %@ %@", location.city, location.stateCode, location.postalCode];
        [self.addressLabel2 removeFromSuperview];
    }
    
    NSString *ratingString;
    if (self.business.rating == 0)
    {
        ratingString = star_zero_mini;
    }
    else if (self.business.rating == 1)
    {
        ratingString = star_one_mini;
    }
    else if (self.business.rating == 1.5)
    {
        ratingString = star_one_half_mini;
    }
    else if (self.business.rating == 2)
    {
        ratingString = star_two_mini;
    }
    else if (self.business.rating == 2.5)
    {
        ratingString = star_two_half_mini;
    }
    else if (self.business.rating == 3)
    {
        ratingString = star_three_mini;
    }
    else if (self.business.rating == 3.5)
    {
        ratingString = star_three_half_mini;
    }
    else if (self.business.rating == 4)
    {
        ratingString = star_four_mini;
    }
    else if (self.business.rating == 4.5)
    {
        ratingString = star_four_half_mini;
    }
    else
    {
        // 5 star rating
        ratingString = star_five_mini;
    }
    
    [self.ratingStarsView setImage:[UIImage imageNamed:ratingString]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
