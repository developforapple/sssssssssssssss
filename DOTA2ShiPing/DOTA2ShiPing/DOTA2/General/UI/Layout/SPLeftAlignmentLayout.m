//
//  SPLeftAlignmentLayout.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPLeftAlignmentLayout.h"

@implementation SPLeftAlignmentLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maximumInteritemSpacing = 8;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.maximumInteritemSpacing = 8;
    }
    return self;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    CGFloat maxWidth = self.collectionViewContentSize.width - self.sectionInset.left - self.collectionView.contentInset.left - self.sectionInset.right - self.collectionView.contentInset.right;
    if (attributes.size.width > maxWidth) {
        CGSize size = attributes.size;
        size.width = maxWidth;
        attributes.size = size;
    }
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //使用系统帮我们计算好的结果。
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGSize contentSize = [self collectionViewContentSize];
    
    CGFloat leftMargin = self.sectionInset.left + self.collectionView.contentInset.left;
    CGFloat rightMargin = self.sectionInset.right + self.collectionView.contentInset.right;
    
    //第0个cell没有上一个cell，所以从1开始
    for(int i = 1; i < [attributes count]; ++i) {
        //这里 UICollectionViewLayoutAttributes 的排列总是按照 indexPath的顺序来的。
        UICollectionViewLayoutAttributes *curAttr = attributes[i];
        UICollectionViewLayoutAttributes *preAttr = attributes[i-1];
        
        NSInteger origin = CGRectGetMaxX(preAttr.frame);
        //根据  maximumInteritemSpacing 计算出的新的 x 位置
        CGFloat targetX = origin + _maximumInteritemSpacing;
        
        if (targetX + CGRectGetWidth(curAttr.frame) + rightMargin <= contentSize.width) {
            // 同一行
            if (CGRectGetMinX(curAttr.frame) > targetX) {
                CGRect frame = curAttr.frame;
                frame.origin.x = targetX;
                curAttr.frame = frame;
            }
        }else{
            // 不同行
            if (CGRectGetMinX(curAttr.frame) > leftMargin){
                CGRect frame = curAttr.frame;
                frame.origin.x = self.collectionView.contentInset.left;
                curAttr.frame = frame;
            }
            
        }
    }
    return attributes;
}

@end
