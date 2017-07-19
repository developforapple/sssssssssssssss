//
//  SPSettingUpgradeVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/22.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSettingUpgradeVC.h"

#import "DDProgressHUD.h"
#import "IAPShare.h"

#define IAP [IAPShare sharedHelper].iap
#define APPIAPProductID_pro @"com.itemofdota2.proversion"
#define APPISPROVERSION [IAP isPurchasedProductsIdentifier:APPIAPProductID_pro]

static NSString *const kSPUpgradeCell = @"SPUpgradeCell";

@interface SPSettingUpgradeVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buyBtnItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *restoreBtnItem;
@end

@implementation SPSettingUpgradeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flowLayout.itemSize = CGSizeMake(Device_Width, CGRectGetHeight(self.collectionView.frame));
    
    self.buyBtnItem.tintColor = kRedColor;
    self.restoreBtnItem.tintColor = kRedColor;
    
    self.pageControl.currentPageIndicatorTintColor = kRedColor;
    self.pageControl.tintColor = [UIColor lightGrayColor];
    self.pageControl.numberOfPages = 3;
    
    if (!IAP) {
        IAP = [[IAPHelper alloc] initWithProductIdentifiers:[NSSet setWithObject:APPIAPProductID_pro]];
        ygweakify(self);
        self.buyBtnItem.enabled = NO;
        [IAP requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {
            
            ygstrongify(self);
            if (IAP.products.count != 0) {
                self.buyBtnItem.enabled = YES;
            }else{
                [self alert:@"错误" content:@"获取列表失败!"];
                IAP = nil;
            }
        }];
    }else if (IAP.products.count == 0){
        [self alert:@"提示" content:@"没有可购买项目"];
    }
    
#if DEBUG
    IAP.production = NO;
#else
    IAP.production = YES;
#endif
    
}

- (void)alert:(NSString *)title content:(NSString *)content
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)success:(SKPaymentTransaction *)transcation
{
    [IAP provideContentWithTransaction:transcation];
}

#pragma mark - Buy
- (IBAction)buy:(UIBarButtonItem *)sender
{
    if ([IAP isPurchasedProductsIdentifier:APPIAPProductID_pro]) {
        [self alert:@"提示" content:@"您已购买过升级版，请点击“恢复购买”进行恢复。"];
        return;
    }
    
    if (![SKPaymentQueue canMakePayments]) {
        [self alert:@"提示" content:@"应用内付费购买已被限制"];
        return;
    }
    
    if ([IAP.products count] == 0) {
        [self alert:@"提示" content:@"没有可购买项目"];
        return;
    }
    
    DDProgressHUD *HUD = [DDProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [IAP buyProduct:[IAP.products firstObject] onCompletion:^(SKPaymentTransaction *transcation) {
        
        if (transcation.error) {
            [HUD showAutoHiddenHUDWithMessage:transcation.error.localizedDescription];
            return;
        }
        
        switch (transcation.transactionState) {
            case SKPaymentTransactionStatePurchasing: {
                
                break;
            }
            case SKPaymentTransactionStatePurchased: {
                //支付完成
                
                [IAP checkReceipt:transcation.transactionReceipt onCompletion:^(NSString *response, NSError *error) {
                    
                    NSDictionary *rec = [IAPShare toJSON:response];
                    
                    if ([rec[@"statue"] integerValue] == 0) {
                        
                        [self success:transcation];
                        
                        //成功！！！
                        
                    }else{
                        [HUD showAutoHiddenHUDWithMessage:@"购买失败"];
                    }
                    
                }];
                
                break;
            }
            case SKPaymentTransactionStateFailed: {
                
                //失败
                
                [HUD showAutoHiddenHUDWithMessage:@"购买失败"];
                
                break;
            }
            case SKPaymentTransactionStateRestored: {
                
                break;
            }
            case SKPaymentTransactionStateDeferred: {
                
                break;
            }
        }
    }];
}

- (IBAction)restore:(UIBarButtonItem *)sender
{
    DDProgressHUD *HUD = [DDProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [IAP restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
 
        BOOL suc = NO;
        for (SKPaymentTransaction *transaction in payment.transactions) {
            NSString *purchased = transaction.payment.productIdentifier;
            if ([purchased isEqualToString:APPIAPProductID_pro]) {
                suc = YES;
                [self success:transaction];
                
                break;
            }
        }
        
        if (suc) {
            [HUD showAutoHiddenHUDWithMessage:@"恢复成功!"];
        }else{
            [HUD showAutoHiddenHUDWithMessage:@"恢复失败"];
        }
    }];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPUpgradeCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.f green:arc4random_uniform(255)/255.f blue:arc4random_uniform(255)/255.f alpha:1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.currentPage = indexPath.item;
}
@end
