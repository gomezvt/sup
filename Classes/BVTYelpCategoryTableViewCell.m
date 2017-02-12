//
//  BVTYelpCategoryTableViewCell.m
//  bvt
//
//  Created by Greg on 2/6/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTYelpCategoryTableViewCell.h"

#import "YLPCategory.h"


@implementation BVTYelpCategoryTableViewCell

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
    
    NSMutableString *catString = [[NSMutableString alloc] initWithString:@"Place categories: "];
    for (YLPCategory *category in self.selectedBusiness.categories)
    {
        [catString appendString:[NSString stringWithFormat:@"%@, ", category.name]];
    }
    
    self.categoryLabel.text = [catString substringToIndex:[catString length] -2];
}
@end
