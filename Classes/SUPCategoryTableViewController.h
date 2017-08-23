//
//  SUPCategoryTableViewController.h
//  Sup? City
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUPCategoryTableViewControllerDelegate <NSObject>

- (void)didTapBackWithDetails:(NSMutableDictionary *)details ;

@end

@interface SUPCategoryTableViewController : UIViewController

@property (nonatomic, copy) NSString *categoryTitle;
@property (nonatomic, strong) NSMutableDictionary *cachedDetails;

@property(nonatomic, weak)id <SUPCategoryTableViewControllerDelegate> delegate;

@end
