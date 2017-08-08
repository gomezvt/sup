//
//  SUPYelpContactTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/23/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPYelpPhoneTableViewCell.h"

@interface SUPYelpPhoneTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation SUPYelpPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    NSString *phone = [self formattedPhoneString];

    self.phoneNumberLabel.text = phone;
}

- (NSString *)formattedPhoneString
{
    NSString *phone = self.selectedBusiness.phone;
    if ([phone hasPrefix:@"+1"] && ![phone containsString:@"-"] && phone.length == 12)
    {
        NSMutableString *mutablePhone = [[NSMutableString alloc] initWithString:phone];
        [mutablePhone insertString:@" (" atIndex:2];
        [mutablePhone insertString:@") " atIndex:7];
        [mutablePhone insertString:@"-" atIndex:12];
        
        phone = mutablePhone;
    }
    
    return phone;
}

- (IBAction)didTapPhoneNumberButton:(id)sender
{
    NSString *phoneString = [NSString stringWithFormat:@"telprompt:%@", self.selectedBusiness.phone];
    NSURL *phoneURL = [NSURL URLWithString:phoneString];
    
    [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
