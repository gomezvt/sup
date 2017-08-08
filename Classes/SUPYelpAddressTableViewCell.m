//
//  SUPYelpAddressTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/30/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPYelpAddressTableViewCell.h"

#import "YLPLocation.h"
#import "YLPCoordinate.h"

@interface SUPYelpAddressTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@end

@implementation SUPYelpAddressTableViewCell

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    YLPLocation *location = self.selectedBusiness.location;
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
