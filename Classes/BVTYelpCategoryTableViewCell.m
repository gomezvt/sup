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
    
    YLPCategory *categoryOne;
    YLPCategory *categoryTwo;
    YLPCategory *categoryThree;
    
    NSString *catString;
    NSArray *categories = self.selectedBusiness.categories;
    
    if (self.selectedBusiness.categories.count == 1)
    {
        categoryOne = categories[0];
        catString = [NSString stringWithFormat:@"Place category: %@", categoryOne.name];
    }
    else if (self.selectedBusiness.categories.count == 2)
    {
        categoryOne = categories[0];
        categoryTwo = categories[1];
        
        catString = [NSString stringWithFormat:@"Place categories: %@, %@", categoryOne.name, categoryTwo.name];
    }
    else if (self.selectedBusiness.categories.count == 3)
    {
        categoryOne = categories[0];
        categoryTwo = categories[1];
        categoryThree = categories[2];
        
        catString = [NSString stringWithFormat:@"Place categories: %@, %@, %@", categoryOne.name, categoryTwo.name, categoryThree.name];
    }
    
    self.categoryLabel.text = catString;
}
@end
