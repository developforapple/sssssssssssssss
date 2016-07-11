//
//  SPConstant.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#ifndef SPConstant_h
#define SPConstant_h

#define kSteamAPIKey1 @"CD9010FD71FA1583192F9BDB87ED8164"
#define kSteamAPIKey2 @"D46675A241E560655ABD306C2A275D60"

NS_INLINE NSString *SteamKey(){
    return (arc4random_uniform(10000)%2==0)?kSteamAPIKey1:kSteamAPIKey2;
}

NS_INLINE long long BaseSteamID(){
    return 76561197960265728LL;
}

#endif /* SPConstant_h */
