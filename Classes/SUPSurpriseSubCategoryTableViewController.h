//
//  SUPSurpriseCategoryTableViewController.h
//  SUP
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUPSurpriseSubCategoryTableViewControllerDelegate <NSObject>

- (void)didTapBackWithCategories:(NSMutableDictionary *)categories;
- (void)didTapBackWithDetails:(NSMutableArray *)details ;

@end

@interface SUPSurpriseSubCategoryTableViewController : UIViewController

@property (nonatomic, copy) NSString *categoryTitle;
@property (nonatomic, strong) NSMutableDictionary *catDict;
@property (nonatomic, strong) NSMutableArray *cachedDetails;
@property(nonatomic, weak)id <SUPSurpriseSubCategoryTableViewControllerDelegate> delegate;

@end
