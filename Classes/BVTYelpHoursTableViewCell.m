//
//  BVTYelpHoursTableViewCell.m
//  bvt
//
//  Created by Greg on 2/6/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTYelpHoursTableViewCell.h"

#import "BVTStyles.h"

@implementation BVTYelpHoursTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.openClosesLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    self.isOpenLabel.text = self.selectedBusiness.isOpenNow ? @"Open Now" : @"Closed Now";
    self.isOpenLabel.textColor = [UIColor redColor];
    if ([self.isOpenLabel.text isEqualToString:@"Open Now"])
    {
        self.isOpenLabel.textColor = [BVTStyles moneyGreen];
    }
    
    NSDateFormatter *dateFormatter;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EDT"]];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSString *dayName = [dateFormatter stringFromDate:[NSDate date]];
    NSNumber *dayNum = [NSNumber numberWithInteger:0];
    if ([dayName isEqualToString:@"Tuesday"])
    {
        dayNum = [NSNumber numberWithInteger:1];
    }
    else if ([dayName isEqualToString:@"Wednesday"])
    {
        dayNum = [NSNumber numberWithInteger:2];
    }
    else if ([dayName isEqualToString:@"Thursday"])
    {
        dayNum = [NSNumber numberWithInteger:3];
    }
    else if ([dayName isEqualToString:@"Friday"])
    {
        dayNum = [NSNumber numberWithInteger:4];
    }
    else if ([dayName isEqualToString:@"Saturday"])
    {
        dayNum = [NSNumber numberWithInteger:5];
    }
    else if ([dayName isEqualToString:@"Sunday"])
    {
        dayNum = [NSNumber numberWithInteger:6];
    }
    
    NSDictionary *todayDict = [[selectedBusiness.businessHours filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"day == %@", dayNum]] lastObject];

    if (todayDict)
    {
        NSString *timeStr;
        NSString *openCloseStr;
        if (self.selectedBusiness.isOpenNow)
        {
            openCloseStr = @"Closes at";
            timeStr = todayDict[@"end"];
        }
        else
        {
            openCloseStr = @"Opens at";
            timeStr = todayDict[@"start"];
        }
        
        NSDateFormatter *df;
        if (!df)
        {
            df = [[NSDateFormatter alloc] init];

        }
        
        df.dateFormat = @"HH:mm"; // The old format

        NSMutableString *mutableTime = [NSMutableString stringWithString:timeStr];
        [mutableTime insertString:@":" atIndex:2];

        NSString *time = mutableTime;
        NSDate *date = [df dateFromString:time];
        df.dateFormat = @"hh:mm a"; // The new format

        NSString *newStr = [df stringFromDate:date];
        self.openClosesLabel.text = [NSString stringWithFormat:@"%@ %@", openCloseStr, newStr];
    }
}

@end
