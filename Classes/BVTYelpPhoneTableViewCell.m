//
//  BVTYelpContactTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/23/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTYelpPhoneTableViewCell.h"

@interface BVTYelpPhoneTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UIImageView *PhoneImageView;

@end

@implementation BVTYelpPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    self.phoneNumberLabel.text = self.selectedBusiness.phone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
