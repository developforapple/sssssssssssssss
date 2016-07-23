//
//  SPSettingTableVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/22.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSettingTableVC.h"
#import "SPDiskCacheControl.h"
#import "SPMacro.h"
#import "DDProgressHUD.h"
#import "UMCommunity.h"
#import <StoreKit/StoreKit.h>

@interface SPSettingTableVC () <SKStoreProductViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *communityCell;
@property (weak, nonatomic) IBOutlet UILabel *diskCacheLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *appStoreCell;

@end

@implementation SPSettingTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDiskCacheCost];
    
    self.navigationController.navigationBar.barTintColor = AppBarColor;
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
    
    RunOnMain(^{
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
        
        SKStoreProductViewController *skstore = [SKStoreProductViewController new];
        skstore.delegate = self;
        [skstore loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:APPIDNum}
                           completionBlock:^(BOOL result, NSError *error) {
                               if (result && !error) {
                                   [HUD hide:YES];
                                   [self presentViewController:skstore animated:YES completion:nil];
                               }else{
                                   [HUD showAutoHiddenHUDWithMessage:error.localizedDescription];
                               }
                           }];
    }else if (cell == self.communityCell){
//        UIViewController *community = [UMCommunity getFeedsModalViewController];
//        [self.navigationController presentViewController:community animated:YES completion:nil];
        
        UIViewController *community = [UMCommunity getFeedsViewController];
        community.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:community animated:YES];
    }
}

#pragma mark - SKStore
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"123");
}

@end
