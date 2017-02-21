//
//  BVTHUDView.h
//  bvt
//
//  Created by Greg on 2/19/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BVTHUDView : UIView

@property (nonatomic, weak) IBOutlet UILabel *label;

//+ (instancetype)configureHUDWithView:(UIView *)view animated:(BOOL)animated;
+ (instancetype)hudWithView:(UIView *)view;

@end
