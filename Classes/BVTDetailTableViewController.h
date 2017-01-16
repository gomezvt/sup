//
//  BVTDetailTableViewController.h
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLPBusiness;

@interface BVTDetailTableViewController : UIViewController

@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, strong) YLPBusiness *business;

@end
