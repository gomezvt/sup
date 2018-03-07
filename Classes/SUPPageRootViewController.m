//
//  RootViewController.m
//  Sup? City
//
//  Created by Greg on 12/23/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPPageRootViewController.h"

#import "SUPExploreViewController.h"
#import "SUPPageContentViewController.h"

@interface SUPPageRootViewController ()

@property (nonatomic, weak) IBOutlet UIView *gotItBar;
@property (nonatomic, weak) IBOutlet UIImageView *icon;

@end

@implementation SUPPageRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, -50.f, self.view.frame.size.width, self.view.frame.size.height + 25.f);
    
    BOOL tutorialIsComplete = [[NSUserDefaults standardUserDefaults] boolForKey:@"SUPTutorialComplete"];
    if (tutorialIsComplete)
    {
        self.gotItBar.hidden = YES;
        self.icon.hidden = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"ShowTabBarController" sender:nil];
        });
    }
    else
    {
        // Create the data model
        self.pageTitles = @[@"1", @"2", @"3", @"4"];
//        self.images = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
        
        CGRect mainScreen = [[UIScreen mainScreen] bounds];
        if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
             self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
        {
            if (mainScreen.size.width == 1024.f)
            {
                // iPad 12.9
                self.images = @[@"iPad-12.9-Explore", @"iPad-12.9-Search", @"iPad-12.9-Surprise", @"iPad-12.9-Favorites"];
            }
            else if (mainScreen.size.width == 834.f)
            {
                // iPad 10.5
                self.images = @[@"iPad-10.5-Explore", @"iPad-10.5-Search", @"iPad-10.5-Surprise", @"iPad-10.5-Favorites"];
            }
            else if (mainScreen.size.width == 768.f)
            {
                // iPad 9.7
                self.images = @[@"iPad-9.7-Explore", @"iPad-9.7-Search", @"iPad-9.7-Surprise", @"iPad-9.7-Favorites"];
            }
        }
        else
        {
            if (mainScreen.size.width > 375.f)
            {
                // iPhone Plus 6 + 7
                self.images = @[@"iPhone-5.5-Explore", @"iPhone-5.5-Search", @"iPhone-5.5-Surprise", @"iPhone-5.5-Favorites"];
            }
            else if (mainScreen.size.width == 375.f)
            {
                if (mainScreen.size.height == 812.f)
                {
                    // iPhone X
                    self.images = @[@"iPhone-5.8-Explore", @"iPhone-5.8-Search", @"iPhone-5.8-Surprise", @"iPhone-5.8-Favorites"];
                    self.pageViewController.view.frame = CGRectMake(0, -80.f, self.view.frame.size.width, self.view.frame.size.height + 25.f);

                }
                else
                {
                    // iPhone 6 + 7
                    self.images = @[@"iPhone-4.7-Explore", @"iPhone-4.7-Search", @"iPhone-4.7-Surprise", @"iPhone-4.7-Favorites"];
                }
            }
            else if (mainScreen.size.width == 320.f)
            {
                // iPhone 5, iPhone 5S, iPhone SE
                self.images = @[@"iPhone-4-Explore", @"iPhone-4-Search", @"iPhone-4-Surprise", @"iPhone-4-Favorites"];
            }
        }

        
        
        self.pageViewController.dataSource = self;
        
        SUPPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    }
}

- (IBAction)startWalkthrough:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SUPTutorialComplete"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self performSegueWithIdentifier:@"ShowTabBarController" sender:nil];
}

- (SUPPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    SUPPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.images[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SUPPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SUPPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


@end
