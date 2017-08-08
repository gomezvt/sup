//
//  SUPHUDView.m
//  SUP
//
//  Created by Greg on 2/19/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "SUPHUDView.h"

#import "SUPStyles.h"

@interface SUPHUDView ()

@end

@implementation SUPHUDView

+ (instancetype)hudWithView:(UIView *)view
{
    UIColor *green = [SUPStyles iconGreen];
    
    SUPHUDView *hud = [[self alloc] initWithFrame:CGRectMake(0.f, 0.f, 110.f, 175.f)];
    [view addSubview:hud];
    
    // Build back plate for HUD components
    UIView *backDrop = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 110.f, 110.f)];
    backDrop.backgroundColor = green;
    backDrop.layer.cornerRadius = 20.f;
    backDrop.alpha = .9f;
    [hud addSubview:backDrop];

    // Get activity indicator and add to hud plate
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ai.center = CGPointMake(hud.center.x, 40.f);
    [ai startAnimating];
    [hud addSubview:ai];
    
    // Get "loading" label and add to hud place
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 20.f)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(hud.center.x, 80.f);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
    label.text = @"Loading...";
    [hud addSubview:label];

    // Build plate to contain cancel button and add to hud place
    UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 110.f, 50.f)];
    cancelView.backgroundColor = green;
    cancelView.layer.cornerRadius = 20.f;
    cancelView.center = CGPointMake(hud.center.x, 140.f);
    cancelView.alpha = .9f;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 110.f, 30.f)];
    [cancelButton setTitle:@"Tap to Cancel" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
    [cancelButton addTarget:nil action:@selector(didTapHUDCancel:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.center = CGPointMake(cancelView.center.x, 25.f);
    [cancelView addSubview:cancelButton];
    [hud addSubview:cancelView];

    // Center hud plate to view
    hud.center = view.center;
    
    return hud;
}

- (void)didTapHUDCancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapHUDCancelButton)])
    {

        [self.delegate didTapHUDCancelButton];
    }
}

@end
