//
//  BVTStyles.m
//  burlingtonian
//
//  Created by Greg on 12/30/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTStyles.h"

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

@implementation BVTStyles

+ (UIColor *)tabBarTint
{
    return [UIColor colorWithRed:0.f/255 green:145.f/255 blue:0.f/255 alpha:1.f];
}

+ (UIColor *)lightGray
{
    return [UIColor colorWithRed:153.f/255 green:153.f/255 blue:153.f/255 alpha:1.f];
}

+ (UIColor *)iconGreen
{
    return [UIColor colorWithRed:75.f/255 green:125.f/255 blue:90.f/255 alpha:1.f];
}

+ (UIColor *)buttonBorder
{
    return [UIColor colorWithRed:135.f/255 green:172.f/255 blue:147.f/255 alpha:1.f];
}

+ (UIColor *)buttonBackGround
{
    return [UIColor colorWithRed:238.f/255 green:243.f/255 blue:240.f/255 alpha:1.f];
}

@end
