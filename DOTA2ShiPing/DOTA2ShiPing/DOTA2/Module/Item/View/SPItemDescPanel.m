//
//  SPItemDescPanel.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemDescPanel.h"
#import "SPItemSharedData.h"
#import "Chameleon.h"
#import "SPDataManager.h"

@interface SPItemDescPanel ()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@end

@implementation SPItemDescPanel

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    [self update];
}

- (void)update
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
    
    
    UIColor *color = FlatGray;
    
    // styles
    SPItem *item = self.itemData.item;
    NSArray *styles = self.itemData.styles;
    if (styles.count != 0) {
        
        NSDictionary *normalAttributes = @{NSForegroundColorAttributeName:color};
        NSDictionary *redAttributes = @{NSForegroundColorAttributeName:color};
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"款式：" attributes:normalAttributes];
        for (SPItemStyle *aStyle in styles) {
            NSString *text;
            if (!aStyle.name) {
                text = [NSString stringWithFormat:@"\n - 款式：%@",aStyle.index];
            }else{
                NSString *name_loc = SPLOCALNONIL(aStyle.name);
                NSString *title = [NSString stringWithFormat:@"dota_item_%@",aStyle.name];
                NSString *title_loc = SPLOCAL(title, nil);
                if (title_loc.length > 0) {
                    text = [NSString stringWithFormat:@"\n - %@：%@",title_loc,name_loc];
                }else{
                    text = [NSString stringWithFormat:@"\n - %@",name_loc];
                }
            }
            
            SPItemStyleUnlock *unlock = aStyle.unlock;
            if (unlock) {
                text = [text stringByAppendingString:@"（需要解锁）"];
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:redAttributes]];
            }else{
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:normalAttributes]];
            }
        }
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
        
        [content appendAttributedString:string];
    }
    
    // desc
    NSError *error;
    NSString *desc = SPLOCALNONIL(self.itemData.item.item_description);
    NSData *descData = [desc dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithData:descData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:&error];
    [string setAttributes:@{NSForegroundColorAttributeName:color,
                            NSFontAttributeName:[UIFont systemFontOfSize:14]}
                    range:NSMakeRange(0, string.length)];
    
    [content appendAttributedString:string];
    
    NSMutableParagraphStyle *p = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    p.lineSpacing = 4.f;
    [content addAttribute:NSParagraphStyleAttributeName value:p range:NSMakeRange(0, content.length)];
    
    self.descLabel.attributedText = content;
}

@end
