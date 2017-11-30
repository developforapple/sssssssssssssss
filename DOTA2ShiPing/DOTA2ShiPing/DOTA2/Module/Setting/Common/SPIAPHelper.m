//
//  SPIAPHelper.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/12/1.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPIAPHelper.h"
#import "SKPaymentTransaction+SPMore.h"

@import AVOSCloud;
@import FCUUID;

@implementation SPIAPHelper

// 重写此方法。保存凭据到客户端
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.transactionState == SKPaymentTransactionStateRestored ||
        transaction.transactionState == SKPaymentTransactionStatePurchased) {
        //恢复过来的交易
        
        NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        AVObject *object = [AVObject objectWithClassName:@"Payment"];
        [object setObject:@(transaction.transactionState) forKey:@"transactionState"];
        [object setObject:transaction.transactionIdentifier forKey:@"transactionIdentifier"];
        [object setObject:transaction.transactionDate forKey:@"transactionDate"];
        [object setObject:[FCUUID uuidForDevice] forKey:@"UUID"];
        
        AVFile *file = [AVFile fileWithData:data];
        [object setObject:file forKey:@"transactionReceipt"];
        NSLog(@"上传购买凭据:");
        NSLog(@"transactionState: %d",transaction.transactionState);
        NSLog(@"transactionIdentifier : %@",transaction.transactionIdentifier);
        NSLog(@"UUID : %@",[FCUUID uuidForDevice]);
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded || error) {
                NSLog(@"上传购买凭据发生错误：%@",error);
            }else{
                NSLog(@"上传购买凭据成功");
            }
        }];
        [transaction setAVObject:object];
    }
}

@end
