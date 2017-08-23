//
//  SUPExploreViewController.m
//  Sup? City
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPExploreViewController.h"

#import "SUPCategoryTableViewController.h"
#import "SUPExploreCollectionViewCell.h"
#import "SUPHeaderTitleView.h"
#import "SUPStyles.h"
#import "AppDelegate.h"

@interface SUPExploreViewController () <SUPCategoryTableViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL isLargePhone;

@end

static NSArray *businessesToDisplay;
static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kCollectionViewCellNib = @"SUPExploreCollectionViewCell";
static NSString *const kShowCategorySegue = @"ShowCategory";
static NSString *const kShowSubCategorySegue = @"ShowSubCategory";

@implementation SUPExploreViewController

- (void)didTapBackWithDetails:(NSMutableDictionary *)details
{
    self.cachedDetails = details;
}

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    SUPHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = 20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:kCollectionViewCellNib bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    if ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
         self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) && mainScreen.size.width == 1024.f)
    {
        self.isLargePhone = YES;

        [self.collectionView setContentInset:UIEdgeInsetsMake(120.f,10.f,0.f,10.f)];
    }
    else
    {
        if (mainScreen.size.width > 375.f)
        {
            self.isLargePhone = YES;
            
            [self.collectionView setContentInset:UIEdgeInsetsMake(20.f,10.f,0.f,10.f)];
        }
        else if (mainScreen.size.width == 375.f)
        {
            self.isLargePhone = NO;
            
            [self.collectionView setContentInset:UIEdgeInsetsMake(30.f, 5.f, 0.f, 5.f)];
        }
        else
        {
            self.isLargePhone = NO;
            
            [self.collectionView setContentInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
        }
    }
    

}

#pragma mark - CollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kSUPCategories.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    CGFloat spacing;
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    if ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
         self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) && mainScreen.size.width == 1024.f)
    {
        spacing = 100.f;
    }
    else
    {
        spacing = 20.f;
    }
    
    return spacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
        self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
    {
        CGRect mainScreen = [[UIScreen mainScreen] bounds];
        if (mainScreen.size.width == 1024.f)
        {
            return CGSizeMake(200.f, 150.f);
        }
        else
        {
            return CGSizeMake(150.f, 150.f);
        }
    }
    else
    {
        if (self.isLargePhone)
        {
            size = CGSizeMake(100, 150);
        }
        else
        {
            size = CGSizeMake(80, 120);
        }
    }

    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SUPExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.titleLabel.text = [kSUPCategories objectAtIndex:indexPath.row];
    

    if (self.isLargePhone)
    {
        cell.imageWidth.constant = 84.f;
        cell.imageHeight.constant = 84.f;
        cell.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [cell.titleLabel sizeToFit];
        
        if (indexPath.row == 0)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iMuseum"];
        }
        else if (indexPath.row == 1)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iCoffee"];
        }
//        else if (indexPath.row == 2)
//        {
//            cell.menuItemView.image = [UIImage imageNamed:@"iMusic"];
//        }
        else if (indexPath.row == 2)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iHotels"];
        }
        else if (indexPath.row == 3)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iRecreation"];
        }
        else if (indexPath.row == 4)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iBars"];
        }
        else if (indexPath.row == 5)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iEat"];
        }
        else if (indexPath.row == 6)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iShopping"];
        }
        else if (indexPath.row == 7)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iTours"];
        }
        else if (indexPath.row == 8)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iTravel"];
        }
    }
    else
    {
        cell.imageWidth.constant = 64.f;
        cell.imageHeight.constant = 64.f;
        cell.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [cell.titleLabel sizeToFit];
        
        if (indexPath.row == 0)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isMuseum"];
        }
        else if (indexPath.row == 1)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isCoffee"];
        }
//        else if (indexPath.row == 2)
//        {
//            cell.menuItemView.image = [UIImage imageNamed:@"isMusic"];
//        }
        else if (indexPath.row == 2)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isHotels"];
        }
        else if (indexPath.row == 3)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isRecreation"];
        }
        else if (indexPath.row == 4)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isBars"];
        }
        else if (indexPath.row == 5)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isEat"];
        }
        else if (indexPath.row == 6)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isShopping"];
        }
        else if (indexPath.row == 7)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isTours"];
        }
        else if (indexPath.row == 8)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isTravel"];
        }
    }

    
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetHeight(collectionView.frame)));
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SUPExploreCollectionViewCell *cell = (SUPExploreCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *selectionTitle = cell.titleLabel.text;
    
    [self performSegueWithIdentifier:kShowCategorySegue sender:selectionTitle];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SUPCategoryTableViewController *vc = [segue destinationViewController];
    vc.categoryTitle = sender;
    vc.delegate = self;
    vc.cachedDetails = self.cachedDetails;
}

@end
