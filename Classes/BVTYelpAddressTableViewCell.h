//
//  BVTYelpAddressTableViewCell.h
//  burlingtonian
//
//  Created by Greg on 12/30/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLPBusiness.h"

@interface BVTYelpAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) YLPBusiness *selectedBusiness;
@property (nonatomic, copy) NSString *mapsQueryString;

@end
