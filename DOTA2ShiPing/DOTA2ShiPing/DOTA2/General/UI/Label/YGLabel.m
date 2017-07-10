//
//  YGLabel.m
//
//  Created by WangBo on 2017/4/30.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "YGLabel.h"

@implementation YGLabel

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    
    size.width += self.leftTop.width;
    size.width += self.rightBottom.width;
    size.height += self.leftTop.height;
    size.height += self.rightBottom.height;
    
    return size;
}

- (void)drawTextInRect:(CGRect)rect
{
    rect.origin.x = self.leftTop.width;
    rect.origin.y = self.leftTop.height;
    rect.size.width -= (self.leftTop.width + self.rightBottom.width);
    rect.size.height -= (self.leftTop.height + self.rightBottom.height);
    
    [super drawTextInRect:rect];
}

@end
