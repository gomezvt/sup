//
//  BVTYelpRatingTableViewCell.h
//  burlingtonian
//
//  Created by Greg on 12/27/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLPBusiness.h"

@interface BVTYelpRatingTableViewCell : UITableViewCell

@property (nonatomic, strong) YLPBusiness *selectedBusiness;
@property (nonatomic, weak) IBOutlet UILabel *yelpPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *reviewsCountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *ratingStarsView;

@end
