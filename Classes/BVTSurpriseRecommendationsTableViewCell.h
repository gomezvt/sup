//
//  BVTSurpriseRecommendationsTableViewCell.h
//  bvt
//
//  Created by Greg on 4/29/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLPBusiness.h"

@interface BVTSurpriseRecommendationsTableViewCell : UITableViewCell

@property (nonatomic, strong) YLPBusiness *business;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel2;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel3;
@property (nonatomic, weak) IBOutlet UIImageView *thumbNailView;
@property (nonatomic, weak) IBOutlet UILabel *milesLabel;

@end
