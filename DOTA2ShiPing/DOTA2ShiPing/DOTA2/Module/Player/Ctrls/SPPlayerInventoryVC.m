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
#import "SPInventoryCategoryPickerVC.h"
#import "DDSegmentScrollView.h"
#import "SPInventoryFilter.h"
#import "SPItemCommon.h"
#import "SPPlayerInventorySearchResultVC.h"
#import "ReactiveObjC.h"

static NSString *const kYGInventoryCategoryPickerSegueID = @"YGInventoryCategoryPickerSegueID";
static NSString *const kYGInventoryPageVCSegueID = @"YGInventoryPageVCSegueID";

@interface SPPlayerInventoryVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *modeBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIndicator;
@property (weak, nonatomic) IBOutlet DDSegmentScrollView *segmentView;

@property (weak, nonatomic) IBOutlet UIView *categoryContainer;
@property (strong, nonatomic) SPInventoryCategoryPickerVC *categoryPicker;
@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *,SPItemListContainer *> *vcs;

@property (assign, nonatomic) NSUInteger currentIndex;

@property (assign, nonatomic) SPItemListMode mode;

@property (strong, nonatomic) SPInventoryFilter *filter;

@end

@implementation SPPlayerInventoryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.vcs = [NSMutableDictionary dictionary];
    
    [self initUI];
    [self initData];
    [self initSignal];
}

- (void)dealloc
{
    NSString *class = NSStringFromClass([self class]);
    NSLog(@"%@释放！！！",class);
}

- (void)initUI
{
    self.segmentView.backgroundColor = [UIColor clearColor];
    self.segmentView.highlightColor = kRedColor;
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self;
    SPItemListMode mode = [[NSUserDefaults standardUserDefaults] integerForKey:kSPItemListModeKey];
    self.mode = mode;
    
    self.categoryIndicator.layer.anchorPoint = CGPointMake(.5f, .5f);
}

- (void)initData
{
    ygweakify(self);
    self.filter = [[SPInventoryFilter alloc] initWithPlayer:self.player];
    [self.filter setUpdateCallback:^{
        ygstrongify(self);
        
        if (self.filter.category == SPInventoryCategoryFilter &&
            self.filter.condition == nil) {
            [self search:self.searchBtn];
        }else{
            [self update];
        }
    }];
    [self.filter updateWithCategory:SPInventoryCategoryAll];
}

- (void)initSignal
{
    ygweakify(self);
    [RACObserve(self.categoryPicker, visible)
     subscribeNext:^(NSNumber *x) {
         ygstrongify(self);
         if (x.boolValue) {
             [UIView animateWithDuration:.2f animations:^{
                 self.categoryIndicator.transform = CGAffineTransformMakeRotation(M_PI);
             }];
             [self.categoryContainer setHidden:NO animated:YES];
             
         }else{
             [UIView animateWithDuration:.2f animations:^{
                 self.categoryIndicator.transform = CGAffineTransformIdentity;
             }];
             [self.categoryContainer setHidden:YES animated:YES];
         }
     }];
}

- (void)update
{
    RunOnMainQueue(^{
        self.segmentView.titles = self.filter.titles;
        SPItemListContainer *vc = [self viewControllerAtIndex:0];
        [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    });
}

#pragma mark - Update
- (void)didChangedCategory:(SPInventoryCategory)type
{
    [self.categoryBtn setTitle:[self.categoryPicker titleForCategory:type] forState:UIControlStateNormal];
    [self.filter updateWithCategory:type];
}

- (void)setCategoryPickerVisible:(BOOL)visible
{
    if (visible) {
        [self.categoryPicker show];
    }else{
        [self.categoryPicker dismiss];
    }
}

#pragma mark - Action
- (IBAction)segmentChanged:(DDSegmentScrollView *)segmentView
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

- (IBAction)changeCategory:(UIButton *)sender
{
    [self setCategoryPickerVisible:!self.categoryPicker.isVisible];
}

- (IBAction)changeMode:(UIBarButtonItem *)sender
{
    self.mode = (SPItemListMode)!self.mode;
}

- (IBAction)search:(UIBarButtonItem *)sender
{
    [self setCategoryPickerVisible:NO];
    
    ygweakify(self);
    SPPlayerInventorySearchResultVC *resutVC = [SPPlayerInventorySearchResultVC instanceFromStoryboard];
    resutVC.filter = self.filter;
    resutVC.mode = self.mode;
    [resutVC setWillShowFilteredResult:^{
        ygstrongify(self);
        [self didChangedCategory:SPInventoryCategoryFilter];
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
    
    for (NSNumber *key in self.vcs) {
        SPItemListContainer *container = self.vcs[key];
        [container update:mode data:nil];
    }
    [UIView animateWithDuration:.2f animations:^{
        self.modeBtn.image = [UIImage imageNamed:self.mode!=SPItemListModeTable?@"icon_three_rectangle":@"icon_four_rectangle"];
    }];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ygweakify(self);
    if ([segue.identifier isEqualToString:kYGInventoryCategoryPickerSegueID]) {
        self.categoryPicker = segue.destinationViewController;
        [self.categoryPicker setDidSelectedCategory:^(SPInventoryCategory type) {
            ygstrongify(self);
            [self didChangedCategory:type];
        }];
    }else if ([segue.identifier isEqualToString:kYGInventoryPageVCSegueID]){
        self.pageVC = segue.destinationViewController;
        self.pageVC.delegate = self;
        self.pageVC.dataSource = self;
    }
}

#pragma mark - Page
- (SPItemListContainer *)viewControllerAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.filter.items.count) {
        return nil;
    }
    NSNumber *k = @(index);
    SPItemListContainer *vc = self.vcs[k];
    if (!vc) {
        vc = [SPItemListContainer instanceFromStoryboard];
        vc.topInset = @(64.f+44.f);
        self.vcs[k] = vc;
    }
    [vc update:self.mode data:self.filter.items[index]];
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
