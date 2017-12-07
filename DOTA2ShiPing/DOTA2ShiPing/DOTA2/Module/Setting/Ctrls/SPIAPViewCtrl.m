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
    
    self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.sectionHeaderHeight = 28;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 28;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.restoreBtn.hidden = YES;
    [self initProducts];
}

- (void)initProducts
{
    [SPIAP requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {
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
    
    SPLog(@"准备恢复");
    ygweakify(self);
    [SPIAP restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
        ygstrongify(self);
        [self.HUD hideAnimated:YES];
        if (error) {
            SPLog(@"恢复失败！%@",error);
            [UIAlertController alert:@"恢复失败" message:[error localizedDescription]];
        }else{
            [SPIAPViewCtrl handleRestorePayment:payment];
        }
    }];
}

+ (void)handleRestorePayment:(SKPaymentQueue *)paymentQueue
{
    BOOL old = [SPIAP isPurchasedProductsIdentifier:kOLDProductID];
    BOOL ad = [SPIAP isPurchasedProductsIdentifier:kIAPProductAD];
    
    // 下面两个不会出现在恢复列表中
//    BOOL coke = [SPIAP isPurchasedProductsIdentifier:kIAPProductCoke];
//    BOOL coffee = [SPIAP isPurchasedProductsIdentifier:kIAPProductCoffee];
    
    if (old) {
        SPLog(@"旧版本专业版用户");
        [UIAlertController alert:@"您是旧版本专业版用户" message:@"新版已不再需要购买专业版内容。现已去除了广告。感谢您的支持！"];
        [SPIAPViewCtrl refreshState];
    }else if (ad){
#if !TARGET_PRO
        // 验证
        SKPaymentTransaction *transaction;
        for (SKPaymentTransaction *aTransaction in paymentQueue.transactions) {
            if ([kIAPProductAD isEqualToString:aTransaction.payment.productIdentifier] &&
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
#endif
    }else if(paymentQueue.transactions.count == 0){
        SPLog(@"队列为空");
        [SVProgressHUD showInfoWithStatus:@"无恢复项目"];
    }else{
        SPLog(@"恢复失败");
        [SVProgressHUD showErrorWithStatus:@"恢复失败"];
    }
}

+ (void)checkReceipt:(SKPaymentTransaction *)transaction
{
    
#if TARGET_PRO
    SPLog(@"PRO版本，不验证凭据");
    [SPIAP provideContentWithTransaction:transaction];
    [SPIAPViewCtrl uploadCheckResponse:@"target pro. Don't need check" transaction:transaction];
    [SPIAPViewCtrl refreshState];
    [UIAlertController alert:@"感谢您的支持！" message:nil];
    return;
#endif
    
    if ([kIAPProductCoke isEqualToString:transaction.payment.productIdentifier]){
        SPLog(@"coke 不验证");
        [SPIAP provideContentWithTransaction:transaction];
        [SPIAPViewCtrl uploadCheckResponse:@"target ad. Don't need check 'coke' product" transaction:transaction];
        [SPIAPViewCtrl refreshState];
        [UIAlertController alert:@"感谢您的支持！" message:nil];
        return;
    }
    
    SPLog(@"准备验证支付凭据");
    [SVProgressHUD showWithStatus:@"验证中..."];
    NSData *data = transaction.transactionReceipt;
    SPLog(@"支付凭据内容：\n\n%@\n\n",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [SPIAP checkReceipt:data onCompletion:^(NSString *response, NSError *error) {
        SPLog(@"验证结果：\n\n%@\n\n",response);
        if (error) {
            SPLog(@"验证出错！%@",error);
            [SVProgressHUD showErrorWithStatus:@"验证出错，请重试"];
            [SPIAPViewCtrl refreshState];
        }else{
            [SVProgressHUD dismiss];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                
                int status = [dict[@"status"] intValue];
                if (status == 0) {
                    //验证成功
                    SPLog(@"验证 ok");
                    [UIAlertController alert:@"感谢您的支持！" message:@"广告已去除"];
                    [SPIAP provideContentWithTransaction:transaction];
                }else{
                    SPLog(@"验证失败！");
                    [UIAlertController alert:@"验证失败！" message:@"您的购买凭据未能通过验证。请重新购买或点击“恢复购买”。不会重复扣款。"];
                    [SPIAP clearSavedPurchasedProductByID:kIAPProductAD];
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
        SPLog(@"设置为无广告版本");
    }else{
        //有广告
        SPLog(@"设置为有广告版本");
    }
    [SPIAPHelper sendNotification];
}

+ (void)uploadCheckResponse:(NSString *)response transaction:(SKPaymentTransaction *)transaction
{
    SPLog(@"上传response");
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
    
    if ([kIAPProductAD isEqualToString:product.productIdentifier] &&
        [SPIAP isPurchasedProductsIdentifier:kIAPProductAD]) {
        [cell.iapMoneyBtn setTitle:@"已购买" forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.HUD hideAnimated:YES];
    self.HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
    SPLog(@"准备购买：%@",self.products[indexPath.row]);
    ygweakify(self);
    [SPIAP buyProduct:self.products[indexPath.row] onCompletion:^(SKPaymentTransaction *transcation) {
        ygstrongify(self);
        switch (transcation.transactionState) {
            case SKPaymentTransactionStatePurchasing:{
                SPLog(@"交易中...");
            }   break;
            case SKPaymentTransactionStatePurchased:{
                SPLog(@"交易完成");
                [self.HUD hideAnimated:yes];
                [SPIAPViewCtrl checkReceipt:transcation];
            }   break;
            case SKPaymentTransactionStateRestored:{
                SPLog(@"恢复完成");
                [self.HUD hideAnimated:yes];
                [SPIAPViewCtrl checkReceipt:transcation];
            }   break;
            case SKPaymentTransactionStateFailed:{
                SPLog(@"交易失败");
                [self.HUD hideAnimated:yes];
                if (transcation.error) {
                    SPLog(@"失败原因：%@",transcation.error);
                    [UIAlertController alert:nil message:transcation.error.localizedDescription];
                }
            }   break;
            case SKPaymentTransactionStateDeferred:{
                SPLog(@"交易状态 SKPaymentTransactionStateDeferred");
            }   break;
        }
    }];
    
}

@end
