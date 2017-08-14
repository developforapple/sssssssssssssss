//
//  DDViewModel.m
//  QuizUp
//
//  Created by Normal on 16/4/8.
//  Copyright © 2016年 zhenailab. All rights reserved.
//

#import "DDViewModel.h"

@interface DDViewModel ()
@property (assign, readwrite, getter=isEmpty, nonatomic) BOOL empty;
@end

@implementation DDViewModel

+ (instancetype)viewModelWithEntity:(id)entity
{
    return [[[self class] alloc] initWithEntity:entity];
}

- (instancetype)initWithEntity:(id)entity
{
    self = [super init];
    if (self) {
        self->_entity = entity;
    }
    return self;
}

+ (instancetype)empty
{
    DDViewModel *vm = [[[self class] alloc] init];
    vm.empty = YES;
    [vm create];
    return vm;
}

- (void)create
{
//    NSLog(@"子类需要重写方法：%@",NSStringFromSelector(_cmd));
}

- (void)update
{
//    NSLog(@"子类需要重写方法：%@",NSStringFromSelector(_cmd));
}

- (CGFloat)containerHeight
{
//    NSLog(@"子类需要重写方法：%@",NSStringFromSelector(_cmd));
    return 1.5f;
}

- (CGSize)size
{
//    NSLog(@"子类需要重写方法：%@",NSStringFromSelector(_cmd));
    return CGSizeZero;
}

@end
