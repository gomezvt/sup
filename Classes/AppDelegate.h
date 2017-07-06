//
//  AppDelegate.h
//  bvt
//
//  Created by Greg on 1/15/17.
//  Copyright © 2017 gms. All rights reserved.
//

@import UIKit;

@class YLPClient;
@class GADMobileAds;
@class GADBannerView;

#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) GADBannerView *bannerView;

+ (YLPClient *)yelp;
+ (GADMobileAds *)google;
    
@end
