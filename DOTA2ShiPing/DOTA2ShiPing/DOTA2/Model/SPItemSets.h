//
//  SPItemSets.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@interface SPItemSets : SPObject

// key
@property (strong, nonatomic) NSString *token;  //"pugna_narcissistic_leech"

// data
@property (strong, nonatomic) NSString *name;   //"#DOTA_Set_Narcissistic_Leech"
@property (strong, nonatomic) NSString *store_bundle; //"Narcissistic Leech"

// child

/*
 {
 "armor of the narcissistic leech" = 1;
 "belt of the narcissistic leech" = 1;
 "cape of the narcissistic leech" = 1;
 "scepter of the narcissistic leech" = 1;
 "skull of the narcissistic leech" = 1;
 "sleeves of the narcissistic leech" = 1;
 }
 */
@property (strong, nonatomic) NSArray<NSString *> *items;

@property (strong, nonatomic) NSString *name_loc;

@end
