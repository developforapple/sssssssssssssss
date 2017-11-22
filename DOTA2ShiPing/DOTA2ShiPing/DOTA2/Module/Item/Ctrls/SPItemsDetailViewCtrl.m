//
//  SPItemsDetailViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/18.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemsDetailViewCtrl.h"
#import "SPItemViewCtrl.h"
#import "SPItem.h"
#import "SPPlayerItems.h"

@interface SPItemsDetailViewCtrl ()
@property (strong, nonatomic) SPItemViewCtrl *infoViewCtrl;
@end

@implementation SPItemsDetailViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setupItem:(id)item
{
    if ([item isKindOfClass:[SPItem class]]) {
        self.item = item;
    }else if ([item isKindOfClass:[SPPlayerItemDetail class]]){
        self.playerItem = item;
    }
}

- (void)setItem:(SPItem *)item
{
    _item = item;
    self.infoViewCtrl.item = item;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SPItemInfoSegueID"]) {
        self.infoViewCtrl = segue.destinationViewController;
        self.infoViewCtrl.item = self.item;
    }
}

@end
