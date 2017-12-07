//
//  SPItemCellModel.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/14.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemCellModel.h"
#import "SPItem.h"
#import "SPItemColor.h"
#import "SPDataManager.h"
@import ChameleonFramework;

@implementation SPItemLayout

+ (SPItemLayout *)layoutWithMode:(SPItemListMode)mode
{
    static SPItemLayout *tableLayout;
    static SPItemLayout *gridLayout;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            tableLayout = [SPItemLayout new];
            tableLayout.preferImageSize = CGSizeMake(90, 60);
            tableLayout.itemSize = CGSizeMake(Device_Width, 64);
            tableLayout.sectionInset = UIEdgeInsetsZero;
            tableLayout.lineSpacing = 0.f;
            tableLayout.interitemSpacing = 0.f;
        }
        {
            CGFloat width = 0.f;
            CGFloat height = 0.f;
            UIEdgeInsets sectionInset;
            CGFloat itemSpacing = 0.f;
            CGFloat lineSpacing = 0.5f;
            
            CGFloat textHeight = 26.f;
            
            width = floorf(Device_Width/4);
            height = ceilf(width/1.5f + textHeight);
            CGFloat margin = (Device_Width - width * 4 ) /2;
            sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
            
            gridLayout = [SPItemLayout new];
            gridLayout.preferImageSize = CGSizeMake(width, height - textHeight);
            gridLayout.itemSize = CGSizeMake(width, height);
            gridLayout.sectionInset = sectionInset;
            gridLayout.lineSpacing = lineSpacing;
            gridLayout.interitemSpacing = itemSpacing;
            gridLayout.preferNameSize = CGSizeMake(width, textHeight);
        }
    });
    switch (mode) {
        case SPItemListModeTable:   return tableLayout;
        case SPItemListModeGrid:    return gridLayout;
    }
    return nil;
}

@end

@interface SPItemCellModel ()
{
    BOOL _modeIsSet;
}
@end

@implementation SPItemCellModel

- (SPItem *)item
{
    return self.entity;
}

- (void)create
{
    [super create];
    NSAssert(_modeIsSet, @"create之前需要设置mode");
    switch (self.mode) {
        case SPItemListModeTable:   [self createWithTableMode]; break;
        case SPItemListModeGrid:    [self createWithGridMode];  break;
    }
}

- (void)createWithTableMode
{
    SPItem *item = self.entity;
    
    if ([item.prefab isEqualToString:@"bundle"]) {
        NSArray *sets = [[SPDataManager shared] querySetsWithCondition:@"store_bundle=?" values:@[item.name?:@""]];
        SPItemSets *theSet = [sets firstObject];
        if (theSet) {
            self.typeString = [NSString stringWithFormat:@"%@“%@”",SPLOCAL(@"comp_2129_pg_page_treasureelementlistsub_desc_text",@"contain"),theSet.name_loc];
        }else{
            self.typeString = @"";
        }
    }else{
        self.typeString = SPLOCALNONIL(item.item_type_name);// item.item_type_name;
    }
    
    self.rarityString = [[SPDataManager shared] rarityOfName:item.item_rarity].name_loc;
    
    UIColor *baseColor = RGBColor(120, 120, 120, 1);
    self.gradientColors = @[(id)blendColors(baseColor, item.itemColor, .8f).CGColor,
                             (id)blendColors(baseColor, item.itemColor, .2f).CGColor];
}

- (void)createWithGridMode
{
    SPItemLayout *gridLayout = [SPItemLayout layoutWithMode:SPItemListModeGrid];
    
    SPItem *item = self.entity;
    
    self.preferImageSize = gridLayout.preferImageSize;

    static CGFloat fontSize = 10.f;
    static NSDictionary *attributes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        style.lineBreakMode = NSLineBreakByCharWrapping;
        style.hyphenationFactor = 1.f;
        style.lineSpacing = 2.f;
        attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                       NSForegroundColorAttributeName:[UIColor whiteColor],
                       NSParagraphStyleAttributeName:style};
    });
    

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:item.nameWithQualtity attributes:attributes];
    if ([item.item_rarity isEqualToString:@"seasonal"]){
        [string addAttribute:NSForegroundColorAttributeName value:FlatBlack range:NSMakeRange(0, string.length)];
    }
    CGFloat height = [self boundingHeightForWidth:gridLayout.itemSize.width withAttributedString:string];
    
    if (height <= fontSize + 4.1f) {
        self.nameSize = CGSizeMake(gridLayout.preferNameSize.width,
                                   height);
    }else{
        self.nameSize = CGSizeMake(gridLayout.preferNameSize.width,
                                   gridLayout.preferNameSize.height);
    }
    self.namePosition = CGPointMake(gridLayout.preferNameSize.width/2,
                                    gridLayout.preferNameSize.height/2 + gridLayout.preferImageSize.height);
    self.name = string;
}

- (void)setMode:(SPItemListMode)mode
{
    _modeIsSet = YES;
    _mode = mode;
}

- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth withAttributedString:(NSAttributedString *)attributedString
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (CFMutableAttributedStringRef) attributedString);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(inWidth, CGFLOAT_MAX), NULL);
    CFRelease(framesetter);
    return suggestedSize.height;
}

@end
