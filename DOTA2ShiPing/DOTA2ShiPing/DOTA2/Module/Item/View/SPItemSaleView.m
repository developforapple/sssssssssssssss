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
@end

@implementation SPItemPlatformView

- (void)updatePrice:(__kindof SPItemPriceBase *)priceObject
{
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

- (IBAction)btnAction:(id)sender
{
    
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
    [self update];
}

- (void)update
{
    ygweakify(self);
    [RACObserve(self.itemData, dota2Price)
     subscribeNext:^(id x) {
         ygstrongify(self);
         [self.dota2View updatePrice:self.itemData.dota2Price];
     }];
    [RACObserve(self.itemData, steamPrice)
     subscribeNext:^(id x) {
         ygstrongify(self);
         [self.steamView updatePrice:self.itemData.steamPrice];
     }];
}

@end
