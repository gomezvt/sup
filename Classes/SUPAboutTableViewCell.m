//
//  SUPAboutTableViewCell.m
//  SUP
//
//  Created by Greg on 6/1/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "SUPAboutTableViewCell.h"

@implementation SUPAboutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)didTapYelpButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://yelp.com"]  options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (IBAction)didTapFBButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/Sup-City-iOS-App-1717395578567070/"]  options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
