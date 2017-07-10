//
//  ZMBRequestManager.h
//  CDT
//
//  Created by wwwbbat on 2017/6/29.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "DDRequestManager.h"

#define ZMBAPI  [ZMBRequestManager zmbManager]

@interface ZMBRequestManager : DDRequestManager

+ (instancetype)zmbManager;

/**
 获取桌面宝充电记录。每页数据量为kDefaultPageSize
 
 @param sortId 上一页的排序id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchZMBRecordList:(NSNumber *)sortId
                     success:(DDRespSucBlock)suc
                     failure:(DDRespFailBlock)fail;

/**
 结束桌面宝充电。
 
 @param chargeId 充电记录id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)endZMBCharge:(NSString *)chargeId
               success:(DDRespSucBlock)suc
               failure:(DDRespFailBlock)fail;

/**
 创建桌面宝充电订单
 
 @param terminal 终端id
 @param data 加密数据
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)beginZMBCharge:(NSString *)terminal
            encrytedData:(NSString *)data
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail;

/**
 支付桌面宝充电订单
 
 @param chargeId 充电记录id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)payForZMBOrder:(NSString *)chargeId
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail;

/**
 桌面宝问题列表
 
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchZMBTroubleList:(DDRespSucBlock)suc
                      failure:(DDRespFailBlock)fail;

/**
 桌面宝遇到问题
 
 @param troubleid 问题id
 @param terminalId 桌面宝id
 @param remark 问题描述
 @param recordId 充电记录id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)submitZMBTrouble:(NSString *)troubleid
                  terminal:(NSString *)terminalId
                    remark:(NSString *)remark
                  recordId:(NSString *)recordId
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail;

/**
 获取桌面宝终端信息
 
 @param terminalId 终端id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchZMBTerminal:(NSString *)terminalId
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail;

/**
 获取桌面宝充电记录详情
 
 @param recordId 记录id
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)fetchZMBRecord:(NSString *)recordId
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail;

/**
 构建桌面宝支付数据
 
 @param channel 支付平台
 @param bizId  桌面宝订单id
 @param amount 金额，单位分
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)createZMBPayment:(NSString *)channel
                     bizId:(NSString *)bizId
                    amount:(NSInteger)amount
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail;

@end
