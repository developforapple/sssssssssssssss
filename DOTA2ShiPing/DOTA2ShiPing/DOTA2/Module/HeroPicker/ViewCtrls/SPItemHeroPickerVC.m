//
//  SPItemHeroPickerVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemHeroPickerVC.h"
#import "SPItemCommon.h"
#import "SPDataManager.h"
#import "SPHeroCell.h"
#import "SPItemHeroListVC.h"

static NSString *const kHeroHistorySaveKey = @"com.wwwbbat.herohistory2";

@interface SPItemHeroPickerVC () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearItem;
@property (strong, nonatomic) NSMutableArray<NSString *> *historyList;
@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSArray<SPItemHeroListVC *> *listVCs;
@property (assign, nonatomic) NSUInteger currentIndex;
@end

@implementation SPItemHeroPickerVC

+ (void)presentFrom:(UIViewController *)vc selectedCallback:(SPHeroPickerCallbackBlock)callback
{
    SPItemHeroPickerVC *picker = [[self class] instanceFromStoryboard];
    picker.didSelectedHero = callback;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:picker];
    [vc presentViewController:navi animated:YES completion:nil];
}

+ (void)bePushingIn:(UINavigationController *)navi
   selectedCallback:(SPHeroPickerCallbackBlock)callback
{
    SPItemHeroPickerVC *picker = [[self class] instanceFromStoryboard];
    picker.didSelectedHero = callback;
    [navi pushViewController:picker animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadHistoryList];
    [self initUI];
}

- (void)loadHistoryList
{
    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey:kHeroHistorySaveKey];
    self.historyList = [NSMutableArray arrayWithArray:list];
}

- (void)updateHistoryList
{
    SPItemHeroListVC *vc = [self viewControllerAtIndex:0];
    vc.history = self.historyList;
    [vc reloadData];
    [self updateUI];
}

- (void)addHeroToHistory:(SPHero *)hero
{
    if ([self.historyList containsObject:hero.HeroID]) {
        [self.historyList removeObject:hero.HeroID];
    }
    [self.historyList insertObject:hero.HeroID atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyList forKey:kHeroHistorySaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateHistoryList];
}

- (void)didSelectedHero:(SPHero *)hero
{
    [self addHeroToHistory:hero];
    if (self.didSelectedHero) {
        BOOL exit = self.didSelectedHero(hero);
        if (exit) {
            [self doLeftNaviBarItemAction];
        }
    }
}

#pragma mark - UI
- (void)initUI
{
    self.currentIndex = self.historyList.count?0:1;
    
    [self updateUI];
    [self.segmentControl setSelectedSegmentIndex:self.currentIndex];
    
    SPItemHeroListVC *vc = [self viewControllerAtIndex:_currentIndex];
    [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    if ([self.navigationController.viewControllers firstObject] == self &&
        self.navigationController.presentingViewController) {
        [self leftNavButtonImg:@"icon_navi_cancel"];
    }
}

- (void)updateUI
{
    [self.navigationItem setRightBarButtonItem: self.currentIndex==0?self.clearItem:nil animated:YES];
    self.clearItem.enabled = self.historyList.count!=0;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    if (_currentIndex == currentIndex) return;
    
    UIPageViewControllerNavigationDirection direction = currentIndex<_currentIndex;
    SPItemHeroListVC *vc = [self viewControllerAtIndex:currentIndex];
    [self.pageVC setViewControllers:@[vc] direction:direction animated:YES completion:nil];
    _currentIndex = currentIndex;
    [self updateUI];
}

- (SPItemHeroListVC *)viewControllerAtIndex:(NSInteger)index
{
    if (!self.listVCs) {
        ygweakify(self);
        void (^selectedHeroCallback)(SPHero *hero) = ^(SPHero *hero){
            ygstrongify(self);
            [self didSelectedHero:hero];
        };
        
        SPItemHeroListVC *vc0 = [SPItemHeroListVC instanceFromStoryboard];
        vc0.type = -1;
        vc0.history = self.historyList;
        vc0.didSelectedHero = selectedHeroCallback;
        SPItemHeroListVC *vc1 = [SPItemHeroListVC instanceFromStoryboard];
        vc1.type = SPHeroTypePow;
        vc1.didSelectedHero = selectedHeroCallback;
        SPItemHeroListVC *vc2 = [SPItemHeroListVC instanceFromStoryboard];
        vc2.type = SPHeroTypeDex;
        vc2.didSelectedHero = selectedHeroCallback;
        SPItemHeroListVC *vc3 = [SPItemHeroListVC instanceFromStoryboard];
        vc3.type = SPHeroTypeWit;
        vc3.didSelectedHero = selectedHeroCallback;
        self.listVCs = @[vc0,vc1,vc2,vc3];
    }
    
    if (index >= 0 && index < self.listVCs.count) {
        return self.listVCs[index];
    }
    return nil;
}

#pragma mark - Acton
- (IBAction)segmentTapped:(UISegmentedControl *)segment
{
    NSUInteger index = segment.selectedSegmentIndex;
    [self setCurrentIndex:index];
}

- (IBAction)clearHistory:(id)sender
{
    [self.historyList removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHeroHistorySaveKey];
    [self updateHistoryList];
}

#pragma mark - UIPageViewController
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(SPItemHeroListVC *)viewController
{
    NSUInteger idx = [self.listVCs indexOfObject:viewController];
    SPItemHeroListVC *vc = [self viewControllerAtIndex:idx+1];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(SPItemHeroListVC *)viewController
{
    NSInteger idx = [self.listVCs indexOfObject:viewController];
    NSInteger lastIdx = idx-1;
    SPItemHeroListVC *vc = [self viewControllerAtIndex:lastIdx];
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSUInteger idx = [self.listVCs indexOfObject:[pageViewController.viewControllers firstObject]];
    [self.segmentControl setSelectedSegmentIndex:idx];
    _currentIndex = idx;
    [self updateUI];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString *pageVCSegueID = @"SPHeroPickerPageVCSegueID";
    if ([segue.identifier isEqualToString:pageVCSegueID]) {
        self.pageVC = [segue destinationViewController];
        self.pageVC.delegate = self;
        self.pageVC.dataSource = self;
    }
}

@end
