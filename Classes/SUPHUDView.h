//
//  SUPHUDView.h
//  SUP
//
//  Created by Greg on 2/19/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUPHUDViewDelegate <NSObject>

- (void)didTapHUDCancelButton;

@end

@interface SUPHUDView : UIView

+ (instancetype)hudWithView:(UIView *)view;
@property(nonatomic, weak)id <SUPHUDViewDelegate> delegate;

@end
