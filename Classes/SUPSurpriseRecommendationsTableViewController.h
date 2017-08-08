//
//  SUPSurpriseRecommendationsTableViewController.h
//  SUP
//
//  Created by Greg on 4/8/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUPSurpriseRecommendationsTableViewControllerDelegate <NSObject>

- (void)didTapBackWithDetails:(NSMutableArray *)details ;

@end

@interface SUPSurpriseRecommendationsTableViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *businessOptions;
@property(nonatomic, weak)id <SUPSurpriseRecommendationsTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cachedDetails;

@end
