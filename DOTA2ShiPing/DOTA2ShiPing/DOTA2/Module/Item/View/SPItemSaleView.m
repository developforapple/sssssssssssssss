//
//  SPItemSaleView.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemSaleView.h"
#import "YGLineView.h"
#import "SPItemSharedData.h"
#import "SPItemPriceLoader.h"
#import "SPWebHelper.h"
#import "SPItemSteamPricesViewCtrl.h"
#import "SPConfigManager.h"
@import ReactiveObjC;
@import ChameleonFramework;

typedef NS_ENUM(NSUInteger, SPItemPlatform) {
    SPItemPlatformDota2,
    SPItemPlatformSteam,
    SPItemPlatformTaobao,
};

@interface SPItemPlatformView : YGLineView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (assign, nonatomic) SPItemPlatform platform;
@property (strong, nonatomic) SPItem *item;
@property (assign, nonatomic) BOOL isNoload;
@end

@implementation SPItemPlatformView

- (void)noload
{
    _isNoload = YES;
    self.errorLabel.hidden = YES;
    [self.loading stopAnimating];
    [self.btn setTitle:@"点击获取价格" forState:UIControlStateNormal];
}

- (void)updatePrice:(__kindof SPItemPriceBase *)priceObject
{
    _isNoload = NO;
    BOOL loading = priceObject == nil;
    self.loading.animating_ = loading;
    
    if (!loading) {
        
        BOOL failed = priceObject.error.length;
        
        self.errorLabel.text = priceObject.error;
        self.errorLabel.hidden = !failed;
        self.btn.hidden = failed;
        
        switch (self.platform) {
            case SPItemPlatformDota2:{
                SPItemDota2Price *price = priceObject;
                if (!failed) {
                    [self.btn setTitle:price.price forState:UIControlStateNormal];
                }
                
            }   break;
            case SPItemPlatformSteam:{
                SPItemSteamPrice *price = priceObject;
                if (!failed) {
                    [self.btn setTitle:price.basePrice forState:UIControlStateNormal];
                }
            }   break;
            case SPItemPlatformTaobao:{
                
            }   break;
        }
    }else{
        self.btn.hidden = YES;
        self.errorLabel.hidden = YES;
    }
}

@end


@interface SPItemSaleView ()
@property (weak, nonatomic) IBOutlet SPItemPlatformView *dota2View;
@property (weak, nonatomic) IBOutlet SPItemPlatformView *steamView;
@property (weak, nonatomic) IBOutlet SPItemPlatformView *taobaoView;
@end

@implementation SPItemSaleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dota2View.platform = SPItemPlatformDota2;
    self.steamView.platform = SPItemPlatformSteam;
    self.taobaoView.platform = SPItemPlatformTaobao;
}

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    self.dota2View.item = itemData.item;
    self.steamView.item = itemData.item;
    self.taobaoView.item = itemData.item;
    [self update];
}

- (void)update
{
    [self updateDota2Price:NO];
    [self updateSteamPrice:NO];
}

- (void)updateDota2Price:(BOOL)forced
{
    if ( forced || Config.sp_config_item_detail_load_price_auto) {
        ygweakify(self);
        [RACObserve(self.itemData, dota2Price)
         subscribeNext:^(id x) {
             ygstrongify(self);
             [self.dota2View updatePrice:self.itemData.dota2Price];
         }];
    }else{
        [self.dota2View noload];
    }
}

- (void)updateSteamPrice:(BOOL)forced
{
    if (forced || Config.sp_config_item_detail_load_price_auto) {
        ygweakify(self);
        [RACObserve(self.itemData, steamPrice)
         subscribeNext:^(id x) {
             ygstrongify(self);
             [self.steamView updatePrice:self.itemData.steamPrice];
         }];
    }else{
        [self.steamView noload];
    }
}

- (IBAction)bgAction:(UIView *)bg
{
    if ([self.dota2View containView:bg]) {
        if (self.dota2View.isNoload) {
            [self.itemData loadDota2Price:YES];
            [self updateDota2Price:YES];
        }else{
            BOOL failed = self.itemData.dota2Price.error.length;
            if (failed) {
                [SVProgressHUD showInfoWithStatus:self.itemData.dota2Price.error];
            }else{
                [SPWebHelper openURL:[NSURL URLWithString:[self.itemData.item dota2MarketURL]] from:self.viewController.navigationController];
            }
        }
    }else if ([self.steamView containView:bg]){
        if (self.steamView.isNoload) {
            [self.itemData loadSteamPrice:YES];
            [self updateSteamPrice:YES];
        }else{
            BOOL failed = self.itemData.steamPrice.error.length;
            if (failed) {
                [SVProgressHUD showInfoWithStatus:self.itemData.steamPrice.error];
            }else{
                SPItemSteamPricesViewCtrl *vc = [SPItemSteamPricesViewCtrl instanceFromStoryboard];
                vc.item = self.itemData.item;
                [self.viewController.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (IBAction)btnAction:(UIButton *)btn
{
    if ([self.dota2View containView:btn]) {
        if (self.dota2View.isNoload) {
            [self.itemData loadDota2Price:YES];
            [self updateDota2Price:YES];
        }else{
            BOOL failed = self.itemData.dota2Price.error.length;
            if (failed) {
                [SVProgressHUD showInfoWithStatus:self.itemData.dota2Price.error];
            }else{
                [SPWebHelper openURL:[NSURL URLWithString:[self.itemData.item dota2MarketURL]] from:self.viewController.navigationController];
            }
        }
    }else if ([self.steamView containView:btn]){
        if (self.steamView.isNoload) {
            [self.itemData loadSteamPrice:YES];
            [self updateSteamPrice:YES];
        }else{
            BOOL failed = self.itemData.steamPrice.error.length;
            if (failed) {
                [SVProgressHUD showInfoWithStatus:self.itemData.steamPrice.error];
            }else{
                [SPWebHelper openURL:[NSURL URLWithString:[self.itemData.item steamMarketURL]] from:self.viewController.navigationController];
            }
        }
    }
}

@end
