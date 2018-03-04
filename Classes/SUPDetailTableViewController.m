//
//  SUPDetailTableViewController.m
//  Sup? City
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
#import "SUPFavoritesTableViewCell.h"
#import "AppDelegate.h"

#import "YLPLocation.h"
#import "YLPCoordinate.h"

#import "SUPStyles.h"

@interface SUPDetailTableViewController ()
<UIPopoverPresentationControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kYelpAddressCellNib = @"SUPYelpAddressTableViewCell";
static NSString *const kYelpPhoneCellNib = @"SUPYelpPhoneTableViewCell";
static NSString *const kYelpRatingCellNib = @"SUPYelpRatingTableViewCell";
static NSString *const kYelpMapCellNib = @"SUPYelpMapTableViewCell";
static NSString *const kYelpCategoryCellNib = @"SUPYelpCategoryTableViewCell";
static NSString *const kYelpHoursCellNib = @"SUPYelpHoursTableViewCell";
static NSString *const kFavoritesCellNib = @"SUPFavoritesTableViewCell";

static NSString *const kSplitCellNib = @"SUPSplitTableViewCell";
static NSString *const kYelpHoursCellIdentifier = @"YelpHoursCell";
static NSString *const kFavoritesCellIdentifier = @"FavoritesCell";

static NSString *const kYelpMapCellIdentifier = @"YelpMapCell";
static NSString *const kYelpCategoryCellIdentifier = @"YelpCategoryCell";
static NSString *const kYelpAddressCellIdentifier = @"YelpAddressCell";
static NSString *const kYelpPhoneCellIdentifier = @"YelpContactCell";
static NSString *const kYelpRatingCellIdentifier = @"YelpRatingCell";
static NSString *const kSplitCellIdentifier = @"SplitCell";

@implementation SUPDetailTableViewController


#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
    
    
    if (self.isViewingFavorites)
    {
                self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@"Sup? City"];
    }
    else if (kCity && ![kCity isEqualToString:@"(null), (null)"])

    {
        self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@"Sup? City:  %@", [kCity capitalizedString]];
    }
    
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    if (mainScreen.size.width == 1024.f)
    {
        [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
    }
    else if (mainScreen.size.width < 1024.f && mainScreen.size.width > 414.f)
    {
        [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
    }
    else
    {
        self.headerTitleView.leadingEdgeConstraint.constant = -15.f;
        
        if (mainScreen.size.width > 375.f)
        {
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
        }
        else if (mainScreen.size.width == 375.f)
        {
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:21]];
        }
        else
        {
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:18]];
        }
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.isViewingFavorites = NO;
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
//    self.headerTitleView.leadingEdgeConstraint.constant = 0.f;

    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)receivedData
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedData)
                                                 name:@"receivedBizPhotos"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedData)
                                                 name:@"receivedBizReviews"
                                               object:nil];
    
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
    
    UINib *favoritesCellNib = [UINib nibWithNibName:kFavoritesCellNib bundle:nil];
    [self.tableView registerNib:favoritesCellNib forCellReuseIdentifier:kFavoritesCellIdentifier];
    
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
    if (indexPath.section == 0)
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
}

#pragma mark - TableView Data Source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger indexPaths = 0;
    if (section == 0)
    {
        indexPaths = 1;
    }
    else if (section == 1)
    {
        indexPaths = 8;
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
    }

    return indexPaths;
}

- (IBAction)setFavoritesSwitchState:(id)sender
{
    UISwitch *sw = sender;
    NSData *unarchived = [[NSUserDefaults standardUserDefaults] objectForKey:@"faves"];
    NSMutableArray *faves = [NSKeyedUnarchiver unarchiveObjectWithData:unarchived];
    if (!faves)
    {
        faves = [NSMutableArray array];
    }
    
    if (sw.isOn)
    {
        [faves addObject:self.selectedBusiness];
    }
    else
    {
        YLPBusiness *lastAdded = [[faves filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", self.selectedBusiness.identifier]] lastObject];
        [faves removeObject:lastAdded];
    }
    
    NSData *archived = [NSKeyedArchiver archivedDataWithRootObject:faves];
    [[NSUserDefaults standardUserDefaults] setObject:archived forKey:@"faves"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)identifierForIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    NSString *phone = self.selectedBusiness.phone;
    NSArray *hoursArray = self.selectedBusiness.businessHours;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            identifier = kFavoritesCellIdentifier;
        }
    }
    else if (indexPath.section == 1)
    {
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
    NSString *reviewsTitle =  [NSString stringWithFormat: @"Reviews (%lu)", (unsigned long)self.selectedBusiness.reviews.count];
    
    if (indexPath.section == 0)
    {
        SUPFavoritesTableViewCell *favoritesCell = (SUPFavoritesTableViewCell *)cell;
        NSData *unarchived = [[NSUserDefaults standardUserDefaults] objectForKey:@"faves"];
        NSMutableArray *faves = [NSKeyedUnarchiver unarchiveObjectWithData:unarchived];
        YLPBusiness *existingFavorite = [[faves filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", self.selectedBusiness.identifier]] lastObject];
        if (existingFavorite)
        {
            [favoritesCell.swch setOn:YES];
        }
        else
        {
            [favoritesCell.swch setOn:NO];
        }
    }
    else if (indexPath.section == 1)
    {
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
    if (([button.titleLabel.text containsString:@"Reviews"] && self.selectedBusiness.reviews.count > 0) ||
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
