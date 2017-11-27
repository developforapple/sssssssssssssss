//
//  SPBaseFilter.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPFilterDelegate.h"
#import "SPFilterGroup.h"
#import "SPFilterConfig.h"
#import "SPFilterDefine.h"

@class SPFilterViewCtrl;

@interface SPBaseFilter : SPObject

@property (weak, nonatomic) SPFilterViewCtrl *filterViewCtrl;

@property (weak, nonatomic) id<SPFilterDelegate> delegate;

@property (strong, nonatomic) NSArray<__kindof SPFilterGroup *> *groups;

@property (strong, nonatomic) SPFilterConfig *config;

- (instancetype)initWithConfig:(SPFilterConfig *)config;

@property (strong, nonatomic) NSArray *activatedUnits;


// 可输入的unit输入内容发生了变化
- (void)didChangedInputText:(NSString *)text
                     toUnit:(__kindof SPFilterUnit *)unit
                    atGroup:(__kindof SPFilterGroup *)group;
// 可选择的unit被选择了
- (void)didSelectedUnit:(__kindof SPFilterUnit *)unit
                atGroup:(__kindof SPFilterGroup *)group;
// 可选择的unit被取消选择了
- (void)didDeselectedUnit:(__kindof SPFilterUnit *)unit
                  atGroup:(__kindof SPFilterGroup *)group;

- (void)updateGroup:(SPFilterGroup *)group;
- (void)appendUnit:(SPFilterUnit *)unit toGroup:(SPFilterGroup *)group;
- (void)insertUnit:(SPFilterUnit *)unit toGroup:(SPFilterGroup *)group atIndex:(NSInteger)index;
- (void)removeUnit:(SPFilterUnit *)unit;
- (void)moveUnit:(SPFilterUnit *)unit toIndex:(NSInteger)index;

- (void)selectUnit:(SPFilterUnit *)unit;
- (void)deselectUnit:(SPFilterUnit *)unit;

- (NSArray<SPFilterUnit *> *)unitsOfKind:(SPFilterKind)kind;

@end
