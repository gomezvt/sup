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
    
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    CGFloat tabBarVertical = mainScreen.size.height - 110.f;
    
    [self.tabBar setFrame:CGRectMake(0, tabBarVertical, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];

    [self.tabBar setTintColor:[BVTStyles tabBarTint]];
}

@end
