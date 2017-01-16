//
//  BVTYelpRatingTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/27/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTYelpRatingTableViewCell.h"

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
