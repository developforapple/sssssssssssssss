//
//  SPIAPObject.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/12/1.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPIAPObject.h"
@import FCUUID;

@implementation SPIAPObject

+ (void)saveTransaction:(SKPaymentTransaction *)transaction
{
    [self saveTransaction:transaction verification:@""];
}

+ (void)saveTransaction:(SKPaymentTransaction *)transaction verification:(NSString *)response
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
        [object setObject:response forKey:@"response"];
        [object setObject:[FCUUID uuidForDevice] forKey:@"UUID"];
        [object setObject:transaction.payment.productIdentifier forKey:@"product"];
        
        AVFile *file = [AVFile fileWithData:data];
        [object setObject:file forKey:@"transactionReceipt"];
        SPLog(@"上传购买凭据:");
        SPLog(@"transactionState: %d",(int)transaction.transactionState);
        SPLog(@"transactionIdentifier : %@",transaction.transactionIdentifier);
        SPLog(@"UUID : %@",[FCUUID uuidForDevice]);
        
        [object saveInBackgroundWithOption:nil eventually:yes block:^(BOOL succeeded, NSError *error) {
            if (!succeeded || error) {
                SPLog(@"上传购买凭据发生错误：%@",error);
            }else{
                SPLog(@"上传购买凭据成功");
            }
        }];
    }
}

@end
