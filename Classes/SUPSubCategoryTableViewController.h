//
//  SUPSubCategoryTableViewController.h
//  Sup? City
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLPSearch;

@protocol SUPSubCategoryTableViewControllerDelegate <NSObject>

- (void)didTapBackWithDetails:(NSMutableDictionary *)details ;

@end

@interface SUPSubCategoryTableViewController : UIViewController 

@property (nonatomic, copy) NSString *subCategoryTitle;
@property (nonatomic, strong) NSArray *filteredResults;
@property (nonatomic, strong) NSMutableDictionary *cachedDetails;
@property(nonatomic, weak)id <SUPSubCategoryTableViewControllerDelegate> delegate;

@end
