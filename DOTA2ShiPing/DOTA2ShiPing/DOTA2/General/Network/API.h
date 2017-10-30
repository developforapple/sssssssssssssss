//
//  CDTRequestManager.h
//  CDT
//
//  Created by WangBo (developforapple@163.com) on 2017/6/29.
//  Copyright © 2017年 来电科技 All rights reserved.
//

#import "DDRequestManager.h"

#define API     [CDTRequestManager manager]

@interface CDTRequestManager : DDRequestManager

+ (instancetype)manager;

#pragma mark - Push

/**
 上传推送token
 
 @param token token字符串
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)submitPushToken:(NSString *)token
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail;

/**
 获取推送设置
 
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchPushSetting:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail;

/**
 提交推送开关更改
 
 @param on 开、关
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)submitPushSetting:(BOOL)on
                    success:(DDRespSucBlock)suc
                    failure:(DDRespFailBlock)fail;


#pragma mark - Nearby
/**
 获取经纬度附近的来电列表
 
 @param lat 纬度
 @param lon 经度
 @param itemType 列表类型
 @param sortTime 分页
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)nearbyList:(double)lat
           longitude:(double)lon
                type:(CDTNearbyItemType)itemType
                sort:(long long)sortTime
             success:(DDRespSucBlock)suc
             failure:(DDRespFailBlock)fail;

/**
 搜索经纬度附近的来电列表
 
 @param keywords 关键词
 @param lat 纬度 可以不传
 @param lon 经度 可以不传
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)searchNearbyList:(NSString *)keywords
                  latitide:(NSNumber *)lat
                 longitude:(NSNumber *)lon
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail;

/**
 获取网点详情

 @param sid 网点id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchShopDetail:(NSInteger)sid
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail YG_AVAILABLE(4.1.2,"新增");

/**
 获取终端相关图片

 @param terminal 终端id
 @param terminalType 终端类型。0柜机 1桌面宝
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchTerminalPictures:(NSString *)terminal
                           type:(int)terminalType
                        success:(DDRespSucBlock)suc
                        failure:(DDRespFailBlock)fail YG_AVAILABLE(4.1.2,"新增");

#pragma mark - logic

/**
 获取终端的一些数据
 
 @param terminalId 终端id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)checkTerminalInfo:(NSString *)terminalId
                    success:(DDRespSucBlock)suc
                    failure:(DDRespFailBlock)fail;

/**
 服务端创建支付信息
 
 @param channel 支付渠道
 @param amount 支付金额，分
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)createPayment:(NSString *)channel
                 amount:(NSInteger)amount
                success:(DDRespSucBlock)suc
                failure:(DDRespFailBlock)fail;

/**
 创建租借任务
 
 @param terminalId 终端id
 @param cdbType 0 不带线 1 iPhone线 2 安卓线 3 typeC线
 @param encryptedLevel 加密后的当前电量。使用AES加密。原始字符串为 50_xxx 50为电量。xxx为随机1-3位字符串。
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)createRentTask:(NSString *)terminalId
                 cdbType:(int)cdbType
            batteryLevel:(NSString *)encryptedLevel
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail;

/**
 创建购线任务
 
 @param terminalId 终端id
 @param type 线的类型 CDTLineType
 @param couponId 优惠券id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)createBuyTask:(NSString *)terminalId
               lineType:(NSInteger)type
                 coupon:(NSNumber *)couponId
                success:(DDRespSucBlock)suc
                failure:(DDRespFailBlock)fail;

/**
 查询任务
 
 @param taskId 任务id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)checkTask:(NSInteger )taskId
            success:(DDRespSucBlock)suc
            failure:(DDRespFailBlock)fail;

/**
 获取当前正在进行中的订单

 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchCurrentRecord:(DDRespSucBlock)suc
                     failure:(DDRespFailBlock)fail;

/**
 我的充电宝记录

 @param type 1 已借没还 2 已借已还 3 已购买
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchBorrowedList:(NSInteger)type
                    success:(DDRespSucBlock)suc
                    failure:(DDRespFailBlock)fail;

/**
 归还充电宝

 @param cdbId 充电宝id
 @param terminal 终端id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)returnCDB:(NSString *)cdbId
           terminal:(NSString *)terminal
            success:(DDRespSucBlock)suc
            failure:(DDRespFailBlock)fail;

/**
 归还充电宝任务结果查询

 @param taskId 归还充电宝任务id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)checkReturnTask:(NSString *)taskId
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail;

#pragma mark - User

/**
  请求用户信息
 
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchUserInfo:(DDRespSucBlock)suc
                failure:(DDRespFailBlock)fail;

/**
 获取用户优惠券列表
 
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchCouponList:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail;


/**
 添加优惠券
 
 @param event eventID
 @param code 优惠券编码
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)addCoupon:(NSInteger)event
               code:(NSString *)code
            success:(DDRespSucBlock)suc
            failure:(DDRespFailBlock)fail;

/**
 获取充电宝租借记录列表。每页数据量为kDefaultPageSize
 
 @param sortId 分页的排序id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchCDBRecordList:(NSNumber *)sortId
                     success:(DDRespSucBlock)suc
                     failure:(DDRespFailBlock)fail;

/**
 获取购线记录列表。每页数据量为kDefaultPageSize
 
 @param sortId 分页的排序id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchBuyLineRecordList:(NSNumber *)sortId
                         success:(DDRespSucBlock)suc
                         failure:(DDRespFailBlock)fail;

/**
 获取交易明细列表
 
 @param sortId sortId 分页的排序id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchTradeList:(NSNumber *)sortId
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail;

/**
 获取交易详情
 
 @param tradeId 交易id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchTradeDetail:(NSString *)tradeId
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail;

/**
 获取验证码
 
 @param phone 手机号码
 @param type 类型，0:登录短信验证码 1：登录语音验证码 2：绑定手机
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchAuthCode:(NSString *)phone
                   type:(NSInteger)type
                success:(DDRespSucBlock)suc
                failure:(DDRespFailBlock)fail;

/**
 绑定手机号码
 
 @param phone 手机号码
 @param code 验证码
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)bindPhoneNumber:(NSString *)phone
                     code:(NSString *)code
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail;

/**
 提现
 
 @param amount 提现金额，元
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)submitWithdrawRequest:(float)amount
                        success:(DDRespSucBlock)suc
                        failure:(DDRespFailBlock)fail;

/**
 获取终端广告

 @param terminal 终端id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchTerminalAD:(NSString *)terminal
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail;

#pragma mark - Login

/**
 使用微信登录

 @param wechatCode 微信授权后的code
 @param uuid uuid
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)wechatAuthLogin:(NSString *)wechatCode
                     uuid:(NSString *)uuid
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail;

/**
 上传微信登录信息
 
 @param info info
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)loginUsingWechat:(NSDictionary *)info
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail;

/**
 使用手机登录
 
 @param phone 手机号码
 @param code 验证码
 @param uuid uuid
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)login:(NSString *)phone
           code:(NSString *)code
           uuid:(NSString *)uuid
        success:(DDRespSucBlock)suc
        failure:(DDRespFailBlock)fail;

#pragma mark - 芝麻信用

- (DDTASK)createZhimaURL:(NSString *)terminal
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail;

@end
