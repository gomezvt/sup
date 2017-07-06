//
//  BVTTabBarViewController.m
//  bvt
//
//  Created by Greg on 7/5/17.
//  Copyright © 2017 gms. All rights reserved.
//

@import GoogleMobileAds;

#import "AppDelegate.h"
#import "BVTTabBarViewController.h"

@interface BVTTabBarViewController ()

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, weak) IBOutlet UIView *adView;

@end

@implementation BVTTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    self.bannerView.rootViewController = self;

    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/6300978111";

    GADRequest *request = [GADRequest request];
//    request.testDevices = @[kGADSimulatorID];
    
    [self.bannerView loadRequest:request];
    
    [self.adView addSubview:self.bannerView];
    [self.bannerView setFrame:CGRectMake(0, 0, self.adView.frame.size.width, 60.f)];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
