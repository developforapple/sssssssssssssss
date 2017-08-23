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
#import "SPItemFilterViewCtrl.h"

@interface SPItemListVC () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (assign, nonatomic) SPItemListMode mode;

@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *,SPItemListContainer *> *vcs;
@property (weak, nonatomic) IBOutlet DDSegmentScrollView *segmentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *changModeButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@property (strong, nonatomic) NSArray<SPFilterOption *> *options;
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
    if (!self.options || self.options.count == 0) {
        self.items = self.filter.separatedItems;
    }else{
        //根据options过滤一遍
        
        SPHero *hero;
        SPItemRarity *rarity;
        SPDotaEvent *event;
        for (SPFilterOption *option in self.options) {
            switch (option.type) {
                case SPFilterOptionTypeHero: hero = option.option;break;
                case SPFilterOptionTypeRarity: rarity = option.option;break;
                case SPFilterOptionTypeEvent: event = option.option;break;
            }
        }
        
        NSMutableArray *newItems = [NSMutableArray array];
        for (NSArray<SPItem *> *itemArray in self.filter.separatedItems) {
            NSMutableArray *newItemArray = [NSMutableArray array];
            [newItems addObject:newItemArray];
            for (SPItem *aItem in itemArray) {
                
                BOOL heroOK = !hero || [aItem.heroes containsString:hero.name];
                BOOL rarityOK = !rarity || [aItem.item_rarity isEqualToString:rarity.name];
                BOOL eventOK = !event || [aItem.event_id isEqualToString:event.event_id];
                if (heroOK && rarityOK && eventOK) {
                    [newItemArray addObject:aItem];
                }
            }
        }
        
        self.items = newItems;
    }
    self.emptyLabel.hidden = self.items.count;
    [self reloadData];
}

- (void)reloadData
{
    RunOnMainQueue(^{
        [self updateTitle];
        
        NSMutableArray *titles = [NSMutableArray array];
        for (NSInteger i=0; i<self.filter.titles.count; i++) {
            NSString *title = self.filter.titles[i];
            if (i < self.items.count && self.items[i].count != 0) {
                [titles addObject:[NSString stringWithFormat:@"%@ %lu",title,(unsigned long)self.items[i].count]];
            }else{
                [titles addObject:title];
            }
        }
        self.segmentView.titles = titles;
        
        if (self.vcs.count == 0) {
            UIViewController *vc = [self viewControllerAtIndex:0];
            if (vc) {
                [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }
        }else{
            for (NSNumber *key in self.vcs) {
                SPItemListContainer *container = self.vcs[key];
                [container update:self.mode data:self.items[key.integerValue]];
            }
        }
    });
}

- (void)updateTitle
{
    NSString *baseTitle = self.filter.filterTitle;
    self.navigationItem.title = baseTitle;
    
//    if (self.filter.items.count != 0) {
//        self.navigationItem.title = [NSString stringWithFormat:@"%@（%lu）",baseTitle,self.filter.items.count];
//    }else{
//        self.navigationItem.title = baseTitle;
//    }
}

- (IBAction)changeDisplayMode:(UIBarButtonItem *)btnItem
{
    self.mode = (SPItemListMode)!self.mode;
}

- (IBAction)changeFilter:(UIButton *)btn
{
    ygweakify(self);
    SPItemFilterNaviCtrl *navi = [SPItemFilterNaviCtrl instanceFromStoryboard];
    [navi setup:SPFilterOptionTypeHero | SPFilterOptionTypeRarity | SPFilterOptionTypeEvent options:nil completion:^(BOOL canceled, NSArray<SPFilterOption *> *options) {
        if (!canceled ) {
            ygstrongify(self);
            [self filter:options];
        }
    }];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

- (void)filter:(NSArray<SPFilterOption *> *)options
{
    self.options = options;
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
