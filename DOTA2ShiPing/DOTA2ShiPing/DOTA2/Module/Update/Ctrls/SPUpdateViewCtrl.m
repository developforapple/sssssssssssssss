//
//  SPUpdateViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/13.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPUpdateViewCtrl.h"
#import "SPResourceManager.h"

@interface SPUpdateViewCtrl ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (strong, nonatomic) SPResourceManager *manager;

@end

@implementation SPUpdateViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([SPResourceManager needInitializeDatabase]) {
        self.stateLabel.text = @"首次使用，需要下载基础数据";
    }else{
        self.stateLabel.text = @"正在获取更新信息";
    }
    self.progressLabel.text = @"";
    
    self.manager = [[SPResourceManager alloc] init];
    
    [self checkUpdate];
}

- (void)checkUpdate
{
    
}

@end
