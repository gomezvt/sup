//
//  BVTThumbNailTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTThumbNailTableViewCell.h"

#import "YLPLocation.h"
#import "AppDelegate.h"
#import "BVTStyles.h"
#import "YLPLocation.h"
#import "YLPCoordinate.h"

@interface BVTThumbNailTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
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
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDel.userLocation)
    {
        self.milesLabel.hidden = YES;
    }
    else
    {
        if (business.location.coordinate.latitude && business.location.coordinate.longitude)
        {
            self.milesLabel.hidden = NO;

            CLLocation *bizLocation = [[CLLocation alloc] initWithLatitude:business.location.coordinate.latitude longitude:business.location.coordinate.longitude];
            
            CLLocationDistance meters = [appDel.userLocation distanceFromLocation:bizLocation];
            double miles = meters / 1609.34;
            business.miles = miles;
            
            NSString *milesStr = [NSString stringWithFormat:@"%.2f mi.", self.business.miles];
            self.milesLabel.text = milesStr;
        }
        else
        {
            // Don't display miles label if we don't have latitude and longitude to work with
            self.milesLabel.text = @"";
        }
    }


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
    }
    else if (location.address.count == 1)
    {
        self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@", location.address[0], cityStateZipString];
    }
    else if (location.address.count == 2)
    {
        self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", location.address[0], location.address[1], cityStateZipString];
    }
    else if (location.address.count == 3)
    {
        self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@, %@\n%@", location.address[0], location.address[1], location.address[2], cityStateZipString];
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
