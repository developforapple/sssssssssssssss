//
//  SPItemListVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemListVC.h"
#import "DDSegmentScrollView.h"
#import "SPItemFilter.h"

#import "SPItemListContainer.h"
#import "Chameleon.h"

@interface SPItemListVC () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (assign, nonatomic) SPItemListMode mode;

@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *,SPItemListContainer *> *vcs;
@property (weak, nonatomic) IBOutlet DDSegmentScrollView *segmentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *changModeButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;

// 分类过后的饰品数据
@property (strong, nonatomic) NSArray<NSArray<SPItem *> *> *items;
@property (strong, nonatomic) NSArray<NSString *> *segmentTitles;

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
    self.segmentView.barTintColor = FlatNavyBlueDark;
    [self updateTitle];
    SPItemListMode mode = [[NSUserDefaults standardUserDefaults] integerForKey:kSPItemListModeKey];
    self.mode = mode;
}

- (void)loadData
{
    DDProgressHUD *HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
    ygweakify(self);
    [self.filter asyncUpdateItems:^(BOOL suc, NSArray *items) {
        ygstrongify(self);
        [HUD hide:YES];
        if (suc) {
            [self update];
        }else{
            [SVProgressHUD showErrorWithStatus:@"发生了一个错误"];
        }
    }];
}

- (void)update
{
    self.items = self.filter.separatedItems;
    self.segmentTitles = self.filter.titles;
    [self reloadData];
}

- (void)reloadData
{
    RunOnMainQueue(^{
        [self updateTitle];
        self.segmentView.titles = self.segmentTitles;
        UIViewController *vc = [self viewControllerAtIndex:0];
        [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    });
}

- (void)updateTitle
{
    NSString *baseTitle = self.filter.filterTitle;
    
    if (self.filter.items.count != 0) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@（%lu）",baseTitle,self.filter.items.count];
    }else{
        self.navigationItem.title = baseTitle;
    }
}

- (IBAction)changeDisplayMode:(UIBarButtonItem *)btnItem
{
    self.mode = (SPItemListMode)!self.mode;
}

- (IBAction)changeFilter:(UIButton *)btn
{
    
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
        vc.topInset = @(64.f+CGRectGetHeight(self.segmentView.bounds));
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
