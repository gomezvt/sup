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

+ (instancetype)configureHUDWithView:(UIView *)view animated:(BOOL)animated
{
    BVTHUDView *hud = [[self alloc] initWithFrame:CGRectMake(0,0,70.f,70.f)];
    
    [view addSubview:hud];
 
    return hud;
}


@end
