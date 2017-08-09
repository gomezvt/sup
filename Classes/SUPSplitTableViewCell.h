//
//  SUPSplitTableViewCell.h
//  SUP? NYC
//
//  Created by Greg on 12/21/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLPBusiness.h"

@interface SUPSplitTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) YLPBusiness *selectedBusiness;

@end
