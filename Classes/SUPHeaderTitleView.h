//
//  SUPHeaderTitleView.h
//  Sup? City
//
//  Created by Greg on 12/24/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUPHeaderTitleView : UIView

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleViewLabelConstraint;
@property (nonatomic, weak) IBOutlet UILabel *cityNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *supLabel;

@end
