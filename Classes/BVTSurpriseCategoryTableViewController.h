//
//  BVTSurpriseCategoryTableViewController.h
//  bvt
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BVTSurpriseCategoryTableViewControllerDelegate <NSObject>

- (void)didTapBackChevron:(id)sender withCategories:(NSMutableArray *)categories;

@end

@interface BVTSurpriseCategoryTableViewController : UIViewController

@property (nonatomic, copy) NSString *categoryTitle;
@property (nonatomic, strong) NSMutableArray *selectedCategories;
@property(nonatomic, weak)id <BVTSurpriseCategoryTableViewControllerDelegate> delegate;

@end
