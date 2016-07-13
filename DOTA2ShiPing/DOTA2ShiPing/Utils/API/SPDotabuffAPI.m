//
//  SPDotabuffAPI.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPDotabuffAPI.h"
#import "SPMacro.h"
#import "SPPlayer.h"
#import "TFHpple.h"

@implementation SPDotabuffAPI

+ (void)searchUser:(NSString *)keywords
        completion:(void (^)(BOOL suc, NSArray *list, NSString *msg)) completion
{
    if (!completion) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://zh.dotabuff.com/search?utf8=✓&q=%@",keywords];
    
    RunOnSubThread(^{
    
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        if (!data) {
            RunOnMain(^{
                completion(NO,nil,@"网络错误");
            });
            return ;
        }
        
        TFHpple *hpple = [TFHpple hppleWithHTMLData:data];
        NSArray *divNodes = [hpple searchWithXPathQuery:@"//div[@class='result result-player']"];
        
        if (!divNodes) {
            RunOnMain(^{
                completion(NO,nil,@"出错了!");
            });
            return;
        }
        
        NSMutableArray *result = [NSMutableArray array];
        
        for (TFHppleElement *div in divNodes) {
            TFHppleElement *inner = [div firstChildWithTagName:@"div"];
            NSString *playerId = inner.attributes[@"data-player-id"];
            if (!playerId) {
                playerId = [inner.attributes[@"data-link-to"] lastPathComponent];
            }
            
            TFHppleElement *imgNode = [[[[inner firstChildWithClassName:@"avatar"] firstChildWithTagName:@"div"] firstChildWithTagName:@"a"] firstChildWithTagName:@"img"];
            NSString *playerName = imgNode.attributes[@"title"];
            NSString *playerAvater = imgNode.attributes[@"src"];
            
            SPPlayer *player = [[SPPlayer alloc] init];
            player.name = playerName;
            player.avatar_url = playerAvater;
            player.steam_id = @(playerId.integerValue);
            [result addObject:player];
        }
        
        RunOnMain(^{
           completion(YES,result,nil); 
        });
    });
}

@end
