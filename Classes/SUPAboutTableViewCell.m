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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/SUP-NYC-iPhone-App-130089694188147/"]  options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
