//
//  BVTHUDView.h
//  bvt
//
//  Created by Greg on 2/19/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BVTHUDViewDelegate <NSObject>

- (void)didTapHUDCancelButton;

@end

@interface BVTHUDView : UIView

+ (instancetype)hudWithView:(UIView *)view;
@property(nonatomic, weak)id <BVTHUDViewDelegate> delegate;

@end
