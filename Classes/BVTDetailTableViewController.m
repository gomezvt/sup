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
#import "BVTYelpContactTableViewCell.h"
#import "BVTYelpRatingTableViewCell.h"
#import "BVTYelpMapTableViewCell.h"
#import "BVTSplitTableViewCell.h"
#import "BVTStyles.h"
#import "YLPClient+Business.h"
#import "YLPBusiness.h"

@interface BVTDetailTableViewController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BVTHeaderTitleView *headerTitleView;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kYelpAddressCellNib = @"BVTYelpAddressTableViewCell";
static NSString *const kYelpContactCellNib = @"BVTYelpContactTableViewCell";
static NSString *const kYelpRatingCellNib = @"BVTYelpRatingTableViewCell";
static NSString *const kYelpMapCellNib = @"BVTYelpMapTableViewCell";
static NSString *const kSplitCellNib = @"BVTSplitTableViewCell";

static NSString *const kYelpMapCellIdentifier = @"YelpMapCell";
static NSString *const kYelpAddressCellIdentifier = @"YelpAddressCell";
static NSString *const kYelpContactCellIdentifier = @"YelpContactCell";
static NSString *const kYelpRatingCellIdentifier = @"YelpRatingCell";
static NSString *const kSplitCellIdentifier = @"SplitCell";

@implementation BVTDetailTableViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.navigationItem.titleView = self.headerTitleView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.detailTitle;

    UINib *yelpMapCellNib = [UINib nibWithNibName:kYelpMapCellNib bundle:nil];
    [self.tableView registerNib:yelpMapCellNib forCellReuseIdentifier:kYelpMapCellIdentifier];
    
    UINib *yelpAddressCellNib = [UINib nibWithNibName:kYelpAddressCellNib bundle:nil];
    [self.tableView registerNib:yelpAddressCellNib forCellReuseIdentifier:kYelpAddressCellIdentifier];
    
    UINib *yelpContactCellNib = [UINib nibWithNibName:kYelpContactCellNib bundle:nil];
    [self.tableView registerNib:yelpContactCellNib forCellReuseIdentifier:kYelpContactCellIdentifier];
    
    UINib *yelpRatingCellNib = [UINib nibWithNibName:kYelpRatingCellNib bundle:nil];
    [self.tableView registerNib:yelpRatingCellNib forCellReuseIdentifier:kYelpRatingCellIdentifier];
    
    UINib *splitCellNib = [UINib nibWithNibName:kSplitCellNib bundle:nil];
    [self.tableView registerNib:splitCellNib forCellReuseIdentifier:kSplitCellIdentifier];
        
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.headerTitleView.centerXConstraint.constant = [self _adjustTitleViewCenter];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    if (indexPath.row == 0)
    {
        identifier = kYelpRatingCellIdentifier;
    }
    else if (indexPath.row == 1)
    {
        identifier = kYelpContactCellIdentifier;
    }
    else if (indexPath.row == 2)
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0)
    {
        BVTYelpRatingTableViewCell *ratingCell = (BVTYelpRatingTableViewCell *)cell;
        ratingCell.reviewsCountLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.reviewCount];
        
//        NSString *catString;
        // TODO: make sure there arent more than three categories per place or fix code accordingly for more
        
//        NSArray *categories = self.business.categories;
        
//        if (self.business.categories.count == 1)
//        {
//            catString = categories[0];
//        }
//        else if (self.business.categories.count == 2)
//        {
//            catString = [NSString stringWithFormat:@"%@, %@", categories[0], categories[1]];
//        }
//        else if (self.business.categories.count == 3)
//        {
//            catString = [NSString stringWithFormat:@"%@, %@, %@", categories[0], categories[1], categories[2]];
//        }
//
//        ratingCell.yelpCategoryLabel.text = catString;
        
        NSString *ratingString;
        if (self.business.rating == 0)
        {
            ratingString = star_zero;
        }
        else if (self.business.rating == 1)
        {
            ratingString = star_one;
        }
        else if (self.business.rating == 1.5)
        {
            ratingString = star_one_half;
        }
        else if (self.business.rating == 2)
        {
            ratingString = star_two;
        }
        else if (self.business.rating == 2.5)
        {
            ratingString = star_two_half;
        }
        else if (self.business.rating == 3)
        {
            ratingString = star_three;
        }
        else if (self.business.rating == 3.5)
        {
            ratingString = star_three_half;
        }
        else if (self.business.rating == 4)
        {
            ratingString = star_four;
        }
        else if (self.business.rating == 4.5)
        {
            ratingString = star_four_half;
        }
        else if (self.business.rating == 5)
        {
            ratingString = star_five;
        }
        
        [ratingCell.ratingStarsView setImage:[UIImage imageNamed:ratingString]];
    }
    else if (indexPath.row == 1)
    {
                BVTYelpContactTableViewCell *defaultCell = (BVTYelpContactTableViewCell *)cell;
        defaultCell.phoneNumberLabel.text = self.business.phone;
    }
    else if (indexPath.row == 2)
    {
//                BVTYelpAddressTableViewCell *defaultCell = (BVTYelpAddressTableViewCell *)cell;
//        NSDictionary *address = self.business[@"location"];
//
//        defaultCell.addressLabel.text = address[@"display_address"][0];
//        defaultCell.addressLabel2.text = address[@"display_address"][1];

    }
    else if (indexPath.row == 3)
    {
//        BVTYelpContactTableViewCell *defaultCell = (BVTYelpContactTableViewCell *)cell;
    }
    else if (indexPath.row == 4 || indexPath.row == 5)
    {
        BVTSplitTableViewCell *splitCell = (BVTSplitTableViewCell *)cell;
        if (indexPath.row == 4)
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

    return cell;
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (CGFloat)_adjustTitleViewCenter
{
    BOOL deviceIsPortrait = [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait;
    
    return deviceIsPortrait ? -20.f : 0.f;
}

#pragma mark - Device Orientation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        self.headerTitleView.centerXConstraint.constant = -20.f;
        [self.tableView reloadData];
    } completion:^(id  _Nonnull context) {
    }];
}

@end
