//
//  SPPlayerInventoryVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerInventoryVC.h"
#import "SPPlayer.h"
#import "SPItemListContainer.h"
#import "DDSegmentScrollView.h"
#import "SPItemCommon.h"
#import "ReactiveObjC.h"

#import "RWDropdownMenu.h"
#import "SPPlayerItemFilter.h"
#import "SPFilterNaviCtrl.h"
#import "SPPlayerItemQuery.h"
#import "SPItemsDetailViewCtrl.h"

static NSString *const kYGInventoryCategoryPickerSegueID = @"YGInventoryCategoryPickerSegueID";
static NSString *const kYGInventoryPageVCSegueID = @"YGInventoryPageVCSegueID";

@interface SPPlayerInventoryVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,SPItemListContainerDelegate,SPFilterDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *modeBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) SPItemListContainer *container;

@property (assign, nonatomic) SPItemListMode mode;
@property (strong, nonatomic) SPPlayerItemQuery *query;

@end

@implementation SPPlayerInventoryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

- (void)dealloc
{
    
}

- (void)initUI
{
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self;
    SPItemListMode mode = [[NSUserDefaults standardUserDefaults] integerForKey:kSPItemListModeKey];
    self.mode = mode;
    
    self.container = [SPItemListContainer instanceFromStoryboard];
    UIEdgeInsets insets = UIEdgeInsetsMake(StatusBar_Height + NaviBar_Height, 0, 0, 0);
    if (IS_5_8_INCH_SCREEN) {
        insets.bottom = 44.f;
    }
    self.container.safeInset = insets;
    self.container.delegate = self;
    self.container.supportLoadMore = YES;
    
    [self.pageVC setViewControllers:@[self.container] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)initData
{
    SPPlayerItemSharedData *data = [SPPlayerItemSharedData new];
    data.list = self.player.itemList;
    data.inventory = self.player.inventory;
    self.query = [SPPlayerItemQuery queryWithPlayerItems:data];
    NSArray<SPItem *> *items = [self.query loadPage:0];
    [self.container update:self.mode data:items];
}

- (void)itemListContainerWillLoadMore:(SPItemListContainer *)container
{
    NSArray *items = [self.query loadPage:self.query.pageNo+1];
    [container appendData:items];
}

- (void)itemListContainer:(SPItemListContainer *)container didSelectedItem:(SPItem *)item
{
    NSInteger index = [container.items indexOfObject:item];
    SPPlayerItemDetail *playerItem = self.query.filteredPlayerItems[index];
    
    SPItemsDetailViewCtrl *vc = [SPItemsDetailViewCtrl instanceFromStoryboard];
    vc.item = item;
    vc.playerItem = playerItem;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
- (IBAction)titleAction:(id)sender
{
    
}

- (IBAction)changeMode:(UIBarButtonItem *)sender
{
    self.mode = (SPItemListMode)!self.mode;
}

- (IBAction)search:(UIBarButtonItem *)sender
{
    SPPlayerItemFilter *filter = [SPPlayerItemFilter new];
    filter.delegate = self;
    [filter setupTypes:SPPlayerItemFilterTypeAll
            sharedData:self.query.playerItemData];
    
    SPFilterNaviCtrl *navi = [SPFilterNaviCtrl instanceFromStoryboard];
    navi.filter = filter;
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

- (void)setMode:(SPItemListMode)mode
{
    _mode = mode;
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kSPItemListModeKey];
    [self.container update:mode data:nil];
    [UIView animateWithDuration:.2f animations:^{
        self.modeBtn.image = [UIImage imageNamed:self.mode!=SPItemListModeTable?@"icon_three_rectangle":@"icon_four_rectangle"];
    }];
}

- (void)filter:(SPBaseFilter *)filter didCompleted:(NSArray<SPPlayerItemFilterUnit *> *)units
{
    [self.query filter:units];
    NSArray *items = [self.query loadPage:0];
    [self.container update:self.mode data:items];
    if (units.count > 0) {
        [self.titleBtn setTitle:@"多个筛选项" forState:UIControlStateNormal];
    }else{
        [self.titleBtn setTitle:@"全部" forState:UIControlStateNormal];
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kYGInventoryPageVCSegueID]){
        self.pageVC = segue.destinationViewController;
        self.pageVC.delegate = self;
        self.pageVC.dataSource = self;
    }
}

#pragma mark - UIPageViewController
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}

@end
