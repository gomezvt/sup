//
//  SUPTabBarController.m
//  SUP
//
//  Created by Greg on 5/14/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "SUPTabBarController.h"

#import "SUPStyles.h"

@interface SUPTabBarController ()

@end

@implementation SUPTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tabBar setTintColor:[SUPStyles tabBarTint]];
}

@end
