//
//  ViewController.m
//  SPUpdater
//
//  Created by Jay on 2017/12/5.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import "ViewController.h"
#import "SPUpdater.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSTextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[SPUpdater updater] setLogOutputTextView:self.textView];
    [[SPUpdater updater] start];
    
    //    // 下载图片。需要先生成数据库
    //    [SPItemImageDownloader compressImages];
    //    [SPItemImageDownloader download:@"/Users/wangbo/Desktop/DOTA.tmp/basedata/item.db"];
    //    return;
    
    //    // 下载英雄头像
    //    [SPHeroImageDownloader downloadImages];
    //    return;
}

@end
