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
#import "SPPopoverView.h"
#import "DDProgressHUD.h"
#import "SPLogoHeader.h"
#import "SPWorkshopTagVC.h"
#import "MJRefresh.h"
#import "RWDropdownMenu.h"
#import "SPWebHelper.h"
#import "SPFocusVisualEffectVC.h"
#import "SPWorkshopResourcesVC.h"
#import "SPDiskCacheControl.h"
#import "ReactiveObjC.h"
#import "UIScrollView+EmptyDataSet.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <SafariServices/SafariServices.h>

NSInteger itemPerRow = 2;

static NSString *const kSPWorkshopFilterSegueID = @"SPWorkshopFilterSegueID";
static NSString *const kSPWorkshopResourcesSegueID = @"SPWorkshopResourcesSegueID";

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

@property (weak, nonatomic) SPFocusVisualEffectVC *cellFocusVC;
@property (weak, nonatomic) RWDropdownMenu *cellFocusMenu;

@end

@implementation SPWorkshopVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSignal];
    
    [self.navigationController.barHideOnSwipeGestureRecognizer addTarget:self action:@selector(navigationBarChangedOnSwip:)];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjrefreshAction:)];
    [self setupLayout:Screen_Size];
    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
    
    ygweakify(self);
    self.workshop = [[SPWorkshop alloc] init];
    [self.workshop setUpdateCallback:^(BOOL suc, BOOL isMore) {
        ygstrongify(self);
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
        [self.HUD hideAnimated:YES];
    }];
    
    self.isLoading = YES;
    self.HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
    [self.workshop loadWorkshopSection:SPWorkshopSectionItem ignoreCache:YES];
}

- (void)setupLayout:(CGSize)size
{
    itemPerRow = IS_iPad ? (IS_Landscape ? 4 : 3) : 2 ;
    CGFloat width = size.width / itemPerRow;
    CGFloat height = width;
    self.flowLayout.itemSize = CGSizeMake(width, height);
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

- (void)transitionLayoutToSize:(CGSize)size
{
    ygweakify(self);
    [self.cellFocusMenu.presentingViewController dismissViewControllerAnimated:YES completion:^{
        ygstrongify(self);
        [self.cellFocusVC dismiss];
        
        [self setupLayout:size];
        [self.collectionView setCollectionViewLayout:self.flowLayout animated:NO];
    }];
}

#pragma mark - Action
- (IBAction)changeSection:(UIButton *)btn
{
    NSArray *items = @[[RWDropdownMenuItem itemWithText:[SPWorkshop sectionVisiblaTitle:SPWorkshopSectionItem] image:nil action:nil],
                       [RWDropdownMenuItem itemWithText:[SPWorkshop sectionVisiblaTitle:SPWorkshopSectionGame] image:nil action:nil],
                       [RWDropdownMenuItem itemWithText:[SPWorkshop sectionVisiblaTitle:SPWorkshopSectionMerchandise] image:nil action:nil],
                       [RWDropdownMenuItem itemWithText:[SPWorkshop sectionVisiblaTitle:SPWorkshopSectionCollections] image:nil action:nil]];
    ygweakify(self);
    void (^action)(SPWorkshopSection) = ^(SPWorkshopSection section){
        ygstrongify(self);
        self.HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
        self.isLoading = YES;
        [self.workshop loadWorkshopSection:section ignoreCache:NO];
    };
    for (RWDropdownMenuItem *item in items) {
        NSUInteger idx = [items indexOfObject:item];
        [item setValue:^{action(idx);} forKey:@"action"];
    }
    [RWDropdownMenu presentInPopoverFromView:btn
                                   direction:UIPopoverArrowDirectionAny
                                       align:RWDropdownMenuCellAlignmentCenter
                              presentingFrom:self
                                   withItems:items
                                  completion:nil];
}

- (IBAction)filter:(UIBarButtonItem *)item
{
    
}

- (IBAction)sort:(UIBarButtonItem *)item
{
    ygweakify(self);
    void (^action)(SPWorkshopSort *sort) = ^(SPWorkshopSort *sort){
        ygstrongify(self);
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
    [RWDropdownMenu presentInPopoverFromBarButtonItem:item presentingFrom:self withItems:items completion:nil];
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

- (void)showResources:(SPWorkshopUnit *)unit
{
    SPLog(@"一共%lu个资源",(unsigned long)unit.resources.count);
    [self performSegueWithIdentifier:kSPWorkshopResourcesSegueID sender:unit];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSPWorkshopFilterSegueID]) {
        SPWorkshopTagVC *tagVC = segue.destinationViewController;
        ygweakify(self);
        [tagVC setup:self.workshop completion:^(BOOL canceled, NSArray<SPWorkshopTag *> *tags) {
            ygstrongify(self);
            if (!canceled) {
                [self handleQueryTags:tags];
            }
        }];
    }else if ([segue.identifier isEqualToString:kSPWorkshopResourcesSegueID]){
        SPWorkshopResourcesVC *vc = segue.destinationViewController;
        vc.unit = sender;
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
    static BOOL lock = NO;
    if (lock) {
        RunAfter(.2f, ^{
            lock = NO;
        });
        return;
    }
    
    ygweakify(self);
    NSArray *items = @[
                       [RWDropdownMenuItem itemWithText:@"查看视频和图片" image:nil action:^{
                           RunAfter(.6f, ^{
                               ygstrongify(self);
                               SPWorkshopUnit *unit = self.workshop.units[indexPath.item];
                               [self showResources:unit];
                           });
                       }],
                       [RWDropdownMenuItem itemWithText:@"打开原始链接" image:nil action:^{
                           RunAfter(.6f, ^{
                               ygstrongify(self);
                               SPWorkshopUnit *unit = self.workshop.units[indexPath.item];
                               [SPWebHelper openURL:unit.detailURL from:self];
                           });
                       }]
                       ];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSInteger item = indexPath.item;
    
    BOOL inLeft = NO;
    if (itemPerRow == 2) {
        inLeft = item % 2 == 1;
    }else if (itemPerRow == 3){
        inLeft = item % 3 == 2;
    }else if (itemPerRow == 4){
        inLeft = item % 4 == 2 || item % 4 == 3;
    }
    
    CGRect rect = CGRectZero;
    UIPopoverArrowDirection direction;
    RWDropdownMenuCellAlignment alignment;
    if (inLeft) {
        rect.origin.x = 0;
        rect.origin.y = CGRectGetHeight(cell.frame)/2;
        direction = UIPopoverArrowDirectionRight;
        alignment = RWDropdownMenuCellAlignmentRight;
    }else{
        rect.origin.x = CGRectGetWidth(cell.frame);;
        rect.origin.y = CGRectGetHeight(cell.frame)/2;
        direction = UIPopoverArrowDirectionLeft;
        alignment = RWDropdownMenuCellAlignmentLeft;
    }
    
    [[SPFocusVisualEffectVC instanceFromStoryboard] showFocusView:cell completion:^(SPFocusVisualEffectVC *focusVC,UIView *focusView) {
        ygweakify(self);
        self.cellFocusVC = focusVC;
        self.cellFocusMenu = [RWDropdownMenu presentInPopoverFromView:focusView position:rect direction:direction align:alignment presentingFrom:focusVC withItems:items completion:nil dismiss:^{
            ygstrongify(self);
            [self.cellFocusVC dismiss];
        }];
    }];
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
