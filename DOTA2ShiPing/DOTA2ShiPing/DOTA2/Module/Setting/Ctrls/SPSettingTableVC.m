//
//  SPSettingTableVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/22.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSettingTableVC.h"
#import "SPDiskCacheControl.h"
#import "DDProgressHUD.h"
#import "SPItemListVC.h"
#import "SPHistoryManager.h"
#import "SPStarManager.h"
#import "SPResourceManager.h"
#import "SPUpdateViewCtrl.h"
@import StoreKit;

@interface SPSettingTableVC () <SKStoreProductViewControllerDelegate>

@property (assign, nonatomic) BOOL needUpdateData;
@property (copy, nonatomic) SPResourceManager *manager;

@property (weak, nonatomic) IBOutlet UITableViewCell *updateCell;
@property (weak, nonatomic) IBOutlet UIView *updateIndicator;
@property (weak, nonatomic) IBOutlet UITableViewCell *payCell;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *communityCell;
@property (weak, nonatomic) IBOutlet UILabel *diskCacheLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *appStoreCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *historyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *starredCell;

@end

@implementation SPSettingTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if TARGET_PRO
    self.payLabel.text = @"打赏";
#elif TARGET_AD
    self.payLabel.text = @"去除广告";
#else
    self.payLabel.text = @"内购项目";
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDiskCacheCost];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.updateIndicator.hidden = ![[SPResourceManager manager].needUpdate boolValue];
}

#pragma mark - Cache Cost
- (void)loadDiskCacheCost
{
    __block long long totalCost = 0;
    
    [SPDiskCacheControl workshopImageCacheCost:^(NSInteger cost) {
        totalCost += cost;
        
        [SPDiskCacheControl workshopDataCacheCost:^(NSInteger cost) {
            totalCost += cost;
            
            [SPDiskCacheControl itemImageCacheCost:^(NSInteger cost) {
                totalCost += cost;
                
                [self loadDiskCacheCostCompleted:totalCost];
            }];
            
        }];
    }];
}

- (void)loadDiskCacheCostCompleted:(long long)cost
{
    CGFloat kb = cost/1000.f;
    CGFloat mb = kb/1000.f;
    
    if (mb < 1) {
        self.diskCacheLabel.text = [NSString stringWithFormat:@"%.0fkb",kb];
    }else{
        self.diskCacheLabel.text = [NSString stringWithFormat:@"%.1fMb",mb];
    }
        
    RunOnMainQueue(^{
        [self.tableView reloadData];
    });
}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.appStoreCell) {
        
        DDProgressHUD *HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
        
        NSNumber *AppleID = @([kAppAppleID longLongValue]);
        
        SKStoreProductViewController *skstore = [SKStoreProductViewController new];
        skstore.delegate = self;
        [skstore loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:AppleID}
                           completionBlock:^(BOOL result, NSError *error) {
                               if (result && !error) {
                                   [HUD hideAnimated:YES];
                                   [self presentViewController:skstore animated:YES completion:nil];
                               }else{
                                   [HUD showAutoHiddenHUDWithMessage:error.localizedDescription];
                               }
                           }];
    }else if (cell == self.communityCell){
        
    }else if (cell == self.payCell){
        
    }else if (cell == self.historyCell){
        
        NSArray *tokens = [[SPHistoryManager manager] getHistory:0 pageSize:100];
        SPItemQuery *query = [SPItemQuery queryWithOrderedTokens:tokens];
        query.queryTitle = @"浏览历史";
        SPItemListVC *vc = [SPItemListVC instanceFromStoryboard];
        vc.query = query;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (cell == self.starredCell){
        
        NSArray *tokens = [[SPStarManager manager] getRecord:0 pageSize:100];
        SPItemQuery *query = [SPItemQuery queryWithOrderedTokens:tokens];
        query.queryTitle = @"我的收藏";
        SPItemListVC *vc = [SPItemListVC instanceFromStoryboard];
        vc.query = query;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (cell == self.updateCell){
        ygweakify(self);
        SPUpdateViewCtrl *vc = [SPUpdateViewCtrl instanceFromStoryboard];
        vc.didDismissed = ^(YGBasePopViewCtrl *p) {
            ygstrongify(self);
            self.updateIndicator.hidden = ![[SPResourceManager manager].needUpdate boolValue];
        };
        [vc show];
    }
}

#pragma mark - SKStore
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
