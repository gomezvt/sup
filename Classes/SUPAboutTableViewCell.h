//
//  SUPAboutTableViewCell.h
//  SUP
//
//  Created by Greg on 6/1/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUPAboutTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *aboutImageView;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewWidth;

@end
