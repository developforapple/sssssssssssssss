//
//  SPPriceChartViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/28.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPriceChartViewCtrl.h"
#import "JBLineChartView.h"
#import "SPItem.h"
#import "SPMarketItem.h"
#import "SPSteamAPI.h"
#import "SPPriceUnit.h"

@interface SPPriceChartViewCtrl () <JBLineChartViewDelegate,JBLineChartViewDataSource>
@property (weak, nonatomic) IBOutlet JBLineChartView *chartView;

@property (strong, nonatomic) NSArray<SPPriceUnit *> *units;
@property (strong, nonatomic) SPPriceUnit *minimumUnit;
@property (strong, nonatomic) SPPriceUnit *maximumUnit;

@end

@implementation SPPriceChartViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view layoutIfNeeded];
    
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    
    self.chartView.headerView = nil;
    self.chartView.footerView = nil;
    
    self.chartView.headerPadding = 0.f;
    self.chartView.footerPadding = 0.f;
    
    self.chartView.minimumValue = 0.f;
    self.chartView.maximumValue = 100.f;
    
//    [self.chartView resetMinimumValue];
//    [self.chartView resetMaximumValue];
    
    [self.chartView setState:JBChartViewStateExpanded animated:YES force:YES callback:^{
        
    }];
    
    [self.chartView reloadDataAnimated:YES];
    
    [self loadPriceData];
}

- (void)loadPriceData
{
    [[SPSteamAPI shared] fetchSteamMarketItemDetail:self.marketItem.href completion:^(BOOL suc, NSString *data) {
        if (suc) {
            NSError *error;
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"\\[\\[.*\\]\\]" options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult *checkingResult = [reg firstMatchInString:data options:NSMatchingReportCompletion range:NSMakeRange(0, data.length)];
            NSRange range = [checkingResult rangeAtIndex:0];
            NSString *sourceString = [data substringWithRange:range];
            [self didLoadPriceSourceData:sourceString];
        }else{
            [SVProgressHUD showErrorWithStatus:data];
        }
    }];
}

- (void)didLoadPriceSourceData:(NSString *)data
{
    RunOnGlobalQueue(^{
        NSError *error;
        NSArray *sources = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (error || !sources || ![sources isKindOfClass:[NSArray class]]) {
            RunOnMainQueue(^{
                NSLog(@"价格数组解析出错！error:%@",error);
                [SVProgressHUD showErrorWithStatus:@"解析错误，请重试！"];
            });
            return;
        }
        
        NSArray<SPPriceUnit *> *units = [SPPriceUnit unitsWithDatas:sources];
        SPPriceUnit *minimumUnit;
        SPPriceUnit *maximumUnit;
        for (SPPriceUnit *aUnit in units) {
            if (!minimumUnit || minimumUnit.price >= aUnit.price) {
                minimumUnit = aUnit;
            }
            if (!maximumUnit || maximumUnit.price <= aUnit.price) {
                maximumUnit = aUnit;
            }
        }
        
        RunOnMainQueue(^{
            
            self.minimumUnit = minimumUnit;
            self.maximumUnit = maximumUnit;
            self.units = units;
            [self reloadChartView];
        
        });
    });
}

- (void)reloadChartView
{
    self.chartView.minimumValue = self.minimumUnit.price;
    self.chartView.maximumValue = self.maximumUnit.price;
    
    [self.chartView reloadDataAnimated:YES];
    [self.chartView setState:JBChartViewStateExpanded animated:YES];
}

#pragma mark - JBLineChartView dataSource

- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return self.units.count;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return NO;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dimmedSelectionOpacityAtLineIndex:(NSUInteger)lineIndex
{
    return 0.9f;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dimmedSelectionDotOpacityAtLineIndex:(NSUInteger)lineIndex
{
    return 0.9f;
}

- (UIView *)lineChartView:(JBLineChartView *)lineChartView dotViewAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return nil;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView shouldHideDotViewOnSelectionAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

#pragma mark - JBLineChartView delegate
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [self.units[horizontalIndex] price];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex
{

}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView shouldIgnoreSelectionAtLineIndex:(NSUInteger)lineIndex
{
    return NO;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor blackColor];
}

- (CAGradientLayer *)lineChartView:(JBLineChartView *)lineChartView gradientForLineAtLineIndex:(NSUInteger)lineIndex
{
    return nil;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return nil;
}

- (CAGradientLayer *)lineChartView:(JBLineChartView *)lineChartView fillGradientForLineAtLineIndex:(NSUInteger)lineIndex
{
    return nil;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return nil;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 1.f;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return 0.f;
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView
{
    return 5.f;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

//- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return nil;
//}

//- (CAGradientLayer *)lineChartView:(JBLineChartView *)lineChartView selectionGradientForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return nil;
//}
//
//- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionFillColorForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return nil;
//}
//
//- (CAGradientLayer *)lineChartView:(JBLineChartView *)lineChartView selectionFillGradientForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return nil;
//}
//
//- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
//{
//    return nil;
//}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleSolid;
}

- (JBLineChartViewColorStyle)lineChartView:(JBLineChartView *)lineChartView colorStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewColorStyleSolid;
}

- (JBLineChartViewColorStyle)lineChartView:(JBLineChartView *)lineChartView fillColorStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewColorStyleSolid;
}





@end
