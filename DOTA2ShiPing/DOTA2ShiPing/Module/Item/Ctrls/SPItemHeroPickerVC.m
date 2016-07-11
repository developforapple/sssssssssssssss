//
//  SPItemHeroPickerVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemHeroPickerVC.h"
#import "SPItemCommon.h"
#import "SPMacro.h"
#import "SPHeroCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "SPLogoHeader.h"
#import "SPItemFilter.h"

#define kSPItemHeroItemsListSegue @"SPItemHeroItemsListSegue"

@interface SPItemHeroListVC : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;

@property (strong, nonatomic) NSArray<NSNumber *> *history;
@property (assign, nonatomic) SPHeroType type;

@property (strong, nonatomic) NSArray<NSArray *> *heroes;

@property (copy, nonatomic) void (^didSelectedHero)(SPHero *hero);

- (void)reloadData;

@end

@implementation SPItemHeroListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self loadData];
}

- (void)initUI
{
    self.collectionView.contentInset = UIEdgeInsetsMake(64.f, 0, 0, 0);
    
    CGFloat width;
    CGFloat height;
    CGFloat insetL;
    CGFloat insetR;
    CGFloat sp;
    
    insetL = .5f;
    insetR = .5f;
    sp = .5f;
    width = (DeviceWidth - 5 * .5f)/4.f;
    height = ceilf(width *144.f / 256.f);
    
    self.flowlayout.itemSize = CGSizeMake(width, height);
    self.flowlayout.sectionInset =  UIEdgeInsetsMake(insetL, insetL, 0.f, insetR);
    self.flowlayout.minimumLineSpacing = sp;
    self.flowlayout.minimumInteritemSpacing = 0.f;
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
}

- (void)reloadData
{
    [self loadData];
    [self.collectionView reloadData];
    [self.collectionView reloadEmptyDataSet];
}

#pragma mark - Data
- (void)loadData
{
    if (self.history) {
        self.heroes = @[[self heroesWithIds:self.history]];
    }else{
        self.heroes = [self heroesWithType:self.type];
    }
}

- (NSArray<SPHero *> *)heroesWithIds:(NSArray *)ids
{
    NSArray *heroes = [SPDataManager shared].heroes;
    NSMutableArray *tmp = [NSMutableArray array];
    for (SPHero *hero in heroes) {
        if ([ids containsObject:hero.id]) {
            [tmp addObject:hero];
        }
    }
    [tmp sortUsingComparator:^NSComparisonResult(SPHero *obj1,SPHero *obj2) {
        NSUInteger idx1 = [ids indexOfObject:obj1.id];
        NSUInteger idx2 = [ids indexOfObject:obj2.id];
        return [@(idx1) compare:@(idx2)];
    }];
    return tmp;
}

- (NSArray<NSArray<SPHero *> *> *)heroesWithType:(SPHeroType)type
{
    NSArray *heroes = [SPDataManager shared].heroes;
    NSMutableArray *radiant = [NSMutableArray array];
    NSMutableArray *dire = [NSMutableArray array];
    
    for (SPHero *hero in heroes) {
        if (hero.type == type) {
            switch (hero.subType) {
                case SPHeroCampRadiant:
                    [radiant addObject:hero];
                    break;
                case SPHeroCampDire:
                    [dire addObject:hero];
                    break;
            }
        }
    }
    
    NSComparisonResult (^sort)(SPHero *,SPHero *) = ^NSComparisonResult(SPHero *obj1,SPHero *obj2){
        return [obj1.position compare:obj2.position];
    };
    
    [radiant sortUsingComparator:sort];
    [dire sortUsingComparator:sort];
    
    return @[radiant,dire];
}

#pragma mark - Empty
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attr = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    return [[NSAttributedString alloc] initWithString:@"没有历史记录" attributes:attr];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (self.history) {
        return self.history.count == 0;
    }
    return NO;
}

#pragma mark - UICollectionView 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _history?1:2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_heroes[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPHeroCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPHeroCell forIndexPath:indexPath];
    [cell configure:_heroes[indexPath.section][indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedHero) {
        self.didSelectedHero(self.heroes[indexPath.section][indexPath.row]);
    }
}

@end

static NSString *const kHeroHistorySaveKey = @"com.wwwbbat.herohistory";

@interface SPItemHeroPickerVC () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearItem;

@property (strong, nonatomic) NSMutableArray<NSNumber *> *historyList;
@property (strong, nonatomic) UIPageViewController *pageVC;

@property (strong, nonatomic) NSMutableArray<SPItemHeroListVC *> *listVCs;

@property (assign, nonatomic) NSUInteger currentIndex;

@end

@implementation SPItemHeroPickerVC

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
    SPItemHeroListVC *vc = [self.listVCs firstObject];
    if ([vc isKindOfClass:[NSNull class]]) {
        vc.history = self.historyList;
        [vc reloadData];
        [self updateUI];
    }
}

- (void)addHeroToHistory:(SPHero *)hero
{
    if ([self.historyList containsObject:hero.id]) {
        [self.historyList removeObject:hero.id];
    }
    [self.historyList insertObject:hero.id atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyList forKey:kHeroHistorySaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateHistoryList];
}

- (void)didSelectedHero:(SPHero *)hero
{
    [self addHeroToHistory:hero];
    SPItemFilter *filter = [SPItemFilter filterWithHero:hero];
    [self performSegueWithIdentifier:kSPItemHeroItemsListSegue sender:filter];
}

#pragma mark - UI
- (void)initUI
{
    self.listVCs = @[[NSNull null],[NSNull null],[NSNull null],[NSNull null]].mutableCopy;
    SPItemHeroListVC *vc;
    
    if (self.historyList.count > 0) {
        _currentIndex = 0;
        vc = [self viewControllerAtIndex:_currentIndex];
    }else{
        _currentIndex = 1;
        vc = [self viewControllerAtIndex:_currentIndex];
    }
    
    [self updateUI];
    [self.segmentControl setSelectedSegmentIndex:_currentIndex];
    
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self;
    [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)updateUI
{
    if (self.currentIndex == 0) {
        [self.navigationItem setRightBarButtonItem:self.clearItem animated:YES];
    }else{
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    self.clearItem.enabled = self.historyList.count!=0;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    if (_currentIndex == currentIndex) {
        return;
    }
    UIPageViewControllerNavigationDirection direction = currentIndex<_currentIndex;
    SPItemHeroListVC *vc = [self viewControllerAtIndex:currentIndex];
    [self.pageVC setViewControllers:@[vc] direction:direction animated:YES completion:nil];
    _currentIndex = currentIndex;
    [self updateUI];
}

- (SPItemHeroListVC *)viewControllerAtIndex:(NSInteger)index
{
    if (index >= 0 && index < self.listVCs.count) {
        id vc = self.listVCs[index];
        if (vc == [NSNull null]) {
            vc = [SPItemHeroListVC instanceFromStoryboard];
            [(SPItemHeroListVC *)vc setType:index-1];
            if (index == 0) {
                [(SPItemHeroListVC *)vc setHistory:self.historyList];
            }
            [(SPItemHeroListVC *)vc setDidSelectedHero:^(SPHero *hero) {
                [self didSelectedHero:hero];
            }];
            [self.listVCs replaceObjectAtIndex:index withObject:vc];
        }
        return vc;
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
    }else if ([segue.identifier isEqualToString:kSPItemHeroItemsListSegue]){
        UIViewController *vc = [segue destinationViewController];
        
        SEL sel = @selector(setFilter:);
        if ([vc respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [vc performSelector:sel withObject:sender];
#pragma clang diagnostic pop
        }
    }
}

@end
