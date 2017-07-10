//
//  SPSettingDiskCacheVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/22.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSettingDiskCacheVC.h"
#import "SPDiskCacheControl.h"

#import "DDProgressHUD.h"

@interface SPSettingDiskCacheVC ()
@property (weak, nonatomic) IBOutlet UILabel *workshopImageCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *workshopDataCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemImageCostLabel;

@end

@implementation SPSettingDiskCacheVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadCacheCost];
}

- (void)loadCacheCost
{
    [SPDiskCacheControl workshopImageCacheCost:^(NSInteger cost) {
        RunOnMainQueue(^{
            self.workshopImageCostLabel.text = [self loadDiskCacheCostCompleted:cost];
            [self.tableView reloadData];
        });
    }];
    [SPDiskCacheControl workshopDataCacheCost:^(NSInteger cost) {
        RunOnMainQueue(^{
            self.workshopDataCostLabel.text = [self loadDiskCacheCostCompleted:cost];
            [self.tableView reloadData];
        });
    }];
    [SPDiskCacheControl itemImageCacheCost:^(NSInteger cost) {
        RunOnMainQueue(^{
            self.itemImageCostLabel.text = [self loadDiskCacheCostCompleted:cost];
            [self.tableView reloadData];
        });
    }];
}

- (NSString *)loadDiskCacheCostCompleted:(long long)cost
{
    CGFloat kb = cost/1000.f;
    CGFloat mb = kb/1000.f;
    
    if (mb < 1) {
        return [NSString stringWithFormat:@"%.0fkb",kb];
    }else{
        return [NSString stringWithFormat:@"%.1fMb",mb];
    }
}

#pragma mark - 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清理?" message:@"缓存可以提高加载速度，清理后需要重新下载。" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"清理" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        DDProgressHUD *HUD = [DDProgressHUD showHUDAddedTo:self.view.window animated:YES];
        HUD.mode = MBProgressHUDModeDeterminate;
        HUD.labelText = @"正在清理...";
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            [SPDiskCacheControl cleanWorkshopImageCache:^(int removed, int total) {
                RunOnMainQueue(^{
                    HUD.progress = removed/(float)total;
                });
            } end:^(BOOL suc) {
                RunOnMainQueue(^{
                    [HUD hide:YES];
                    self.workshopImageCostLabel.text = @"0kb";
                    [self.tableView reloadData];
                });
            }];
        }else if (indexPath.section == 0 && indexPath.row == 1){
            [SPDiskCacheControl cleanWorkshopDataCache:^(int removed, int total) {
                RunOnMainQueue(^{
                    HUD.progress = removed/(float)total;
                });
            } end:^(BOOL suc) {
                RunOnMainQueue(^{
                    [HUD hide:YES];
                    self.workshopDataCostLabel.text = @"0kb";
                    [self.tableView reloadData];
                });
            }];
        }else if (indexPath.section == 1 && indexPath.row == 0){
            [SPDiskCacheControl cleanItemImageCache:^(int removed, int total) {
                RunOnMainQueue(^{
                    HUD.progress = removed/(float)total;
                });
            } end:^(BOOL suc) {
                RunOnMainQueue(^{
                    [HUD hide:YES];
                    self.itemImageCostLabel.text = @"0kb";
                    [self.tableView reloadData];
                });
            }];
        }else{
            [HUD hide:YES];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
