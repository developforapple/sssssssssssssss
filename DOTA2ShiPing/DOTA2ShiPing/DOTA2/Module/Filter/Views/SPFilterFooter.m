//
//  SPFilterFooter.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterFooter.h"
#import "SPFilterGroup.h"

NSString *const kSPFilterFooter = @"SPFilterFooter";

@interface SPFilterFooter ()
@property (strong, readwrite, nonatomic) SPFilterGroup *group;
@end

@implementation SPFilterFooter

- (void)configure:(SPFilterGroup *)group
{
    _group = group;
    self.titleLabel.text = group.footerTitle;
}

@end
