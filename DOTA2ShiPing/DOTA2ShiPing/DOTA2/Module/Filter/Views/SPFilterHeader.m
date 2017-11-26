//
//  SPFilterHeader.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterHeader.h"
#import "SPFilterGroup.h"

NSString *const kSPFilterHeader = @"SPFilterHeader";

@interface SPFilterHeader ()
@property (strong, readwrite, nonatomic) SPFilterGroup *group;
@end

@implementation SPFilterHeader

- (void)configure:(SPFilterGroup *)group
{
    _group = group;
    self.titleLabel.text = group.headerTitle;
}

@end
