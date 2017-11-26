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
#import "SPInventoryFilter.h"
#import "SPItemCommon.h"
#import "SPPlayerInventorySearchResultVC.h"
#import "ReactiveObjC.h"

#import "RWDropdownMenu.h"
#import "SPPlayerItemFilter.h"
#import "SPFilterNaviCtrl.h"
#import "SPPlayerItemQuery.h"

static NSString *const kYGInventoryCategoryPickerSegueID = @"YGInventoryCategoryPickerSegueID";
static NSString *const kYGInventoryPageVCSegueID = @"YGInventoryPageVCSegueID";

@interface SPPlayerInventoryVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,SPItemListContainerDelegate,SPFilterDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *modeBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;

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

#pragma mark - Action
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
    
    return;
    
    
    ygweakify(self);
    SPPlayerInventorySearchResultVC *resutVC = [SPPlayerInventorySearchResultVC instanceFromStoryboard];
//    resutVC.filter = self.filter;
    resutVC.mode = self.mode;
    [resutVC setWillShowFilteredResult:^{
        ygstrongify(self);
//        [self didChangedCategory:SPInventoryCategoryFilter];
    }];
    
    UISearchController *vc = [[UISearchController alloc] initWithSearchResultsController:resutVC];
    resutVC.searchCtrl = vc;
    vc.searchResultsUpdater = resutVC;
    vc.searchBar.placeholder = @"搜索关键词：名称/品质/英雄";
    vc.searchBar.translucent = YES;
    [vc.searchBar setBackgroundImage:nil];
    vc.searchBar.barTintColor = kRedColor;
    vc.searchBar.searchBarStyle = UISearchBarStyleProminent;
    vc.dimsBackgroundDuringPresentation = NO;
    vc.hidesNavigationBarDuringPresentation = NO;
    [self presentViewController:vc animated:YES completion:nil];
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

- (void)filter:(SPBaseFilter *)filter didCompleted:(NSArray<SPFilterUnit *> *)units
{
    NSLog(@"");
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
