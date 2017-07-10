//
//  NSArray+YYModelExt.h
//
//  Created by bo wang on 2017/4/21.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import Foundation;

@interface NSArray (YYModelExt)


/**
 返回YYModel对应方法的可变数组

 @param cls cls
 @param json json
 @return NSMutableArray
 */
+ (NSMutableArray *)modelArrayWithClass:(Class)cls json:(id)json;

@end
