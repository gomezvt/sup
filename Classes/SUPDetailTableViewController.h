//
//  SUPDetailTableViewController.h
//  Sup? City
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPHeaderTitleView.h"
@class YLPBusiness;

@interface SUPDetailTableViewController : UIViewController

@property (nonatomic, strong) YLPBusiness *selectedBusiness;
@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;
@property (nonatomic) BOOL isViewingFavorites;

@end
