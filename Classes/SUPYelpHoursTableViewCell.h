//
//  SUPYelpHoursTableViewCell.h
//  SUP
//
//  Created by Greg on 2/6/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLPBusiness.h"

@interface SUPYelpHoursTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *isOpenLabel;
@property (nonatomic, weak) IBOutlet UILabel *openClosesLabel;
@property (nonatomic, strong) YLPBusiness *selectedBusiness;

@end
