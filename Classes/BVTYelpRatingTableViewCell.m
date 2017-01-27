//
//  BVTYelpRatingTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/27/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTYelpRatingTableViewCell.h"

#import "YLPCategory.h"

NSString *const star_zero       = @"star_zero.png";
NSString *const star_one        = @"star_one.png";
NSString *const star_one_half   = @"star_one_half.png";
NSString *const star_two        = @"star_two.png";
NSString *const star_two_half   = @"star_two_half.png";
NSString *const star_three      = @"star_three.png";
NSString *const star_three_half = @"star_three_half.png";
NSString *const star_four       = @"star_four.png";
NSString *const star_four_half  = @"star_four_half.png";
NSString *const star_five       = @"star_five.png";

@implementation BVTYelpRatingTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    self.reviewsCountLabel.text = [NSString stringWithFormat:@"%ld Review(s) in", self.selectedBusiness.reviewCount];
    
    self.yelpPriceLabel.text = self.selectedBusiness.price;
    
    YLPCategory *categoryOne;
    YLPCategory *categoryTwo;
    YLPCategory *categoryThree;
    
    NSString *catString;
    NSArray *categories = self.selectedBusiness.categories;
    
    if (self.selectedBusiness.categories.count == 1)
    {
        categoryOne = categories[0];
        catString = categoryOne.name;
    }
    else if (self.selectedBusiness.categories.count == 2)
    {
        categoryOne = categories[0];
        categoryTwo = categories[1];
        
        catString = [NSString stringWithFormat:@"%@, %@", categoryOne.name, categoryTwo.name];
    }
    else if (self.selectedBusiness.categories.count == 3)
    {
        categoryOne = categories[0];
        categoryTwo = categories[1];
        categoryThree = categories[2];
        
        catString = [NSString stringWithFormat:@"%@, %@, %@", categoryOne.name, categoryTwo.name, categoryThree.name];
    }
    
    self.yelpCategoryLabel.text = catString;
    
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

- (IBAction)didTapYelpButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:self.selectedBusiness.URL options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
