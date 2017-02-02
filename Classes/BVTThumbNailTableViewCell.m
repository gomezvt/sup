//
//  BVTThumbNailTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTThumbNailTableViewCell.h"

#import "YLPLocation.h"

@implementation BVTThumbNailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setBusiness:(YLPBusiness *)business
{
    _business = business;
    
    YLPLocation *location = business.location;
    self.titleLabel.text = business.name;
    
    if (location.address.count > 0)
    {
        self.addressLabel.text = location.address[0];
        self.addressLabel2.text = [NSString stringWithFormat:@"%@, %@ %@", location.city, location.stateCode, location.postalCode];
    }
    else
    {
        self.addressLabel.text = [NSString stringWithFormat:@"%@, %@ %@", location.city, location.stateCode, location.postalCode];
        [self.addressLabel2 removeFromSuperview];
    }
    
    __block NSData *imageData;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Your Background work
        imageData = [NSData dataWithContentsOfURL:business.imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update your UI
            UIImage *image = [UIImage imageWithData:imageData];
            self.thumbNailView.image = image;
        });
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
