//
//  BVTSurpriseShoppingCartTableViewController.h
//  bvt
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BVTSurpriseShoppingCartTableViewControllerDelegate <NSObject>

- (void)didTapBackWithSubCategories:(NSMutableArray *)array withCategories:(NSMutableDictionary *)categories;

@end

@interface BVTSurpriseShoppingCartTableViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *selectedCategories;
@property (nonatomic, strong) NSMutableArray *subCats;
@property(nonatomic, weak)id <BVTSurpriseShoppingCartTableViewControllerDelegate> delegate;

@end
