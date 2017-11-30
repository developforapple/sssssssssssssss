//
//  SPIAPCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPTableViewCell.h"

YG_EXTERN NSString *const kSPIAPCell;

@interface SPIAPCell : SPTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *iapName;
@property (weak, nonatomic) IBOutlet UILabel *iapDesc;
@property (weak, nonatomic) IBOutlet UIButton *iapMoneyBtn;

@end
