//
//  BVTSurpriseShoppingCartTableViewController.h
//  bvt
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BVTSurpriseShoppingCartTableViewControllerDelegate <NSObject>

- (void)didTapBackWithCategories:(NSMutableDictionary *)categories ;
- (void)didRemoveObjectsFromArray:(NSArray *)array;
- (void)didTapBackWithDetails:(NSMutableArray *)details ;

@end

@interface BVTSurpriseShoppingCartTableViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *catDict;
@property(nonatomic, weak)id <BVTSurpriseShoppingCartTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cachedDetails;

@end
