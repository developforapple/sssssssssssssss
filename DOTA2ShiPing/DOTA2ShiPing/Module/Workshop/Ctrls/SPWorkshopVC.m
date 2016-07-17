//
//  SPWorkshopVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/11.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPWorkshopVC.h"
#import "SPWorkshop.h"
#import "SPWorkshopCell.h"
#import "SPMacro.h"
#import "UIView+More.h"
#import "SPPopoverView.h"
#import "DDProgressHUD.h"
#import "SPLogoHeader.h"
#import "SPWorkshopTagVC.h"
#import <MJRefresh.h>
#import "RWDropdownMenu.h"
#import <ReactiveCocoa.h>
#import <UIScrollView+EmptyDataSet.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <SafariServices/SafariServices.h>

static NSString *const kSPWorkshopFilterSegueID = @"SPWorkshopFilterSegueID";

@interface SPWorkshopVC ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (strong, nonatomic) SPWorkshop *workshop;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterBtnItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortBtnItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBtnItem;
@property (weak, nonatomic) IBOutlet UIButton *sectionBtn;

@property (strong, nonatomic) DDProgressHUD *HUD;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation SPWorkshopVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSignal];
    
    [self.navigationController.barHideOnSwipeGestureRecognizer addTarget:self action:@selector(navigationBarChangedOnSwip:)];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjrefreshAction:)];
    self.flowLayout.itemSize = CGSizeMake(DeviceWidth/2, DeviceWidth/2);
    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
    
    spweakify(self);
    self.workshop = [[SPWorkshop alloc] init];
    [self.workshop setUpdateCallback:^(BOOL suc, BOOL isMore) {
        spstrongify(self);
        [self.collectionView reloadData];
        
        if (isMore) {
            if (self.workshop.noMoreData) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collectionView.mj_footer endRefreshing];
            }
        }else{
            [self.collectionView.mj_footer resetNoMoreData];
        }
        
        [self.sectionBtn setTitle:[SPWorkshop sectionVisiblaTitle:self.workshop.query.section] forState:UIControlStateNormal];
        self.isLoading = NO;
        [self.HUD hide:YES];
    }];
    
    self.isLoading = YES;
    self.HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
    [self.workshop loadWorkshopSection:SPWorkshopSectionItem ignoreCache:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initSignal
{
    id (^enable)(id value) = ^id(id v){return @(![v boolValue]);};
    RAC(self.filterBtnItem,enabled) = [RACObserve(self, isLoading) map:enable];
    RAC(self.sectionBtn,enabled) = [RACObserve(self, isLoading) map:enable];
    RAC(self.sortBtnItem,enabled) = [RACObserve(self, isLoading) map:enable];
}

- (void)handleQueryTags:(NSArray *)tags
{
    self.isLoading = YES;
    self.HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
    [self.workshop filter:tags];
}

#pragma mark - Action
- (IBAction)changeSection:(UIButton *)btn
{
    static NSArray *items;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        items = @[[RWDropdownMenuItem itemWithText:[SPWorkshop sectionVisiblaTitle:SPWorkshopSectionItem] image:nil action:nil],
                  [RWDropdownMenuItem itemWithText:[SPWorkshop sectionVisiblaTitle:SPWorkshopSectionGame] image:nil action:nil],
                  [RWDropdownMenuItem itemWithText:[SPWorkshop sectionVisiblaTitle:SPWorkshopSectionMerchandise] image:nil action:nil],
                  [RWDropdownMenuItem itemWithText:[SPWorkshop sectionVisiblaTitle:SPWorkshopSectionCollections] image:nil action:nil],];
    });
    spweakify(self);
    void (^action)(SPWorkshopSection) = ^(SPWorkshopSection section){
        spstrongify(self);
        self.HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
        self.isLoading = YES;
        [self.workshop loadWorkshopSection:section ignoreCache:NO];
    };
    for (RWDropdownMenuItem *item in items) {
        NSUInteger idx = [items indexOfObject:item];
        [item setValue:^{action(idx);} forKey:@"action"];
    }
    [RWDropdownMenu presentFromViewController:self withItems:items align:RWDropdownMenuCellAlignmentCenter style:RWDropdownMenuStyleTranslucent navBarImage:nil completion:nil];
}

- (IBAction)filter:(UIBarButtonItem *)item
{
    
}

- (IBAction)sort:(UIBarButtonItem *)item
{

//    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.youtube.com/embed/MfW-EMU6LJ4"]];
//    [self presentViewController:safari animated:YES completion:nil];
//    return;
    
    spweakify(self);
    void (^action)(SPWorkshopSort *sort) = ^(SPWorkshopSort *sort){
        spstrongify(self);
        self.HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
        self.isLoading = YES;
        [self.workshop sort:sort];
    };
    
    NSArray *sorts = [SPWorkshopSort sortForSection:self.workshop.query.section];
    NSMutableArray *items = [NSMutableArray array];
    for (SPWorkshopSort *sort in sorts) {
        RWDropdownMenuItem *item = [RWDropdownMenuItem itemWithText:sort.name image:nil action:^{
            action(sort);
        }];
        [items addObject:item];
    }
    [RWDropdownMenu presentFromViewController:self withItems:items align:RWDropdownMenuCellAlignmentCenter style:RWDropdownMenuStyleTranslucent navBarImage:nil completion:nil];
}

- (IBAction)search:(UIBarButtonItem *)item
{
    
}

- (void)navigationBarChangedOnSwip:(UIPanGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateBegan) {
        BOOL isHidden = self.navigationController.isNavigationBarHidden;
        [self.tabBarController.tabBar setHidden:isHidden animated:YES];
    }
}

- (void)mjrefreshAction:(MJRefreshComponent *)mj
{
    if (mj == self.collectionView.mj_footer) {
        [self.workshop loadMore];
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSPWorkshopFilterSegueID]) {
        SPWorkshopTagVC *tagVC = segue.destinationViewController;
        spweakify(self);
        [tagVC setup:self.workshop completion:^(BOOL canceled, NSArray<SPWorkshopTag *> *tags) {
            spstrongify(self);
            if (!canceled) {
                [self handleQueryTags:tags];
            }
        }];
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.workshop.units.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPWorkshopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPWorkshopCell forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SPWorkshopCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPWorkshopUnit *unit = self.workshop.units[indexPath.item];
    [cell configureWithUnit:unit];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPWorkshopUnit *unit = self.workshop.units[indexPath.item];
    [self.workshop fetchDetail:unit];
    NSLog(@"%@",unit.id);
}

#pragma mark - Empty
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                           NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:@"没有内容" attributes:attr];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.workshop.units.count==0;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
@end
