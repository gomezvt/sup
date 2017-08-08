//
//  SUPThumbNailTableViewCell.h
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLPBusiness.h"

@interface SUPThumbNailTableViewCell : UITableViewCell

@property (nonatomic, strong) YLPBusiness *business;
@property (nonatomic, weak) IBOutlet UIImageView *thumbNailView;
@property (nonatomic, weak) IBOutlet UILabel *openCloseLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondaryOpenCloseLabel;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *secondaryHeightConstraint;

@end
