//
//  BVTSurpriseCategoryTableViewController.h
//  bvt
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BVTSurpriseSubCategoryTableViewControllerDelegate <NSObject>

- (void)didTapBackWithCategories:(NSMutableDictionary *)categories;
- (void)didTapBackWithDetails:(NSMutableArray *)details ;

@end

@interface BVTSurpriseSubCategoryTableViewController : UIViewController

@property (nonatomic, copy) NSString *categoryTitle;
@property (nonatomic, strong) NSMutableDictionary *catDict;
@property (nonatomic, strong) NSMutableArray *cachedDetails;
@property(nonatomic, weak)id <BVTSurpriseSubCategoryTableViewControllerDelegate> delegate;

@end
