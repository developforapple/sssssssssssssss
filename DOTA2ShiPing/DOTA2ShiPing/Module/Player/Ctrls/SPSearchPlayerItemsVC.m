//
//  SPSearchPlayerItemsVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/3.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSearchPlayerItemsVC.h"

@interface SPSearchPlayerItemsVC ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SPSearchPlayerItemsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)dealloc
{
    NSString *class = NSStringFromClass([self class]);
    NSLog(@"%@释放！！！",class);
}

- (void)search:(NSString *)keywords
{
    self.label.text = keywords;
}

@end
