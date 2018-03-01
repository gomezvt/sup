//
//  SUPFavoritesTableViewCell.m
//  sup
//
//  Created by Greg on 2/28/18.
//  Copyright © 2018 gms. All rights reserved.
//

#import "SUPFavoritesTableViewCell.h"
#import "SUPStyles.h"

@implementation SUPFavoritesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.swch.onTintColor = [SUPStyles tabBarTint];
    [self.swch setOn:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
