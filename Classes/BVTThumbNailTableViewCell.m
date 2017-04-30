//
//  BVTThumbNailTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTThumbNailTableViewCell.h"

#import "YLPLocation.h"

#import "BVTStyles.h"

@interface BVTThumbNailTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel2;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel3;
@property (nonatomic, weak) IBOutlet UILabel *milesLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
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
    
    NSString *miles = [NSString stringWithFormat:@"%.2f mi.", self.business.miles];
    _milesLabel.text = miles;
    self.priceLabel.text = business.price;
    
    YLPLocation *location = business.location;
    self.titleLabel.text = business.name;
    NSMutableString *cityStateZipString = [[NSMutableString alloc] init];
    if (location.city)
    {
        NSString *cityString = location.city;
        [cityStateZipString appendString:cityString];
    }
    
    if (location.stateCode)
    {
        NSString *stateString = [NSString stringWithFormat:@", %@", location.stateCode];
        [cityStateZipString appendString:stateString];
    }
    
    if (location.postalCode)
    {
        NSString *postalString = [NSString stringWithFormat:@" %@", location.postalCode];
        [cityStateZipString appendString:postalString];
    }
    
    if (location.address.count == 0)
    {
        self.addressLabel.text = cityStateZipString;

        [self.addressLabel2 removeFromSuperview];
        [self.addressLabel3 removeFromSuperview];
    }
    else if (location.address.count == 1)
    {
        self.addressLabel.text = location.address[0];
        self.addressLabel2.text = cityStateZipString;
        [self.addressLabel3 removeFromSuperview];
    }
    else if (location.address.count == 2)
    {
        self.addressLabel.text = location.address[0];
        self.addressLabel2.text = location.address[1];
        self.addressLabel3.text = cityStateZipString;
    }
    else if (location.address.count == 3)
    {
        self.addressLabel.text = location.address[0];
        self.addressLabel2.text = [NSString stringWithFormat:@"%@, %@", location.address[1], location.address[2]];
        self.addressLabel3.text = cityStateZipString;
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
