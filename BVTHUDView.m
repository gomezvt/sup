//
//  BVTHUDView.m
//  bvt
//
//  Created by Greg on 2/19/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTHUDView.h"

#import "BVTStyles.h"

@interface BVTHUDView ()

@end

@implementation BVTHUDView

+ (instancetype)hudWithView:(UIView *)view
{
    BVTHUDView *hud = [[self alloc] initWithFrame:CGRectMake(0, 0, 110.f, 110.f)];
    [view addSubview:hud];
    
    hud.backgroundColor = [BVTStyles iconGreen];
    hud.layer.cornerRadius = 20.f;
    hud.alpha = .9f;

    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ai.center = CGPointMake(hud.center.x, 40.f);
    [ai startAnimating];
    [hud addSubview:ai];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(hud.center.x, 80.f);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
    label.text = @"Loading...";

    [hud addSubview:label];

    hud.center = view.center;

    return hud;
}

@end
