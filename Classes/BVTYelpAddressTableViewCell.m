//
//  BVTYelpAddressTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/30/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTYelpAddressTableViewCell.h"

#import "YLPLocation.h"

@interface BVTYelpAddressTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel2;

@end

@implementation BVTYelpAddressTableViewCell

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    YLPLocation *location = self.selectedBusiness.location;
    if (location.address.count > 0)
    {
        self.addressLabel.text = location.address[0];
        self.addressLabel2.text = [NSString stringWithFormat:@"%@, %@ %@", location.city, location.stateCode, location.postalCode];
    }
    else
    {
        self.addressLabel.text = nil;
        self.addressLabel2.text = nil;

        self.textLabel.text = [NSString stringWithFormat:@"%@, %@ %@", location.city, location.stateCode, location.postalCode];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
