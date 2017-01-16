//
//  SecondViewController.m
//  bvt
//
//  Created by Greg on 1/15/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "SecondViewController.h"

#import "AppDelegate.h"
#import <YelpAPI/YLPClient+Search.h>
#import <YelpAPI/YLPSortType.h>
#import <YelpAPI/YLPSearch.h>
#import <YelpAPI/YLPBusiness.h>


@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[AppDelegate sharedClient] searchWithLocation:@"San Francisco, CA" term:nil limit:5 offset:0 sort:YLPSortTypeDistance completionHandler:^
     (YLPSearch *search, NSError* error) {
//         self.search = search;
         dispatch_async(dispatch_get_main_queue(), ^{
//             [self.tableView reloadData];
         });
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
