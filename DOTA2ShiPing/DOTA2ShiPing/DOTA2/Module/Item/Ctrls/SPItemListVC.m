//
//  SPItemListVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemListVC.h"
#import "DDSegmentScrollView.h"
#import "SPItemQuery.h"

#import "SPItemListContainer.h"
#import "Chameleon.h"

#import "SPItemFilter.h"
#import "SPFilterNaviCtrl.h"

@interface SPItemListVC () <UIPageViewControllerDelegate,UIPageViewControllerDataSource,SPItemFilterDelegate>

@property (assign, nonatomic) SPItemListMode mode;

@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *,SPItemListContainer *> *vcs;
@property (weak, nonatomic) IBOutlet DDSegmentScrollView *segmentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *changModeButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@property (strong, nonatomic) NSArray<SPItemFilterUnit *> *filterUnits;
// 分类过后的饰品数据
@property (strong, nonatomic) NSArray<NSArray<SPItem *> *> *items;

@property (assign, nonatomic) NSUInteger currentIndex;

@end

@implementation SPItemListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vcs = [NSMutableDictionary dictionary];
    [self initUI];
    [self loadData];
}

- (void)initUI
{
    self.segmentView.barTintColor = FlatNavyBlue;
    [self updateTitle];
    SPItemListMode mode = [[NSUserDefaults standardUserDefaults] integerForKey:kSPItemListModeKey];
    self.mode = mode;
}

- (void)loadData
{
    DDProgressHUD *HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
    ygweakify(self);
    [self.query asyncUpdateItems:^(BOOL suc, NSArray *items) {
        ygstrongify(self);
        [HUD hideAnimated:YES];
        if (suc) {
            [self update];
        }else{
            [SVProgressHUD showErrorWithStatus:@"发生了一个错误"];
        }
    }];
}

- (void)update
{
    [self.query filter:self.filterUnits];
    self.items = [self.query displayItems];
    self.emptyLabel.hidden = self.items.count;
    [self reloadData];
}

- (void)reloadData
{
    RunOnMainQueue(^{
        [self updateTitle];
        
        NSMutableArray *titles = [NSMutableArray array];
        NSArray *curTitles = [self.query displayTitles];
        for (NSInteger i=0; i<curTitles.count; i++) {
            NSString *title = curTitles[i];
            if (i < self.items.count && self.items[i].count != 0) {
                [titles addObject:[NSString stringWithFormat:@"%@ %lu",title,(unsigned long)self.items[i].count]];
            }else{
                [titles addObject:title];
            }
        }
        self.segmentView.titles = titles;
        self.segmentView.currentIndex = 0;
        
        [self.vcs removeAllObjects];
        UIViewController *vc = [self viewControllerAtIndex:0];
        if (vc) {
            [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        }
    });
}

- (void)updateTitle
{
    NSString *baseTitle = self.query.queryTitle;
    self.navigationItem.title = baseTitle;
}

- (IBAction)changeDisplayMode:(UIBarButtonItem *)btnItem
{
    self.mode = (SPItemListMode)!self.mode;
}

- (IBAction)changeFilter:(UIButton *)btn
{
    SPItemFilter *filter = [[SPItemFilter alloc] init];
    filter.delegate = self;
    [filter setupTypes:SPItemFilterTypeAll];

    SPFilterNaviCtrl *navi = [SPFilterNaviCtrl instanceFromStoryboard];
    navi.filter = filter;
    
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

- (void)filter:(SPBaseFilter *)filter didCompleted:(NSArray<SPFilterUnit *> *)units
{
    self.filterUnits = units;
    [self update];
}

- (void)setMode:(SPItemListMode)mode
{
    _mode = mode;
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kSPItemListModeKey];
    
    for (NSNumber *key in self.vcs) {
        SPItemListContainer *container = self.vcs[key];
        [container update:mode data:nil];
    }
    [UIView animateWithDuration:.2f animations:^{
        self.changModeButtonItem.image = [UIImage imageNamed:self.mode!=SPItemListModeTable?@"icon_three_rectangle":@"icon_four_rectangle"];
    }];
}

- (IBAction)segmentIndexChanged:(DDSegmentScrollView *)segmentView
{
    UIViewController *vc = [self viewControllerAtIndex:segmentView.currentIndex];
    if (vc) {
        NSUInteger lastIndex = segmentView.lastIndex;
        NSUInteger currentIndex = segmentView.currentIndex;
        UIPageViewControllerNavigationDirection direction = lastIndex > currentIndex;
        [self.pageVC setViewControllers:@[vc] direction:direction animated:YES completion:nil];
        _currentIndex = currentIndex;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString *id = @"SPItemListPageVCSegueID";
    if ([segue.identifier isEqualToString:id]) {
        self.pageVC = segue.destinationViewController;
        self.pageVC.delegate = self;
        self.pageVC.dataSource = self;
    }
}

#pragma mark - Page
- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.items.count) {
        return nil;
    }
    NSNumber *k = @(index);
    SPItemListContainer *vc = self.vcs[k];
    if (!vc) {
        vc = [SPItemListContainer instanceFromStoryboard];
        [vc update:self.mode data:self.items[index]];
        
        UIEdgeInsets inset = UIEdgeInsetsZero;
        inset.top += CGRectGetHeight(self.segmentView.bounds);
        inset.top += StatusBar_Height;
        inset.top += NaviBar_Height;
        vc.safeInset = inset;
        
        self.vcs[k] = vc;
    }
    return vc;
}

- (NSInteger)indexOfViewController:(UIViewController *)vc
{
    NSInteger index = NSNotFound;
    for (NSNumber *k in self.vcs) {
        UIViewController *viewController = self.vcs[k];
        if (viewController == vc) {
            index = k.integerValue;
            break;
        }
    }
    return index;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    self.segmentView.currentIndex = currentIndex;
}

#pragma mark - UIPageViewController
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:viewController];
    if (index != NSNotFound) {
        return [self viewControllerAtIndex:index+1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:viewController];
    if (index != NSNotFound) {
        return [self viewControllerAtIndex:index-1];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSUInteger index = [self indexOfViewController:[pageViewController.viewControllers firstObject]];
    [self setCurrentIndex:index];
}

@end
