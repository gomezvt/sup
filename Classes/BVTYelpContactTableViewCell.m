//
//  BVTYelpContactTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/23/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTYelpContactTableViewCell.h"

@interface BVTYelpContactTableViewCell ()

@property (nonatomic, weak) IBOutlet UIView *backView;

@end

@implementation BVTYelpContactTableViewCell

- (void)awakeFromNib {
    
    self.backView.layer.cornerRadius = 15.f;
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end