//
//  PageContentViewController.h
//  burlingtonian
//
//  Created by Greg on 12/23/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUPPageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property NSString *imageFile;
@property NSUInteger pageIndex;
@property NSString *titleText;

@end
