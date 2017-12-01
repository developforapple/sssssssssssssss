//
//  ConfigDefines.h
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#ifndef ConfigDefines_h
#define ConfigDefines_h

//0为测试环境 非0为生产环境
#define ProductionEnvironment 1


//0为AppStore版 1为企业版
//修改bundleid后请调整，否则可能出现第三方框架appkey不正确的情况
#define InHouseVersion 1


//只有打包发布到AppStore时才是非debug模式。
#define DEBUG_MODE (DEBUG || InHouseVersion)


// 非debug模式下，服务器环境必须切换到生产环境！
#if !DEBUG_MODE && !ProductionEnvironment
    #error "Release to AppStore need product environment"
#endif

#if ProductionEnvironment && InHouseVersion
    #warning "Are you build for prepare release to AppStore? If not, ignore this warning. If yes, change InHouseVersion to 0."
#endif


#endif /* ConfigDefines_h */
