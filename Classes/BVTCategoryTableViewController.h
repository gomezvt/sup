//
//  BVTCategoryTableViewController.h
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BVTCategoryTableViewControllerDelegate <NSObject>

- (void)didTapBackWithDetails:(NSMutableArray *)details ;

@end

@interface BVTCategoryTableViewController : UIViewController

@property (nonatomic, copy) NSString *categoryTitle;
@property (nonatomic, strong) NSMutableArray *cachedDetails;

@property(nonatomic, weak)id <BVTCategoryTableViewControllerDelegate> delegate;

@end
