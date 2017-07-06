//
//  BVTTabBarController.m
//  bvt
//
//  Created by Greg on 5/14/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTTabBarController.h"

#import "BVTStyles.h"

@interface BVTTabBarController ()

@end

@implementation BVTTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tabBar setTintColor:[BVTStyles tabBarTint]];
}

@end
