//
//  BVTYelpReviewsTableViewCell.h
//  bvt
//
//  Created by Greg on 2/16/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLPBusiness.h"

@interface BVTYelpReviewsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *reviewLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *ratingView;
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;

@property (nonatomic, strong) YLPBusiness *business;

@end
