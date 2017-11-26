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

    for (NSInteger i=0; i<[attributes count]; i++) {

        CGRect fixedFrame;

        UICollectionViewLayoutAttributes *curAttr = attributes[i];
        if (curAttr.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }


        if (curAttr.indexPath.item == 0) {
            fixedFrame = curAttr.frame;
            fixedFrame.origin.x = leftMargin;
            curAttr.frame = fixedFrame;
            continue;
        }

        if(i > 0){
            UICollectionViewLayoutAttributes *preAttr = attributes[i-1];

            if (curAttr.indexPath.section != preAttr.indexPath.section) {
                fixedFrame = curAttr.frame;
                fixedFrame.origin.x = leftMargin;
                curAttr.frame = fixedFrame;
                continue;
            }

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
                    frame.origin.x = leftMargin;
                    curAttr.frame = frame;
                }

            }
        }

    }

    return attributes;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes
{
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForPreferredLayoutAttributes:preferredAttributes withOriginalAttributes:originalAttributes];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i=0; i<self.collectionView.numberOfSections; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:0 inSection:i]];
    }
    
    [context invalidateSupplementaryElementsOfKind:UICollectionElementKindSectionHeader atIndexPaths:indexPaths];
    [context invalidateSupplementaryElementsOfKind:UICollectionElementKindSectionFooter atIndexPaths:indexPaths];
    return context;
}

@end


