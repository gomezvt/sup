//
//  AppDelegate.h
//  bvt
//
//  Created by Greg on 1/15/17.
//  Copyright © 2017 gms. All rights reserved.
//

@import UIKit;

@class YLPClient;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (YLPClient *)sharedClient;

@end
