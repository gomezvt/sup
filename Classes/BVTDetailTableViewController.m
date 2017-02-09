//
//  BVTDetailTableViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTDetailTableViewController.h"

#import "BVTHeaderTitleView.h"
#import "BVTYelpAddressTableViewCell.h"
#import "BVTYelpHoursTableViewCell.h"
#import "BVTYelpPhoneTableViewCell.h"
#import "BVTYelpRatingTableViewCell.h"
#import "BVTYelpMapTableViewCell.h"
#import "BVTSplitTableViewCell.h"
#import "BVTYelpCategoryTableViewCell.h"

#import "BVTStyles.h"

@interface BVTDetailTableViewController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kYelpAddressCellNib = @"BVTYelpAddressTableViewCell";
static NSString *const kYelpPhoneCellNib = @"BVTYelpPhoneTableViewCell";
static NSString *const kYelpRatingCellNib = @"BVTYelpRatingTableViewCell";
static NSString *const kYelpMapCellNib = @"BVTYelpMapTableViewCell";
static NSString *const kYelpCategoryCellNib = @"BVTYelpCategoryTableViewCell";
static NSString *const kYelpHoursCellNib = @"BVTYelpHoursTableViewCell";

static NSString *const kSplitCellNib = @"BVTSplitTableViewCell";
static NSString *const kYelpHoursCellIdentifier = @"YelpHoursCell";

static NSString *const kYelpMapCellIdentifier = @"YelpMapCell";
static NSString *const kYelpCategoryCellIdentifier = @"YelpCategoryCell";
static NSString *const kYelpAddressCellIdentifier = @"YelpAddressCell";
static NSString *const kYelpPhoneCellIdentifier = @"YelpContactCell";
static NSString *const kYelpRatingCellIdentifier = @"YelpRatingCell";
static NSString *const kSplitCellIdentifier = @"SplitCell";

@implementation BVTDetailTableViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.selectedBusiness.name;

    UINib *yelpMapCellNib = [UINib nibWithNibName:kYelpMapCellNib bundle:nil];
    [self.tableView registerNib:yelpMapCellNib forCellReuseIdentifier:kYelpMapCellIdentifier];
    
    UINib *yelpHoursCellNib = [UINib nibWithNibName:kYelpHoursCellNib bundle:nil];
    [self.tableView registerNib:yelpHoursCellNib forCellReuseIdentifier:kYelpHoursCellIdentifier];
    
    
    UINib *yelpAddressCellNib = [UINib nibWithNibName:kYelpAddressCellNib bundle:nil];
    [self.tableView registerNib:yelpAddressCellNib forCellReuseIdentifier:kYelpAddressCellIdentifier];
    
    UINib *yelpPhoneCellNib = [UINib nibWithNibName:kYelpPhoneCellNib bundle:nil];
    [self.tableView registerNib:yelpPhoneCellNib forCellReuseIdentifier:kYelpPhoneCellIdentifier];
    
    UINib *yelpRatingCellNib = [UINib nibWithNibName:kYelpRatingCellNib bundle:nil];
    [self.tableView registerNib:yelpRatingCellNib forCellReuseIdentifier:kYelpRatingCellIdentifier];
    
    UINib *yelpCategoryCellNib = [UINib nibWithNibName:kYelpCategoryCellNib bundle:nil];
    [self.tableView registerNib:yelpCategoryCellNib forCellReuseIdentifier:kYelpCategoryCellIdentifier];
    
    UINib *splitCellNib = [UINib nibWithNibName:kSplitCellNib bundle:nil];
    [self.tableView registerNib:splitCellNib forCellReuseIdentifier:kSplitCellIdentifier];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[BVTYelpAddressTableViewCell class]])
    {
        BVTYelpAddressTableViewCell *addressCell = (BVTYelpAddressTableViewCell *)cell;
        NSString *filteredString = [addressCell.mapsQueryString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSURL *url = [NSURL URLWithString:filteredString];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            NSLog(@"");
        }];
    }
    else if ([cell isKindOfClass:[BVTYelpPhoneTableViewCell class]])
    {
        BVTYelpPhoneTableViewCell *phoneCell = (BVTYelpPhoneTableViewCell *)cell;
        [phoneCell didTapPhoneNumberButton:indexPath];
    }
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.selectedBusiness.phone)
    {
        return 7;
    }
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    if (!self.selectedBusiness.phone)
    {
        if (indexPath.row == 0)
        {
            identifier = kYelpRatingCellIdentifier;
        }
        else if (indexPath.row == 1)
        {
            identifier = kYelpCategoryCellIdentifier;
        }
        else if (indexPath.row == 2)
        {
            identifier = kYelpHoursCellIdentifier;
        }
        else if (indexPath.row == 3)
        {
            identifier = kYelpAddressCellIdentifier;
        }
        else if (indexPath.row == 4)
        {
            identifier = kYelpMapCellIdentifier;
        }
        else if (indexPath.row == 5 || indexPath.row == 6)
        {
            identifier = kSplitCellIdentifier;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            identifier = kYelpRatingCellIdentifier;
        }
        else if (indexPath.row == 1)
        {
            identifier = kYelpCategoryCellIdentifier;
        }
        else if (indexPath.row == 2)
        {
            identifier = kYelpHoursCellIdentifier;
        }
        else if (indexPath.row == 3)
        {
            identifier = kYelpPhoneCellIdentifier;
        }
        else if (indexPath.row == 4)
        {
            identifier = kYelpAddressCellIdentifier;
        }
        else if (indexPath.row == 5)
        {
            identifier = kYelpMapCellIdentifier;
        }
        else if (indexPath.row == 6 || indexPath.row == 7)
        {
            identifier = kSplitCellIdentifier;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.selectedBusiness.phone)
    {
        if (indexPath.row == 0)
        {
            BVTYelpRatingTableViewCell *ratingCell = (BVTYelpRatingTableViewCell *)cell;
            ratingCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 1)
        {
            BVTYelpCategoryTableViewCell *defaultCell = (BVTYelpCategoryTableViewCell *)cell;
            defaultCell.selectedBusiness = self.selectedBusiness;
            
        }
        else if (indexPath.row == 2)
        {
            BVTYelpHoursTableViewCell *defaultCell = (BVTYelpHoursTableViewCell *)cell;
            defaultCell.isOpenLabel.text = self.selectedBusiness.isOpenNow ? @"Open" : @"Closed";
            defaultCell.isOpenLabel.textColor = [UIColor redColor];
            if ([defaultCell.isOpenLabel.text isEqualToString:@"Open"])
            {
                defaultCell.isOpenLabel.textColor = [UIColor greenColor];
            }
            
        }
        else if (indexPath.row == 3)
        {
            BVTYelpAddressTableViewCell *defaultCell = (BVTYelpAddressTableViewCell *)cell;
            defaultCell.selectedBusiness = self.selectedBusiness;
            
        }
        else if (indexPath.row == 4)
        {
            // Map
        }
        else if (indexPath.row == 5 || indexPath.row == 6)
        {
            BVTSplitTableViewCell *splitCell = (BVTSplitTableViewCell *)cell;
            if (indexPath.row == 5)
            {
                [splitCell.leftButton setTitle:@"Deals" forState:UIControlStateNormal];
                [splitCell.rightButton setTitle:@"Reviews" forState:UIControlStateNormal];
            }
            else
            {
                [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                [splitCell.rightButton setTitle:@"Photos" forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            BVTYelpRatingTableViewCell *ratingCell = (BVTYelpRatingTableViewCell *)cell;
            ratingCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 1)
        {
            BVTYelpCategoryTableViewCell *defaultCell = (BVTYelpCategoryTableViewCell *)cell;
            defaultCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 2)
        {
            BVTYelpHoursTableViewCell *defaultCell = (BVTYelpHoursTableViewCell *)cell;
            defaultCell.isOpenLabel.text = self.selectedBusiness.isOpenNow ? @"Open" : @"Closed";
            defaultCell.isOpenLabel.textColor = [UIColor redColor];
            if ([defaultCell.isOpenLabel.text isEqualToString:@"Open"])
            {
                defaultCell.isOpenLabel.textColor = [UIColor greenColor];
            }
        }
        else if (indexPath.row == 3)
        {
            BVTYelpPhoneTableViewCell *defaultCell = (BVTYelpPhoneTableViewCell *)cell;
            defaultCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 4)
        {
            BVTYelpAddressTableViewCell *defaultCell = (BVTYelpAddressTableViewCell *)cell;
            defaultCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 5)
        {
            // Map
        }
        else if (indexPath.row == 6 || indexPath.row == 7)
        {
            BVTSplitTableViewCell *splitCell = (BVTSplitTableViewCell *)cell;
            if (indexPath.row == 6)
            {
                [splitCell.leftButton setTitle:@"Deals" forState:UIControlStateNormal];
                [splitCell.rightButton setTitle:@"Reviews" forState:UIControlStateNormal];
            }
            else
            {
                [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                [splitCell.rightButton setTitle:@"Photos" forState:UIControlStateNormal];
            }
        }
    }
    
    return cell;
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
