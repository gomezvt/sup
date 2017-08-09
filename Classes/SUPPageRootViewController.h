//
//  RootViewController.h
//  SUP? NYC
//
//  Created by Greg on 12/23/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPPageRootViewController.h"

@interface SUPPageRootViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;

@property (nonatomic, weak) IBOutlet UIButton *start;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *images;

@end
