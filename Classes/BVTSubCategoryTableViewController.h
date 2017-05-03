//
//  BVTSubCategoryTableViewController.h
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <CoreLocation/CoreLocation.h>

//@class CLLocationManager;

@class YLPSearch;

//@protocol BVTSubCategoryTableViewControllerDelegate <NSObject>
//
//- (void)didTapBackWithDetails:(NSMutableArray *)details ;
//
//@end

@interface BVTSubCategoryTableViewController : UIViewController 

@property (nonatomic, copy) NSString *subCategoryTitle;
@property (nonatomic, strong) NSArray *filteredResults;
//@property (nonatomic, strong) NSMutableArray *cachedDetails;
//@property(nonatomic, weak)id <BVTSubCategoryTableViewControllerDelegate> delegate;

@end
