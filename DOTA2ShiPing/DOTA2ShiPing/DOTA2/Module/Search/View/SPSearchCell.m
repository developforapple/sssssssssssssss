//
//  SPSearchCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSearchCell.h"
#import "SPPlayer.h"
#import "SPPlayerManager.h"
#import "YYWebImage.h"
#import "LCActionSheet.h"
#import "UIViewController+Storyboard.h"
#import "DDProgressHUD.h"
#import "SPSteamAPI.h"

#import "SPPlayer+More.h"

@interface SPSearchCell ()
{
    BOOL _isUserCell;
}
@property (strong, nonatomic) SPPlayer *user;
@end

@implementation SPSearchCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.spImageView.layer.masksToBounds = YES;
    self.spImageView.layer.cornerRadius = 6.f;
}

- (void)configureWithText:(NSString *)text
{
    _isUserCell = NO;
    self.spTextLabel.text = text;
    self.spDetailTextLabel.hidden = YES;
    self.spImageView.hidden = YES;
    self.spImageViewWidthConstraint.constant = 0.f;
}

- (void)configureWithUser:(SPPlayer *)user
{
    _isUserCell = YES;
    self.user = user;
    self.spTextLabel.text = user.name;
    self.spDetailTextLabel.text = user.steam_id.description;
    
    [self.spImageView yy_setImageWithURL:[NSURL URLWithString:user.avatar_url] placeholder:[UIImage imageNamed:@"first"] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
}

//- (void)loadPlayerItems
//{
//    NSDate *updateDate = [[SPPlayerManager shared] archivedPlayerInventoryUpdateDate:self.user];
//    if (updateDate) {
//        NSLocale *local = [NSLocale currentLocale];
//        NSString *dateString = [updateDate descriptionWithLocale:local];
//        NSString *title = [NSString stringWithFormat:@"上次更新：\n%@",dateString];
//        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:title buttonTitles:@[@"更新",@"不更新"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
//            if (buttonIndex == 0) {
//                [self loadLatestInventoryData];
//            }else if(buttonIndex == 1){
//                [self showInventory:self.user];
//            }
//        }];
//        [sheet setTextFont:[UIFont systemFontOfSize:16]];
//        [sheet show];
//    }else{
//        [self loadLatestInventoryData];
//    }
//}
//
//#pragma mark - Inventory
//- (void)loadLatestItemListData
//{
//    DDProgressHUD *HUD = [DDProgressHUD showHUDAddedTo:self.window animated:YES];
//    
//    ygweakify(self);
//    [[SPPlayerManager shared] fetchItemList:self.user completion:^(BOOL suc, NSString *msg) {
//        ygstrongify(self);
//        if (suc) {
//            [self loadLatestInventoryData];
//        }else{
//            [HUD showAutoHiddenHUDWithMessage:msg];
//        }
//    }];
//}

@end


NSString *const kSPSearchCell = @"SPSearchCell";
