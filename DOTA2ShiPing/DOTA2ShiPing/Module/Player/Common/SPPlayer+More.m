//
//  SPPlayer+More.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayer+More.h"
#import "LCActionSheet.h"
#import "SPPlayerManager.h"

@implementation SPPlayer (More)

- (void)starOrUnstar
{
    BOOL starred = [[SPPlayerManager shared] isStarred:self.steam_id];
    
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:@[starred?@"取消收藏":@"收藏"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            if (!starred) {
                [[SPPlayerManager shared] starPlayer:self];
            }else{
                [[SPPlayerManager shared] unstarPlayer:self.steam_id];
            }
        }
    }];
    sheet.textFont = [UIFont systemFontOfSize:16];
    [sheet show];
}

@end
