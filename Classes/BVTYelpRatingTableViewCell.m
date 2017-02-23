//
//  BVTYelpRatingTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/27/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTYelpRatingTableViewCell.h"

#import "BVTStyles.h"



@implementation BVTYelpRatingTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    self.reviewsCountLabel.text = [NSString stringWithFormat:@"Based on (%ld) reviews", self.selectedBusiness.reviewCount];
    
    self.yelpPriceLabel.text = self.selectedBusiness.price;
    
    NSString *ratingString;
    if (self.selectedBusiness.rating == 0)
    {
        ratingString = star_zero;
    }
    else if (self.selectedBusiness.rating == 1)
    {
        ratingString = star_one;
    }
    else if (self.selectedBusiness.rating == 1.5)
    {
        ratingString = star_one_half;
    }
    else if (self.selectedBusiness.rating == 2)
    {
        ratingString = star_two;
    }
    else if (self.selectedBusiness.rating == 2.5)
    {
        ratingString = star_two_half;
    }
    else if (self.selectedBusiness.rating == 3)
    {
        ratingString = star_three;
    }
    else if (self.selectedBusiness.rating == 3.5)
    {
        ratingString = star_three_half;
    }
    else if (self.selectedBusiness.rating == 4)
    {
        ratingString = star_four;
    }
    else if (self.selectedBusiness.rating == 4.5)
    {
        ratingString = star_four_half;
    }
    else
    {
        // 5 star rating
        ratingString = star_five;
    }
    
    [self.ratingStarsView setImage:[UIImage imageNamed:ratingString]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
