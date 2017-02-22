//
//  BVTHUDView.m
//  bvt
//
//  Created by Greg on 2/19/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTHUDView.h"

@interface BVTHUDView ()

@end

@implementation BVTHUDView

+ (instancetype)hudWithView:(UIView *)view
{
    CGRect rect = CGRectMake(0, 0, 80, 80);
    
    BVTHUDView *hud = [[self alloc] initWithFrame:rect];
    hud.center = view.center;
    [view addSubview:hud];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -150, 80, 80)];
    label.text = @"Loading...";
    label.textAlignment = NSTextAlignmentCenter;
    [hud addSubview:label];

    return hud;
}

@end
