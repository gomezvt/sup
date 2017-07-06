//
//  BVTSubCategoryTableViewController.h
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLPSearch;

@protocol BVTSubCategoryTableViewControllerDelegate <NSObject>

- (void)didTapBackWithDetails:(NSMutableDictionary *)details ;

@end

@interface BVTSubCategoryTableViewController : UIViewController 

@property (nonatomic, copy) NSString *subCategoryTitle;
@property (nonatomic, strong) NSArray *filteredResults;
@property (nonatomic, strong) NSMutableDictionary *cachedDetails;
@property(nonatomic, weak)id <BVTSubCategoryTableViewControllerDelegate> delegate;

@end
