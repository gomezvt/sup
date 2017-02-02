//
//  BVTExploreViewController.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTExploreViewController.h"

#import "BVTCategoryTableViewController.h"
#import "BVTExploreCollectionViewCell.h"
#import "BVTHeaderTitleView.h"

@interface BVTExploreViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

static NSArray *cellTitles;
static NSArray *businessesToDisplay;
static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";
static NSString *const kCollectionViewCellNib = @"BVTExploreCollectionViewCell";
static NSString *const kDefaultCellIdentifier = @"Cell";
static NSString *const kShowCategorySegue = @"ShowCategory";
static NSString *const kShowSubCategorySegue = @"ShowSubCategory";

@implementation BVTExploreViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = 0.f;
    self.navigationItem.titleView = headerTitleView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:kCollectionViewCellNib bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:kDefaultCellIdentifier];
    
    cellTitles = @[ @"Arts and Museums", @"Coffee, Sweets, and Bakeries", @"Music", @"Hotels, Hostels, Bed & Breakfast", @"Entertainment and Recreation", @"Bars and Lounges", @"Restaurants", @"Shopping", @"Tours and Festivals", @"Travel" ];
}

#pragma mark - CollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return cellTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BVTExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = [cellTitles objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BVTExploreCollectionViewCell *cell = (BVTExploreCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *selectionTitle = cell.titleLabel.text;
    
    [self performSegueWithIdentifier:kShowCategorySegue sender:selectionTitle];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BVTCategoryTableViewController *vc = [segue destinationViewController];
    vc.categoryTitle = sender;
}

@end
