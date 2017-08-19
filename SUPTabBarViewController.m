//
//  SUPTabBarViewController.m
//  SUP
//
//  Created by Greg on 7/5/17.
//  Copyright © 2017 gms. All rights reserved.
//

@import GoogleMobileAds;

#import "AppDelegate.h"
#import "SUPTabBarViewController.h"

@interface SUPTabBarViewController () <GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, weak) IBOutlet UIView *adView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *adViewHeightConstraint;

@end

@implementation SUPTabBarViewController

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    self.bannerView = bannerView;

    self.bannerView.alpha = 0;
    [self.adView addSubview:self.bannerView];
    [self.bannerView setFrame:CGRectMake(0, 0, self.adView.frame.size.width, 60.f)];
    self.adViewHeightConstraint.constant = 60.f;
    [UIView animateWithDuration:1.0 animations:^{
        self.bannerView.alpha = 1;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.adViewHeightConstraint.constant = 0.f;
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    self.bannerView.rootViewController = self;
//    self.bannerView.adUnitID = @"ca-app-pub-8236497982755596/2363755102";
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;

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
