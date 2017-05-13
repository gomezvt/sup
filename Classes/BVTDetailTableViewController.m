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
#import "BVTPresentationTableViewController.h"
#import "BVTYelpCategoryTableViewCell.h"
#import "YLPClient+Business.h"

#import "AppDelegate.h"

#import "YLPLocation.h"
#import "YLPCoordinate.h"

#import "BVTStyles.h"

@interface BVTDetailTableViewController ()
<UIPopoverPresentationControllerDelegate>

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

//    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *mapsQueryString;
    
//    if (![self.selectedBusiness.location.address firstObject])
//    {
//        mapsQueryString =  [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", self.selectedBusiness.name];
//    }
//    else{
            mapsQueryString =  [NSString stringWithFormat:@"http://maps.apple.com/?q=%@&nearll=%f,%f", self.selectedBusiness.name, location.coordinate.latitude, location.coordinate.longitude];
//    }


    
    
    
    
    

//    {
//            mapsQueryString =  [NSString stringWithFormat:@"http://maps.apple.com/?q=%@,qs11=%f,%f,near=%f,%f&z=20&t=s", self.selectedBusiness.name, location.coordinate.latitude, location.coordinate.longitude, location.coordinate.latitude, location.coordinate.longitude];
//    }


//    if (appDel.userLocation)
//    {
//        CLLocation *userLoc = appDel.userLocation;
//        CLLocationCoordinate2D coordinate = [userLoc coordinate];
//        
//        CGFloat latitude = coordinate.latitude;
//        CGFloat longitude = coordinate.longitude;
//        mapsQueryString = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@&near=%f,%f", self.selectedBusiness.name, latitude,longitude];
//
//    }
    
    NSString *filteredString = [mapsQueryString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURL *url = [NSURL URLWithString:filteredString];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[BVTYelpAddressTableViewCell class]])
    {
        [self displayGoogleMaps];
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
    NSInteger indexPaths = 8;
    if (!self.selectedBusiness.phone)
    {
        indexPaths -= 1;
    }
    
    if (self.selectedBusiness.businessHours.count == 0)
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
        else if (indexPath.row == 5)
        {
            identifier = kYelpMapCellIdentifier;
        }
        else if (indexPath.row == 6 || indexPath.row == 7)
        {
            identifier = kSplitCellIdentifier;
        }
    }
    else if (!phone && hoursArray.count == 0)
    {
        if (indexPath.row == 2)
        {
            identifier = kYelpAddressCellIdentifier;
        }
        else if (indexPath.row == 3)
        {
            identifier = kYelpMapCellIdentifier;
        }
        else if (indexPath.row == 4 || indexPath.row == 5)
        {
            identifier = kSplitCellIdentifier;
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
        else if (indexPath.row == 4)
        {
            identifier = kYelpMapCellIdentifier;
        }
        else if (indexPath.row == 5 || indexPath.row == 6)
        {
            identifier = kSplitCellIdentifier;
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
        else if (indexPath.row == 4)
        {
            identifier = kYelpMapCellIdentifier;
        }
        else if (indexPath.row == 5 || indexPath.row == 6)
        {
            identifier = kSplitCellIdentifier;
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
        BVTYelpRatingTableViewCell *ratingCell = (BVTYelpRatingTableViewCell *)cell;
        ratingCell.selectedBusiness = self.selectedBusiness;
    }
    else if (indexPath.row == 1)
    {
        BVTYelpCategoryTableViewCell *categoryCell = (BVTYelpCategoryTableViewCell *)cell;
        categoryCell.selectedBusiness = self.selectedBusiness;
    }
    
    if (phone && hoursArray.count > 0)
    {
        if (indexPath.row == 2)
        {
            BVTYelpHoursTableViewCell *hoursCell = (BVTYelpHoursTableViewCell *)cell;
            hoursCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 3)
        {
            BVTYelpPhoneTableViewCell *phoneCell = (BVTYelpPhoneTableViewCell *)cell;
            phoneCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 4)
        {
            BVTYelpAddressTableViewCell *addressCell = (BVTYelpAddressTableViewCell *)cell;
            addressCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 5)
        {
            BVTYelpMapTableViewCell *mapCell = (BVTYelpMapTableViewCell *)cell;
            mapCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 6 || indexPath.row == 7)
        {
            BVTSplitTableViewCell *splitCell = (BVTSplitTableViewCell *)cell;
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
    else if (!phone && hoursArray.count == 0)
    {
        if (indexPath.row == 2)
        {
            BVTYelpAddressTableViewCell *addressCell = (BVTYelpAddressTableViewCell *)cell;
            addressCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 3)
        {
            BVTYelpMapTableViewCell *mapCell = (BVTYelpMapTableViewCell *)cell;
            mapCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 4 || indexPath.row == 5)
        {
            BVTSplitTableViewCell *splitCell = (BVTSplitTableViewCell *)cell;
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
    else if (!phone && hoursArray.count > 0)
    {
        if (indexPath.row == 2)
        {
            BVTYelpHoursTableViewCell *hoursCell = (BVTYelpHoursTableViewCell *)cell;
            hoursCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 3)
        {
            BVTYelpAddressTableViewCell *addressCell = (BVTYelpAddressTableViewCell *)cell;
            addressCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 4)
        {
            BVTYelpMapTableViewCell *mapCell = (BVTYelpMapTableViewCell *)cell;
            mapCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 5 || indexPath.row == 6)
        {
            BVTSplitTableViewCell *splitCell = (BVTSplitTableViewCell *)cell;
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
    else if (phone && hoursArray.count == 0)
    {
        if (indexPath.row == 2)
        {
            BVTYelpPhoneTableViewCell *phoneCell = (BVTYelpPhoneTableViewCell *)cell;
            phoneCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 3)
        {
            BVTYelpAddressTableViewCell *addressCell = (BVTYelpAddressTableViewCell *)cell;
            addressCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 4)
        {
            BVTYelpMapTableViewCell *mapCell = (BVTYelpMapTableViewCell *)cell;
            mapCell.selectedBusiness = self.selectedBusiness;
        }
        else if (indexPath.row == 5 || indexPath.row == 6)
        {
            BVTSplitTableViewCell *splitCell = (BVTSplitTableViewCell *)cell;
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
        BVTPresentationTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PresTVC"];
        controller.business = self.selectedBusiness;
        controller.title = button.titleLabel.text;
        
        // configure the Popover presentation controller
        controller.popoverPresentationController.delegate = self;
        controller.modalPresentationStyle = UIModalPresentationPopover;
        controller.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        //        controller.preferredContentSize = CGSizeMake(320, self.tableView.contentSize.height);
        controller.popoverPresentationController.sourceView = button;
        controller.popoverPresentationController.sourceRect = CGRectMake(0.f,0.f,160.f,300.f);
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
