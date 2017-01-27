//
//  BVTYelpAddressTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/30/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTYelpAddressTableViewCell.h"

#import "YLPLocation.h"
#import "YLPCoordinate.h"

@interface BVTYelpAddressTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel2;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel3;

@end

@implementation BVTYelpAddressTableViewCell

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    NSMutableString *cityStateZipString = [[NSMutableString alloc] init];
    if (self.selectedBusiness.location.city)
    {
        NSString *cityString = self.selectedBusiness.location.city;
        [cityStateZipString appendString:cityString];
    }
    
    if (self.selectedBusiness.location.stateCode)
    {
        NSString *stateString = [NSString stringWithFormat:@", %@", self.selectedBusiness.location.stateCode];
        [cityStateZipString appendString:stateString];
    }
    
    if (self.selectedBusiness.location.postalCode)
    {
        NSString *postalString = [NSString stringWithFormat:@" %@", self.selectedBusiness.location.postalCode];
        [cityStateZipString appendString:postalString];
    }
    
    if (self.selectedBusiness.location.address.count == 1)
    {
        NSString *addressString = self.selectedBusiness.location.address[0];
        self.addressLabel.text = addressString;
        self.addressLabel2.text = cityStateZipString;
        [self.addressLabel3 removeFromSuperview];
    }
    else if (self.selectedBusiness.location.address.count == 2)
    {
        NSString *addressString = self.selectedBusiness.location.address[0];
        NSString *addressString1 = self.selectedBusiness.location.address[1];

        self.addressLabel.text = addressString;
        self.addressLabel2.text = addressString1;
        self.addressLabel3.text = cityStateZipString;
    }
    else
    {
        self.textLabel.text = cityStateZipString;
        
        [self.addressLabel removeFromSuperview];
        [self.addressLabel2 removeFromSuperview];
        [self.addressLabel3 removeFromSuperview];
    }
    
    self.mapsQueryString = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@&s11=%f,%f&z=10&t=s", self.selectedBusiness.name, self.selectedBusiness.location.coordinate.latitude, self.selectedBusiness.location.coordinate.longitude];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
