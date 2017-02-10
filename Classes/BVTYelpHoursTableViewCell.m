//
//  BVTYelpHoursTableViewCell.m
//  bvt
//
//  Created by Greg on 2/6/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTYelpHoursTableViewCell.h"

#import "BVTStyles.h"

@implementation BVTYelpHoursTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    self.isOpenLabel.text = self.selectedBusiness.isOpenNow ? @"Open Now" : @"Closed Now";
    self.isOpenLabel.textColor = [UIColor redColor];
    if ([self.isOpenLabel.text isEqualToString:@"Open Now"])
    {
        self.isOpenLabel.textColor = [BVTStyles moneyGreen];
    }
    
}

@end
