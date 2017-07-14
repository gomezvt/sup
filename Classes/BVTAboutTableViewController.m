//
//  BVTAboutTableViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTAboutTableViewController.h"
#import "BVTHeaderTitleView.h"
#import "BVTAboutTableViewCell.h"
#import "BVTStyles.h"
#import <MessageUI/MessageUI.h>

@interface BVTAboutTableViewController () <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) BVTHeaderTitleView *headerTitleView;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kAboutTableViewNib = @"BVTAboutTableViewCell";

@implementation BVTAboutTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UINib *aboutCellNib = [UINib nibWithNibName:kAboutTableViewNib bundle:nil];
    [self.tableView registerNib:aboutCellNib forCellReuseIdentifier:@"AboutCell"];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = 44.f;

    self.tableView.tableFooterView = [UIView new];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (section == 0)
    {
        title = @"About Burlingtonian";
    }
    else
    {
        title = @"Your Feedback is Valuable";
    }
    
    return title;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (section == 0)
    {
        rows = 5;
    }
    else
    {
        rows = 3;
    }
    
    return rows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"ShowDisclaimer" sender:nil];
        }
        else if (indexPath.row == 2)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/burlingtonian-live-like-a-local-in-vt-ad-free/id1252833369?mt=8&ign-mpt=uo%3D4"]  options:@{} completionHandler:^(BOOL success) {
                
                NSLog(@"");
            }];
        }
    }
    else
    {
        if (indexPath.row == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/burlingtonian-live-like-a-local-in-vermont/id581817418?mt=8"]  options:@{} completionHandler:^(BOOL success) {
                
                NSLog(@"");
            }];
        }
        else if (indexPath.row == 2)
        {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:@"Burlingtonian Feedback"];
            [mail setMessageBody:@"" isHTML:NO];
            [mail setToRecipients:@[@"greg@theburlingtonian.com"]];
            
            [self presentViewController:mail animated:YES completion:nil];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 4)
        {
            identifier = @"AboutCell";
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Burlingtonian was created by Greg, a native Vermonter, to serve as a homegrown hub for tourism and travel information for people in and around the Burlington, VT area.";
        }
        else if (indexPath.row == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Privacy and Terms of Use";
        }
        else if (indexPath.row == 2)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Buy Burlingtonian Ad-Free!";
        }
        else if (indexPath.row == 3)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Version 2.0.2";
        }
        else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Your input is very important and can help make Burlingtonian better. Please take a moment to leave your feedback.";
        }
        else if (indexPath.row == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Write a review or rate us on the App Store";
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Send an email";
        }
    }
    
    return cell;
}

@end
