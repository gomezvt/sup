//
//  BVTSubCategoryTableViewController.h
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLPSearch;

@interface BVTSubCategoryTableViewController : UIViewController

@property (nonatomic, copy) NSString *subCategoryTitle;
@property (nonatomic, strong) YLPSearch *searchResults;

@end
