//
//  BVTSurpriseRecommendationsTableViewController.h
//  bvt
//
//  Created by Greg on 4/8/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BVTSurpriseRecommendationsTableViewControllerDelegate <NSObject>

- (void)didTapBackWithDetails:(NSMutableArray *)details ;

@end

@interface BVTSurpriseRecommendationsTableViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *businessOptions;
@property(nonatomic, weak)id <BVTSurpriseRecommendationsTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cachedDetails;

@end
