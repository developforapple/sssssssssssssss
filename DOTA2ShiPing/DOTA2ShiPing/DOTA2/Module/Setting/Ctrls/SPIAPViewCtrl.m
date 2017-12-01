//
//  SPIAPViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPIAPViewCtrl.h"
#import "SPIAPCell.h"
@import IAPHelper;
@import AVOSCloud.AVObject;
#import "SPIAPHelper.h"
#import "SPIAPObject.h"

@interface SPIAPViewCtrl () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UIButton *restoreBtn;

@property (strong, nonatomic) DDProgressHUD *HUD;

@property (strong, nonatomic) NSArray<SKProduct *> *products;

@end

@implementation SPIAPViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.restoreBtn.hidden = YES;
    [self initProducts];
}

- (void)initProducts
{
    IAPHelper *helper = [IAPShare sharedHelper].iap;
    if (!helper) {
        NSMutableSet *set = [NSMutableSet set];
        [set addObject:kIAPProductAD];
        [set addObject:kIAPProductCoke];
        [set addObject:kIAPProductCoffee];
        helper = [[SPIAPHelper alloc] initWithProductIdentifiers:set];
        [IAPShare sharedHelper].iap = helper;
    }
    
    [helper requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {
        NSArray *products = response.products;
        self.products = products;
        [self.tableView reloadData];
        [self.restoreBtn setHidden:NO animated:YES];
        [self.loading stopAnimating];
    }];
}

- (IBAction)restore:(id)sender
{
    [self.HUD hideAnimated:YES];
    self.HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
    
    NSLog(@"准备恢复");
    ygweakify(self);
    [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
        ygstrongify(self);
        [self.HUD hideAnimated:YES];
        if (error) {
            NSLog(@"恢复失败！%@",error);
            [UIAlertController alert:@"恢复失败" message:[error localizedDescription]];
        }else{
            [SPIAPViewCtrl handleRestorePayment:payment];
        }
    }];
}

+ (void)handleRestorePayment:(SKPaymentQueue *)paymentQueue
{
    BOOL old = [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kOLDProductID];
    BOOL ad = [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kAdMobAppID];
    BOOL coke = [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kIAPProductCoke];
    BOOL coffee = [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kIAPProductCoffee];
    
    if (old) {
        NSLog(@"旧版本专业版用户");
        [UIAlertController alert:@"您是旧版本专业版用户" message:@"新版已不再需要购买专业版内容。现已去除了广告。感谢您的支持！"];
        [SPIAPViewCtrl refreshState];
    }else if (ad){
        // 验证
        SKPaymentTransaction *transaction;
        for (SKPaymentTransaction *aTransaction in paymentQueue.transactions) {
            if ([aTransaction.payment.productIdentifier isEqualToString:kIAPProductAD] &&
                aTransaction.transactionState == SKPaymentTransactionStatePurchased) {
                transaction = aTransaction;
                break;
            }
        }
        
        if (transaction) {
            [SPIAPViewCtrl checkReceipt:transaction];
        }else{
            [UIAlertController alert:@"感谢您的支持！" message:@"广告已去除"];
            [SPIAPViewCtrl refreshState];
        }
        
    }else if (coke || coffee){
        NSLog(@"coke or coffee");
        [UIAlertController alert:@"感谢您的支持！" message:@"广告已去除"];
        [SPIAPViewCtrl refreshState];
    }else if(paymentQueue.transactions.count == 0){
        NSLog(@"队列为空");
        [SVProgressHUD showInfoWithStatus:@"无恢复项目"];
    }else{
        NSLog(@"恢复失败");
        [SVProgressHUD showErrorWithStatus:@"恢复失败"];
    }
}

+ (void)checkReceipt:(SKPaymentTransaction *)transaction
{
    NSLog(@"准备验证支付凭据");
    [SVProgressHUD showWithStatus:@"验证中..."];
    NSData *data = transaction.transactionReceipt;
    NSLog(@"支付凭据内容：\n\n%@\n\n",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [[IAPShare sharedHelper].iap checkReceipt:data onCompletion:^(NSString *response, NSError *error) {
        NSLog(@"验证结果：\n\n%@\n\n",response);
        if (error) {
            NSLog(@"验证出错！%@",error);
            [SVProgressHUD showErrorWithStatus:@"验证出错，请重试"];
            [SPIAPViewCtrl refreshState];
        }else{
            [SVProgressHUD dismiss];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                
                int status = [dict[@"status"] intValue];
                if (status == 0) {
                    //验证成功
                    //刷新状态即可
                    NSLog(@"验证 ok");
                    [UIAlertController alert:@"感谢您的支持！" message:@"广告已去除"];
                }else{
                    NSLog(@"验证失败！");
                    [UIAlertController alert:@"验证失败！" message:@"您的购买凭据未通过验证。请重新购买或点击“恢复购买”。"];
                    [[IAPShare sharedHelper].iap clearSavedPurchasedProductByID:kAdMobAppID];
                }
            }
            
            // 总是上传数据
            [SPIAPViewCtrl uploadCheckResponse:response transaction:transaction];
            [SPIAPViewCtrl refreshState];
        }
    }];
}

+ (void)refreshState
{
    if ([SPIAPHelper isPurchased]) {
        //无广告
        NSLog(@"设置为无广告版本");
        //todo
    }else{
        //有广告
        NSLog(@"设置为有广告版本");
        //todo
    }
}

+ (void)uploadCheckResponse:(NSString *)response transaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"上传response");
    [SPIAPObject saveTransaction:transaction verification:response];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPIAPCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPIAPCell forIndexPath:indexPath];
    SKProduct *product = self.products[indexPath.row];
    cell.iapName.text = product.localizedTitle;
    cell.iapDesc.text = product.localizedDescription;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    
    [cell.iapMoneyBtn setTitle:formattedString forState:UIControlStateNormal];
    
    if ([product.productIdentifier isEqualToString:kAdMobAppID] &&
        [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kAdMobAppID]) {
        [cell.iapMoneyBtn setTitle:@"已购买" forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.HUD hideAnimated:YES];
    self.HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
    NSLog(@"准备购买：%@",self.products[indexPath.row]);
    ygweakify(self);
    [[IAPShare sharedHelper].iap buyProduct:self.products[indexPath.row] onCompletion:^(SKPaymentTransaction *transcation) {
        ygstrongify(self);
        switch (transcation.transactionState) {
            case SKPaymentTransactionStatePurchasing:{
                NSLog(@"交易中...");
            }   break;
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"交易完成");
                [self.HUD hideAnimated:yes];
                [SPIAPViewCtrl checkReceipt:transcation];
            }   break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"恢复完成");
                [self.HUD hideAnimated:yes];
                [SPIAPViewCtrl checkReceipt:transcation];
            }   break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"交易失败");
                [self.HUD hideAnimated:yes];
                if (transcation.error) {
                    NSLog(@"失败原因：%@",transcation.error);
                    [UIAlertController alert:nil message:transcation.error.localizedDescription];
                }
            }   break;
            case SKPaymentTransactionStateDeferred:{
                NSLog(@"交易状态 SKPaymentTransactionStateDeferred");
            }   break;
        }
    }];
    
}

@end
