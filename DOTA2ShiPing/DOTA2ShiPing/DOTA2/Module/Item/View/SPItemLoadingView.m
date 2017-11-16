//
//  SPItemLoadingView.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemLoadingView.h"
#import "SPItemSharedData.h"
#import "SPConfigManager.h"
@import ReactiveObjC;

@interface SPItemLoadingView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (assign, nonatomic) BOOL noload;
@end

@implementation SPItemLoadingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (Config.sp_config_item_detail_show_loading_tips) {
        self.descLabel.text = @"正在抓取数据，点击查看详情";
    }else{
        self.descLabel.text = nil;
    }
}

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    
    [self update];
}

- (void)update
{
    if (Config.sp_config_item_detail_load_extra_data_auto) {
        [self ovserveExtraData];
    }else{
        self.noload = YES;
        [self updateLoadingView];
    }
}

- (void)ovserveExtraData
{
    self.noload = NO;
    ygweakify(self);
    [RACObserve(self.itemData, extraData)
     subscribeNext:^(id x) {
         ygstrongify(self);
         [self updateLoadingView];
     }];
    
}

- (void)updateLoadingView
{
    if (self.noload) {
        self.loading.animating_ = NO;
        self.descLabel.hidden = YES;
        [self.btn setTitle:@"点击获取更多内容" forState:UIControlStateNormal];
    }else{
        self.loading.animating_ = YES;
        self.descLabel.hidden = NO;
        [self.btn setTitle:nil forState:UIControlStateNormal];
        
        if (self.itemData.extraData) {
            [self setCollapsed:YES animated:YES];
            [self setHidden:YES animated:YES];
            if (self.itemData.extraData.error) {
                [SVProgressHUD showErrorWithStatus:self.itemData.extraData.error.localizedDescription];
            }
        }
    }
}

- (IBAction)btnAction:(id)sender
{
    if (self.noload) {
        [self.itemData loadExtraData:YES];
        [self ovserveExtraData];
    }else{
        //    Config.sp_config_item_detail_show_loading_tips = NO; //TODO
        [UIAlertController alert:@"正在从Dota2Wiki抓取更多相关内容，请稍等" message:@"应用设置中可关闭自动抓取"];
    }
}



@end
