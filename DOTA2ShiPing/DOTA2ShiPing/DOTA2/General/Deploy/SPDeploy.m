//
//  SPDeploy.m
//  SPDev
//
//  Created by wwwbbat on 2018/1/6.
//  Copyright © 2018年 wwwbbat. All rights reserved.
//

#import "SPDeploy.h"
@import AVOSCloud;

static NSString *kSPDeploySaveKey = @"sp_deploy";

@interface SPDeploy ()
@property (strong, nonatomic) AVQuery *query;
@end

@implementation SPDeploy

+ (instancetype)instance
{
    static SPDeploy *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SPDeploy new];
        instance.deploy = [[NSUserDefaults standardUserDefaults] integerForKey:kSPDeploySaveKey];
    });
    return instance;
}

- (void)update
{
    ygweakify(self);
    self.query = [AVQuery queryWithClassName:@"Availability"];
    [self.query whereKey:@"Key" equalTo:AppBundleID];
    [self.query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        ygstrongify(self);
        
        if (error || !object){
            
            self.error = error;
            self.success = NO;
            self.deploy = YGAppDeployProduction;
            self.finish = YES;
            
            SPLog(@"查询版本出错！");
            return ;
        }
        
        id minV = [object objectForKey:@"MinVersion"];
        id maxV = [object objectForKey:@"MaxVersion"];
        id latestV = [object objectForKey:@"LatestVersion"];
        
        SPLog(@"当前app版本：%@",AppBuildVersion);
        SPLog(@"最小支持版本：%@",minV);
        SPLog(@"最大线上版本：%@",maxV);
        SPLog(@"最新的版本：%@",latestV);
        
        if ([minV respondsToSelector:@selector(integerValue)]){
            self.minVersion = [minV integerValue];
        }
        if ([maxV respondsToSelector:@selector(integerValue)]){
            self.maxVersion = [maxV integerValue];
        }
        if ([latestV respondsToSelector:@selector(integerValue)]) {
            self.latestVersion = [latestV integerValue];
        }
        
        self.success = self.maxVersion > 0 && self.latestVersion > 0;
        
        NSInteger curVersion = [AppBuildVersion integerValue];
        
        if (curVersion < self.minVersion) {
            self.deploy = YGAppDeployObsolete;
        }else if (curVersion <= self.maxVersion){
            self.deploy = YGAppDeployProduction;
        }else if (curVersion <= self.latestVersion){
            self.deploy = YGAppDeployReview;
        }else{
            self.deploy = YGAppDeployDev;
        }
        
        [[NSUserDefaults standardUserDefaults] setInteger:self.deploy forKey:kSPDeploySaveKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        SPLog(@"当前运行环境：%@",deploy_desc(self.deploy));
        
        self.error = nil;
        self.finish = YES;
        self.query = nil;
        
        if (self.deploy == YGAppDeployObsolete) {
            RunAfter(10.f, ^{
                [UIAlertController alert:@"应用版本过低，请及时更新" message:@"现在打开 AppStore 下载更新" callback:^{
                    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",kAppAppleID];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    RunAfter(2.f, ^{
                        //让app crash
                        [self performSelector:@selector(aCrashSelector:)];
                    });
                }];
            });
        }
    }];
}

@end
