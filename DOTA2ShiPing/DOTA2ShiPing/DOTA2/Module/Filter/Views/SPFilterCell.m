//
//  SPFilterCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterCell.h"
#import "SPFilterUnit.h"

@import ReactiveObjC;

@import ChameleonFramework;

NSString *const kSPFilterCell = @"SPFilterCell";
NSString *const kSPFilterInputCell = @"SPFilterInputCell";

@interface SPFilterCell ()

@property (strong, readwrite, nonatomic) SPFilterUnit *unit;

@end

@implementation SPFilterCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self update:NO];
    self.textFieldWidthConstraint.constant = Device_Width - 28;
}

- (void)configure:(SPFilterUnit *)unit
{
    _unit = unit;
    
    if (self.nameLabel) {
    
        self.nameLabel.text = unit.title;
    }
    
    if (self.textField) {
        
        self.textField.text = unit.object;
        self.textField.placeholder = unit.title;
        
        ygweakify(self);
        [self.textField.rac_textSignal
         subscribeNext:^(NSString *x) {
             ygstrongify(self);
             self.unit.object = x;
             if (self.inputContentDidChanged) {
                 self.inputContentDidChanged(self.unit);
             }
         }];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self update:highlighted];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self update:selected];
}

- (void)update:(BOOL)highlighted
{
    if (self.nameLabel) {
        
        if (highlighted) {
            
            self.nameLabel.textColor = [UIColor whiteColor];
            
            self.contentView.backgroundColor = FlatSkyBlue;
            self.contentView.masksToBounds_ = YES;
            self.contentView.cornerRadius_ = 4;
            self.contentView.borderColor_ = [UIColor clearColor];
            self.contentView.borderWidth_ = 0;
            
        }else{
            
            self.nameLabel.textColor = FlatWhiteDark;
            
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.contentView.masksToBounds_ = YES;
            self.contentView.cornerRadius_ = 4;
            self.contentView.borderColor_ = FlatWhiteDark;
            self.contentView.borderWidth_ = 0.5;
            
        }
    }
}

@end
