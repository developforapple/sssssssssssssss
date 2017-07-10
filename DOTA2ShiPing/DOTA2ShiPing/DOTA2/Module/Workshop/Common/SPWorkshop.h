//
//  SPWorkshop.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/16.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPWorkshopModel.h"

#pragma mark - Workshop
@interface SPWorkshop : NSObject

@property (strong, readonly, nonatomic) NSArray<SPWorkshopUnit *> *units;     //当前内容
@property (assign, readonly, nonatomic) BOOL isCacheData;   //当前是否是缓存数据
@property (assign, readonly, nonatomic) BOOL noMoreData;    //当前是否还有更多数据
@property (strong, readonly, nonatomic) SPWorkshopQuery *query;
@property (assign, readonly, nonatomic) NSUInteger pageSize;  //每页数量 默认9
@property (assign, readonly, nonatomic) NSUInteger pageNo;    //当前页码 默认1

/**
 *  数据更新的回调
 */
@property (copy, nonatomic) void (^updateCallback)(BOOL suc, BOOL isMore);
/**
 *  请求进度回调
 */
@property (copy, nonatomic) void (^progressCallback)(float progress);


#pragma mark - Load
/**
 *  加载section的内容。将清空其他条件。
 *
 *  @param section section
 *  @param ignore  是否要忽略缓存
 */
- (void)loadWorkshopSection:(SPWorkshopSection)section ignoreCache:(BOOL)ignore;
/**
 *  根据排序规则加载内容
 *
 *  @param sort 排序规则
 */
- (void)sort:(SPWorkshopSort *)sort;
/**
 *  使用标签过滤
 *
 *  @param tags 标签
 */
- (void)filter:(NSArray<SPWorkshopTag *> *)tags;
/**
 *  加载更多，page+1
 */
- (void)loadMore;

#pragma mark - Section
/**
 *  section对应的标题
 *
 *  @param section section
 *
 *  @return 标题
 */
+ (NSString *)sectionVisiblaTitle:(SPWorkshopSection)section;
/**
 *  section对应的query值
 *
 *  @param section section
 *
 *  @return 值
 */
+ (NSString *)sectionQueryValue:(SPWorkshopSection)section;

#pragma mark Tag
/**
 *  seciton下的所有tag分类
 *
 *  @param section seciton类型
 *
 *  @return tag分类
 */
+ (NSMutableArray<NSDictionary<NSString *, NSArray<SPWorkshopTag *> *> *> *)tagsOfSection:(SPWorkshopSection)section;

#pragma mark - Detail
+ (void)fetchResource:(SPWorkshopUnit *)unit
           completion:(void(^)(BOOL suc, SPWorkshopUnit *unit))completion;

@end

