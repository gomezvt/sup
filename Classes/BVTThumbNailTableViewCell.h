//
//  BVTThumbNailTableViewCell.h
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLPBusiness.h"

@interface BVTThumbNailTableViewCell : UITableViewCell

@property (nonatomic, strong) YLPBusiness *business;
@property (nonatomic, weak) IBOutlet UIImageView *thumbNailView;
@property (nonatomic, weak) IBOutlet UILabel *openCloseLabel;

@end
