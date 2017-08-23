//
//  SUPYelpContactTableViewCell.h
//  Sup? City
//
//  Created by Greg on 12/23/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLPBusiness.h"

@interface SUPYelpPhoneTableViewCell : UITableViewCell

@property (nonatomic, strong) YLPBusiness *selectedBusiness;

- (IBAction)didTapPhoneNumberButton:(id)sender;

@end
