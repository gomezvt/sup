//
//  SUPAboutTableViewController.m
//  SUP? NYC
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPAboutTableViewController.h"
#import "SUPHeaderTitleView.h"
#import "SUPAboutTableViewCell.h"
#import "SUPStyles.h"
#import <MessageUI/MessageUI.h>

@interface SUPAboutTableViewController () <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;

@end

static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kAboutTableViewNib = @"SUPAboutTableViewCell";

@implementation SUPAboutTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
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
        title = @"About SUP? NYC";
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
        rows = 4;
    }
    else
    {
        rows = 1;
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
        if (indexPath.row == 3)
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
            cell.textLabel.text = @"SUP? NYC was created by Greg, a native Vermonter and NYC food enthusiast, to serve as a quick reference for restaurants, shops, and attractions in and around the NYC area.";
        }
        else if (indexPath.row == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Privacy and Terms of Use";
        }
        else if (indexPath.row == 2)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Version 1.0.0";
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
            cell.textLabel.text = @"Your input is very important and can help make SUP? NYC better. Please take a moment to leave your feedback on the App Store.";
        }
    }
    
    return cell;
}

@end
