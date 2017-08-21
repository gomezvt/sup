//
//  SUPDetailTableViewController.m
//  SUP? NYC
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPDetailTableViewController.h"

#import "SUPHeaderTitleView.h"
#import "SUPYelpAddressTableViewCell.h"
#import "SUPYelpHoursTableViewCell.h"
#import "SUPYelpPhoneTableViewCell.h"
#import "SUPYelpRatingTableViewCell.h"
#import "SUPYelpMapTableViewCell.h"
#import "SUPSplitTableViewCell.h"
#import "SUPPresentationTableViewController.h"
#import "SUPYelpCategoryTableViewCell.h"
#import "YLPClient+Business.h"

#import "AppDelegate.h"

#import "YLPLocation.h"
#import "YLPCoordinate.h"

#import "SUPStyles.h"

@interface SUPDetailTableViewController ()
<UIPopoverPresentationControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;

@end

static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kYelpAddressCellNib = @"SUPYelpAddressTableViewCell";
static NSString *const kYelpPhoneCellNib = @"SUPYelpPhoneTableViewCell";
static NSString *const kYelpRatingCellNib = @"SUPYelpRatingTableViewCell";
static NSString *const kYelpMapCellNib = @"SUPYelpMapTableViewCell";
static NSString *const kYelpCategoryCellNib = @"SUPYelpCategoryTableViewCell";
static NSString *const kYelpHoursCellNib = @"SUPYelpHoursTableViewCell";

static NSString *const kSplitCellNib = @"SUPSplitTableViewCell";
static NSString *const kYelpHoursCellIdentifier = @"YelpHoursCell";

static NSString *const kYelpMapCellIdentifier = @"YelpMapCell";
static NSString *const kYelpCategoryCellIdentifier = @"YelpCategoryCell";
static NSString *const kYelpAddressCellIdentifier = @"YelpAddressCell";
static NSString *const kYelpPhoneCellIdentifier = @"YelpContactCell";
static NSString *const kYelpRatingCellIdentifier = @"YelpRatingCell";
static NSString *const kSplitCellIdentifier = @"SplitCell";

@implementation SUPDetailTableViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
        self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
    {
        self.headerTitleView.titleViewLabelConstraint.constant = 0.f;
    }
    
    self.tableView.tableFooterView = [UIView new];
    
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

- (void)displayYelpProfile
{
    [[UIApplication sharedApplication] openURL:self.selectedBusiness.URL options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (IBAction)didTapYelpButton:(id)sender
{
    [self displayYelpProfile];
}

- (void)displayYelpBizProfile
{
    [[UIApplication sharedApplication] openURL:self.selectedBusiness.URL options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (void)displayGoogleMaps
{
    YLPLocation *location = self.selectedBusiness.location;
    NSString *mapsQueryString;
    if (location.coordinate.latitude && location.coordinate.longitude)
    {
        mapsQueryString =  [NSString stringWithFormat:@"http://maps.apple.com/?q=%@&nearll=%f,%f", self.selectedBusiness.name, location.coordinate.latitude, location.coordinate.longitude];
    }
    else
    {
                mapsQueryString =  [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", self.selectedBusiness.name];
    }
    
    NSString *filteredString;

    if ([mapsQueryString containsString:@" "])
    {
        filteredString = [mapsQueryString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    }
    else
    {
        filteredString = mapsQueryString;
    }
    NSURL *url = [NSURL URLWithString:filteredString];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SUPYelpAddressTableViewCell class]])
    {
        [self displayGoogleMaps];
    }
    else if ([cell isKindOfClass:[SUPYelpPhoneTableViewCell class]])
    {
        SUPYelpPhoneTableViewCell *phoneCell = (SUPYelpPhoneTableViewCell *)cell;
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
    NSInteger indexPaths = 8;
    if (!self.selectedBusiness.phone)
    {
        indexPaths -= 1;
    }
    
    if (self.selectedBusiness.businessHours.count == 0)
    {
        indexPaths -= 1;
    }
    
    if (!self.selectedBusiness.location.coordinate.latitude && !self.selectedBusiness.location.coordinate.longitude)
    {
        indexPaths -= 1;
    }
    
    return indexPaths;
}


- (NSString *)identifierForIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    NSString *phone = self.selectedBusiness.phone;
    NSArray *hoursArray = self.selectedBusiness.businessHours;
    if (indexPath.row == 0)
    {
        identifier = kYelpRatingCellIdentifier;
    }
    else if (indexPath.row == 1)
    {
        identifier = kYelpCategoryCellIdentifier;
    }
    
    if (phone && hoursArray.count > 0)
    {
        if (indexPath.row == 2)
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
        
        if (self.selectedBusiness.location.coordinate)
        {
            if (indexPath.row == 5)
            {
                identifier = kYelpMapCellIdentifier;
            }
            else if (indexPath.row == 6 || indexPath.row == 7)
            {
                identifier = kSplitCellIdentifier;
            }
        }
        else
        {
            if (indexPath.row == 5 || indexPath.row == 6)
            {
                identifier = kSplitCellIdentifier;
            }
        }
    }
    else if (!phone && hoursArray.count == 0)
    {
        if (indexPath.row == 2)
        {
            identifier = kYelpAddressCellIdentifier;
        }
        
        if (self.selectedBusiness.location.coordinate)
        {
            if (indexPath.row == 3)
            {
                identifier = kYelpMapCellIdentifier;
            }
            else if (indexPath.row == 4 || indexPath.row == 5)
            {
                identifier = kSplitCellIdentifier;
            }
        }
        else
        {
            if (indexPath.row == 3 || indexPath.row == 4)
            {
                identifier = kSplitCellIdentifier;
            }
        }
    }
    else if (!phone && hoursArray.count > 0)
    {
        if (indexPath.row == 2)
        {
            identifier = kYelpHoursCellIdentifier;
        }
        else if (indexPath.row == 3)
        {
            identifier = kYelpAddressCellIdentifier;
        }
        
        if (self.selectedBusiness.location.coordinate)
        {
            if (indexPath.row == 4)
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
            if (indexPath.row == 4 || indexPath.row == 5)
            {
                identifier = kSplitCellIdentifier;
            }
        }
        
    }
    else if (phone && hoursArray.count == 0)
    {
        if (indexPath.row == 2)
        {
            identifier = kYelpPhoneCellIdentifier;
        }
        else if (indexPath.row == 3)
        {
            identifier = kYelpAddressCellIdentifier;
        }
        
        if (self.selectedBusiness.location.coordinate)
        {
            if (indexPath.row == 4)
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
            if (indexPath.row == 4 || indexPath.row == 5)
            {
                identifier = kSplitCellIdentifier;
            }
        }
    }
    
    return identifier;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self identifierForIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *phone = self.selectedBusiness.phone;
    NSArray *hoursArray = self.selectedBusiness.businessHours;
    NSString *photosTitle = [NSString stringWithFormat: @"Photos (%lu)", (unsigned long)self.selectedBusiness.photos.count];
    NSString *reviewsTitle;
    if (self.selectedBusiness.reviewCount > 3)
    {
        reviewsTitle = @"Reviews (3)";
    }
    else
    {
        reviewsTitle = [NSString stringWithFormat: @"Reviews (%lu)", (unsigned long)self.selectedBusiness.reviewCount];
    }
    
    if (indexPath.row == 0)
    {
        SUPYelpRatingTableViewCell *ratingCell = (SUPYelpRatingTableViewCell *)cell;
        ratingCell.selectedBusiness = self.selectedBusiness;
    }
    else if (indexPath.row == 1)
    {
        SUPYelpCategoryTableViewCell *categoryCell = (SUPYelpCategoryTableViewCell *)cell;
        categoryCell.selectedBusiness = self.selectedBusiness;
    }
    
    if (phone && hoursArray.count > 0)
    {
        if (indexPath.row == 2)
        {
            SUPYelpHoursTableViewCell *hoursCell = (SUPYelpHoursTableViewCell *)cell;
            hoursCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 3)
        {
            SUPYelpPhoneTableViewCell *phoneCell = (SUPYelpPhoneTableViewCell *)cell;
            phoneCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 4)
        {
            SUPYelpAddressTableViewCell *addressCell = (SUPYelpAddressTableViewCell *)cell;
            addressCell.selectedBusiness = self.selectedBusiness;
        }
        
        if (self.selectedBusiness.location.coordinate.latitude && self.selectedBusiness.location.coordinate.longitude)
        {
            if (indexPath.row == 5)
            {
                SUPYelpMapTableViewCell *mapCell = (SUPYelpMapTableViewCell *)cell;
                mapCell.selectedBusiness = self.selectedBusiness;
            }
            else if (indexPath.row == 6 || indexPath.row == 7)
            {
                SUPSplitTableViewCell *splitCell = (SUPSplitTableViewCell *)cell;
                splitCell.selectedBusiness = self.selectedBusiness;
                if (indexPath.row == 6)
                {
                    [splitCell.leftButton setTitle:photosTitle forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:reviewsTitle forState:UIControlStateNormal];
                }
                else
                {
                    [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:@"Yelp Profile" forState:UIControlStateNormal];
                }
            }

        }
        else
        {
            if (indexPath.row == 5 || indexPath.row == 6)
            {
                SUPSplitTableViewCell *splitCell = (SUPSplitTableViewCell *)cell;
                splitCell.selectedBusiness = self.selectedBusiness;
                if (indexPath.row == 5)
                {
                    [splitCell.leftButton setTitle:photosTitle forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:reviewsTitle forState:UIControlStateNormal];
                }
                else
                {
                    [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:@"Yelp Profile" forState:UIControlStateNormal];
                }
            }
            
        }
    }
    else if (!phone && hoursArray.count == 0)
    {
        if (indexPath.row == 2)
        {
            SUPYelpAddressTableViewCell *addressCell = (SUPYelpAddressTableViewCell *)cell;
            addressCell.selectedBusiness = self.selectedBusiness;
        }
        
        if (self.selectedBusiness.location.coordinate.latitude && self.selectedBusiness.location.coordinate.longitude)
        {
            if (indexPath.row == 3)
            {
                SUPYelpMapTableViewCell *mapCell = (SUPYelpMapTableViewCell *)cell;
                mapCell.selectedBusiness = self.selectedBusiness;
            }
            else if (indexPath.row == 4 || indexPath.row == 5)
            {
                SUPSplitTableViewCell *splitCell = (SUPSplitTableViewCell *)cell;
                splitCell.selectedBusiness = self.selectedBusiness;
                if (indexPath.row == 4)
                {
                    [splitCell.leftButton setTitle:photosTitle forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:reviewsTitle forState:UIControlStateNormal];
                }
                else
                {
                    [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:@"Yelp Profile" forState:UIControlStateNormal];
                }
            }
        }
        else
        {
            if (indexPath.row == 3 || indexPath.row == 4)
            {
                SUPSplitTableViewCell *splitCell = (SUPSplitTableViewCell *)cell;
                splitCell.selectedBusiness = self.selectedBusiness;
                if (indexPath.row == 3)
                {
                    [splitCell.leftButton setTitle:photosTitle forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:reviewsTitle forState:UIControlStateNormal];
                }
                else
                {
                    [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:@"Yelp Profile" forState:UIControlStateNormal];
                }
            }
        }
    }
    else if (!phone && hoursArray.count > 0)
    {
        if (indexPath.row == 2)
        {
            SUPYelpHoursTableViewCell *hoursCell = (SUPYelpHoursTableViewCell *)cell;
            hoursCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 3)
        {
            SUPYelpAddressTableViewCell *addressCell = (SUPYelpAddressTableViewCell *)cell;
            addressCell.selectedBusiness = self.selectedBusiness;
        }
        
        if (self.selectedBusiness.location.coordinate.latitude && self.selectedBusiness.location.coordinate.longitude)
        {
            if (indexPath.row == 4)
            {
                SUPYelpMapTableViewCell *mapCell = (SUPYelpMapTableViewCell *)cell;
                mapCell.selectedBusiness = self.selectedBusiness;
            }
            else if (indexPath.row == 5 || indexPath.row == 6)
            {
                SUPSplitTableViewCell *splitCell = (SUPSplitTableViewCell *)cell;
                splitCell.selectedBusiness = self.selectedBusiness;
                if (indexPath.row == 5)
                {
                    [splitCell.leftButton setTitle:photosTitle forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:reviewsTitle forState:UIControlStateNormal];
                }
                else
                {
                    [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:@"Yelp Profile" forState:UIControlStateNormal];
                }
            }
        }
        else
        {
            if (indexPath.row == 4 || indexPath.row == 5)
            {
                SUPSplitTableViewCell *splitCell = (SUPSplitTableViewCell *)cell;
                splitCell.selectedBusiness = self.selectedBusiness;
                if (indexPath.row == 4)
                {
                    [splitCell.leftButton setTitle:photosTitle forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:reviewsTitle forState:UIControlStateNormal];
                }
                else
                {
                    [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:@"Yelp Profile" forState:UIControlStateNormal];
                }
            }
        }
    }
    else if (phone && hoursArray.count == 0)
    {
        if (indexPath.row == 2)
        {
            SUPYelpPhoneTableViewCell *phoneCell = (SUPYelpPhoneTableViewCell *)cell;
            phoneCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 3)
        {
            SUPYelpAddressTableViewCell *addressCell = (SUPYelpAddressTableViewCell *)cell;
            addressCell.selectedBusiness = self.selectedBusiness;
        }
        
        if (self.selectedBusiness.location.coordinate.latitude && self.selectedBusiness.location.coordinate.longitude)
        {
            if (indexPath.row == 4)
            {
                SUPYelpMapTableViewCell *mapCell = (SUPYelpMapTableViewCell *)cell;
                mapCell.selectedBusiness = self.selectedBusiness;
            }
            else if (indexPath.row == 5 || indexPath.row == 6)
            {
                SUPSplitTableViewCell *splitCell = (SUPSplitTableViewCell *)cell;
                splitCell.selectedBusiness = self.selectedBusiness;
                if (indexPath.row == 5)
                {
                    [splitCell.leftButton setTitle:photosTitle forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:reviewsTitle forState:UIControlStateNormal];
                }
                else
                {
                    [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:@"Yelp Profile" forState:UIControlStateNormal];
                }
            }
        }
        else
        {
            if (indexPath.row == 4 || indexPath.row == 5)
            {
                SUPSplitTableViewCell *splitCell = (SUPSplitTableViewCell *)cell;
                splitCell.selectedBusiness = self.selectedBusiness;
                if (indexPath.row == 4)
                {
                    [splitCell.leftButton setTitle:photosTitle forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:reviewsTitle forState:UIControlStateNormal];
                }
                else
                {
                    [splitCell.leftButton setTitle:@"Map" forState:UIControlStateNormal];
                    [splitCell.rightButton setTitle:@"Yelp Profile" forState:UIControlStateNormal];
                }
            }
        }
    }
    
    return cell;
}

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController;
{
    //
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller
{
    return UIModalPresentationNone;
}

#pragma mark - IBActions

- (IBAction)popoverWithoutBarButton:(id)sender
{
    UIButton *button = sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (([button.titleLabel.text containsString:@"Reviews"] && self.selectedBusiness.reviewCount > 0) ||
        ([button.titleLabel.text containsString:@"Photos"] && self.selectedBusiness.photos.count > 0))
    {
        SUPPresentationTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PresTVC"];

        controller.business = self.selectedBusiness;
        controller.title = button.titleLabel.text;
        
        // configure the Popover presentation controller
        controller.popoverPresentationController.delegate = self;
        controller.modalPresentationStyle = UIModalPresentationPopover;
        controller.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        controller.popoverPresentationController.sourceView = button;
//        controller.popoverPresentationController.sourceRect = CGRectMake(0, 0, 320, 266);
        controller.presentationController.delegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)didTapSplitViewCellButton:(id)sender
{
    UIButton *button = sender;
    if ([button.titleLabel.text isEqualToString:@"Map"])
    {
        [self displayGoogleMaps];
    }
    else if ([button.titleLabel.text isEqualToString:@"Yelp Profile"])
    {
        [self displayYelpProfile];
    }
}

- (IBAction)didTapBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
