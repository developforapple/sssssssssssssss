//
//  Deploy.h
//  DOTA2ShiPing
//
//  Created by Jay on 2018/1/5.
//  Copyright © 2018年 wwwbbat. All rights reserved.
//

#ifndef Deploy_h
#define Deploy_h

typedef NS_ENUM(NSUInteger, YGAppDeploy) {
    YGAppDeployProduction = 0,  // 生产版本 version >= min && version <= max
    YGAppDeployReview,          // 审核版本 version > max && version <= latest
    YGAppDeployDev,             // 开发版本 version > latest
    YGAppDeployObsolete,        // 废弃版本 version < min
};

YG_INLINE NSString *deploy_desc(YGAppDeploy deploy){
    switch (deploy) {
        case YGAppDeployProduction: return @"上线版本";
        case YGAppDeployReview: return @"审核版本";
        case YGAppDeployDev:    return @"开发版本";
        case YGAppDeployObsolete:   return @"废弃版本";
    }
    return @"";
}

#endif /* Deploy_h */
