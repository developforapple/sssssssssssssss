//
//  Macro.h
//
//  Created by WangBo (developforapple@163.com) on 16/5/26.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#ifndef YGCommon_h
#define YGCommon_h

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
    #error "只支持iOS8.0以上版本"
#endif

#define yg_has_include(header) ( __has_include( < header > ) || __has_include( #header ) )

#pragma mark - SDK
// Xcode 版本宏
#if !defined(XCODE_SDK_MACRO)
    #define XCODE_SDK_MACRO

    #define iOS9_SDK_ENABLED  ( defined(__IPHONE_9_0 ) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0  )
    #define iOS10_SDK_ENABLED ( defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 )
    #define iOS11_SDK_ENABLED ( defined(__IPHONE_11_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0 )

#endif

#pragma mark - UI
// UI相关的宏
#if !defined(APP_UI_MACRO)
    #define APP_UI_MACRO

    //当前屏幕宽高，旋转时会变化
    #define Screen_Scale            ([UIScreen mainScreen].scale)
    #define Screen_Width            (CGRectGetWidth([UIScreen mainScreen].bounds))          //当前屏幕宽
    #define Screen_Height           (CGRectGetHeight([UIScreen mainScreen].bounds))         //当前屏幕高

    //设备宽高，旋转时不会变化
    #define Device_Scale            ([UIScreen mainScreen].nativeScale)
    #define Device_Width            (CGRectGetWidth([UIScreen mainScreen].nativeBounds)/Device_Scale)    //设备屏幕宽
    #define Device_Height           (CGRectGetHeight([UIScreen mainScreen].nativeBounds)/Device_Scale)    //设备屏幕高

    //状态栏高度，一般为20，在iPhoneX上是44，隐藏状态栏时为0
    #define StatusBar_Height        (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

    #define IS_Phone_UI             (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    #define IS_Pad_UI               (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

    #define IS_3_5_INCH_SCREEN      (IS_Phone_UI && ((int)Device_Width==320) && ((int)Device_Height==480))
    #define IS_4_0_INCH_SCREEN      (IS_Phone_UI && ((int)Device_Width==320) && ((int)Device_Height==568))
    #define IS_4_7_INCH_SCREEN      (IS_Phone_UI && ((int)Device_Width==375) && ((int)Device_Height==667))
    #define IS_5_5_INCH_SCREEN      (IS_Phone_UI && ((int)Device_Width==414) && ((int)Device_Height==736))
    #define IS_5_8_INCH_SCREEN      (IS_Phone_UI && ((int)Device_Width==375) && ((int)Device_Height==812))
#endif  //APP_UI_MACRO

#pragma mark - Device
// 设备系统相关的宏
#if !defined(APP_DEVICE_MACRO)
    #define APP_DEVICE_MACRO

    #define Device_SysVersionStr    ([UIDevice currentDevice].systemVersion)
    #define Device_SysVersion       ([UIDevice currentDevice].systemVersion.doubleValue)
    #define Device_SysName          ([UIDevice currentDevice].systemName)
    #define Device_Model            ([UIDevice currentDevice].model)

    #if (yg_has_include(FCUUID.h))
        #define Device_UUID    ([FCUUID uuidForDevice])
    #else
        #define Device_UUID @""
    #endif

    #if (yg_has_include(UIDevice+Ext.h))
        #define Device_Hardware     ([UIDevice hardwareName])
    #else
        #define Device_Hardware @""
    #endif

    //设备类型
    #if (yg_has_include(UIDevice+Ext.h))
        #define IS_Simulator ([UIDevice hardwareIsSimulator])
    #else
        #define IS_Simulator NO
    #endif

    #define IS_iPhone               (NSNotFound != [Device_Model rangeOfString:@"iPhone"].location)
    #define IS_iPad                 (NSNotFound != [Device_Model rangeOfString:@"iPad"].location)
    #define IS_iPod                 (NSNotFound != [Device_Model rangeOfString:@"iPod"].location)

    #if iOS11_SDK_ENABLED
        #define iOSLater(v)             @available(iOS v, *)
        #define iOS7                    @available(iOS 7.0, *)
        #define iOS8                    @available(iOS 8.0, *)
        #define iOS9                    @available(iOS 9.0, *)
        #define iOS10                   @available(iOS 10.0, *)
        #define iOS11                   @available(iOS 11.0, *)

        #define IS_iOS7                 (Device_SysVersion >= 7.0 && (Device_SysVersion < 8.0))
        #define IS_iOS8                 (Device_SysVersion >= 8.0 && (Device_SysVersion < 9.0))
        #define IS_iOS9                 (Device_SysVersion >= 9.0 && (Device_SysVersion < 10.0))
        #define IS_iOS10                (Device_SysVersion >= 10.0 && (Device_SysVersion < 11.0))
        #define IS_iOS11                (Device_SysVersion >= 11.0 && (Device_SysVersion < 12.0))
    #else
        #define iOSLater(v)             (Device_SysVersion >= (float)(v))
        #define iOS7                    (Device_SysVersion >= 7.0)
        #define iOS8                    (Device_SysVersion >= 8.0)
        #define iOS9                    (Device_SysVersion >= 9.0)
        #define iOS10                   (Device_SysVersion >= 10.0)
        #define iOS11                   (Device_SysVersion >= 11.0)

        #define IS_iOS7                 (iOS7 && !iOS8)
        #define IS_iOS8                 (iOS8 && !iOS9)
        #define IS_iOS9                 (iOS9 && !iOS10)
        #define IS_iOS10                (iOS10 && !iOS11)
        #define IS_iOS11                (iOS11)
    #endif

#endif  //APP_DEVICE_MACRO

#pragma mark - Bundle
// app包相关宏
#if !defined(APP_BUNDLE_MACRO)
    #define APP_BUNDLE_MACRO

    #define AppBundle           ([NSBundle mainBundle])
    #define AppBundleID         ([AppBundle bundleIdentifier])
    #define AppDisplayName      ([AppBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"])
    #define AppVersion          ([AppBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
    #define AppBuildVersion     ([AppBundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey])
    #define AppResource(name)   ([AppBundle pathForResource:name ofType:nil])

    #define AppVersionMajor     ([AppVersion componentsSeparatedByString:@"."].firstObject.integerValue)
    #define AppVersionMinor     ([AppVersion componentsSeparatedByString:@"."][1].integerValue)
    #define AppVersionPatch     ([AppVersion componentsSeparatedByString:@"."].lastObject.integerValue)

#endif //APPBUNDLE_MACRO

#pragma mark - Sandbox
// app沙盒相关宏
#if !defined(APP_SANDBOX_MACRO)
    #define APP_SANDBOX_MACRO

    #define FileManager         [NSFileManager defaultManager]
    #define AppSandboxPath      (NSHomeDirectory())
    #define AppDocumentsPath    (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject)
    #define AppLibraryPath      (NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject)
    #define AppCachesPath       (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject)
    #define AppTmpPath          (NSTemporaryDirectory())
#endif  //APP_SANDBOX_MACRO

#pragma mark - Convenient

#if !DEBUG_MODE
    #define NSLog(...)
#endif

// 其他便利的宏
#if !defined(APP_CONVENIENT_MACRO)
    #define APP_CONVENIENT_MACRO

    // 确保在max和min确定的范围内取值
    #define Confine(value,maxV,minV) (MAX((minV),MIN((maxV),(value))))

    #define RGBColor(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
    #define RandomColor RGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),1)

    #if yg_has_include(UIColor+YYAdd.h)
        #define HEXColor(hex) [UIColor colorWithHexString:hex];
    #endif

    #define IndexPathMake(section,row) [NSIndexPath indexPathForRow:(row) inSection:(section)]

    #define URLMake(string) ([NSURL URLWithString:string])

    #define TIMESTAMP ([[NSDate date] timeIntervalSince1970])

    #ifndef yes
        #define yes YES
    #endif

    #ifndef no
        #define no NO
    #endif

#endif //APP_CONVENIENT_MACRO


#if !defined(YYModelDefaultCode) && yg_has_include(YYModel.h)
    // YYModel 实现 NSCoding NSCopying hash euqal的方法
    #define YYModelDefaultCode \
        -(void)encodeWithCoder:(NSCoder*)aCoder{[self yy_modelEncodeWithCoder:aCoder];}-(id)initWithCoder:(NSCoder*)aDecoder{self=[super init];return [self yy_modelInitWithCoder:aDecoder];}-(id)copyWithZone:(NSZone *)zone{return[self yy_modelCopy]?:nil;}-(NSUInteger)hash{return[self yy_modelHash];}-(BOOL)isEqual:(id)object{return [self yy_modelIsEqual:object];}
#endif

#if !defined(YGSwizzleMethod)
    // 快速添加方法转换的类方法
    #define YGSwizzleMethod \
        +(void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector{Method originalMethod = class_getInstanceMethod(self, originalSelector);Method newMethod = class_getInstanceMethod(self, newSelector);BOOL methodAdded = class_addMethod([self class],originalSelector,method_getImplementation(newMethod),method_getTypeEncoding(newMethod));if (methodAdded){class_replaceMethod([self class],newSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));}else{method_exchangeImplementations(originalMethod, newMethod);}}
#endif

#pragma mark - Block weakify

// weakify 宏
#if !defined(APP_WEAKIFY_MACRO)
    #define APP_WEAKIFY_MACRO

    #define RAC_INCLUDE (yg_has_include(ReactiveCocoa.h) || yg_has_include(ReactiveObjC.h) )
    #define EXT_INCLUDE (yg_has_include(EXTScope.h))
    #define IFY_DEFINED (RAC_INCLUDE || EXT_INCLUDE)
    #define YYC_INCLUDE (yg_has_include(YYCategoriesMacro.h))

    #if IFY_DEFINED && YYC_INCLUDE
    // RAC 和 YY 同时存在时会发生冲突

        #if RAC_INCLUDE
            #include "RACEXTScope.h"
        #elif EXT_INCLUDE
            #include "EXTScope.h"
        #elif YYC_INCLUDE
            #include "YYCategoriesMacro.h"
        #endif

        #define ygstrongify(...) \
            @rac_keywordify \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Wshadow\"") \
            metamacro_foreach(rac_strongify_,, __VA_ARGS__) \
            _Pragma("clang diagnostic pop")

        #define ygweakify(...) \
            @rac_keywordify \
            metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)

    #elif IFY_DEFINED || YYC_INCLUDE

        #define ygweakify(...) @weakify(__VA_ARGS__)
        #define ygstrongify(...) @strongify(__VA_ARGS__)

    #else

        #if DEBUG
            #define ygweakify(object) @autoreleasepool{} __weak __typeof__(object) weak##_##object = object
            #define ygstrongify(object) @autoreleasepool{} __typeof__(object) object = weak##_##object
        #else
            #define ygweakify(object) @try{} @finally{} {} __weak __typeof__(object) weak##_##object = object
            #define ygstrongify(object) @try{} @finally{} __typeof__(object) object = weak##_##object
        #endif

    #endif

    #define bingoWeakify(...)   ygweakify(__VA_ARGS__)
    #define bingoStrongify(...) ygstrongify(__VA_ARGS__)

#endif  //APP_WEAKIFY_MACRO


#endif /* YGCommon_h */

