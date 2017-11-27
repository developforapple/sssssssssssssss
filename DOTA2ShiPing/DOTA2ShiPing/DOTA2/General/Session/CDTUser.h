//
//  CDTUser.h
//  CDT
//
//  Created by wwwbbat on 2017/5/15.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

@import Foundation;

@interface CDTUser : SPObject <NSCoding,NSCopying>

@property (copy,    nonatomic)  NSString *  accessToken;
@property (assign,  nonatomic)  NSInteger   age;
@property (assign,  nonatomic)  NSInteger   alipayBorrowTimes;
@property (copy,    nonatomic)  NSString *  alipayFWCUserId;
@property (copy,    nonatomic)  NSString *  alipayUserId;
@property (assign,  nonatomic)  NSInteger   checkingCDBNum;
@property (assign,  nonatomic)  NSInteger   freeTime;
@property (copy,    nonatomic)  NSString *  headImage;
@property (copy,    nonatomic)  NSString *  huanxinAccount;
@property (assign,  nonatomic)  NSInteger   id;
@property (copy,    nonatomic)  NSString *  inviteCode;
@property (assign,  nonatomic)  NSInteger   isBorrow;           //当前已借充电宝
@property (assign,  nonatomic)  BOOL        isShare;
@property (copy,    nonatomic)  NSString *  lastBorrowTime;
@property (copy,    nonatomic)  NSString *  lastLoginTime;
@property (assign,  nonatomic)  double      lat;
@property (assign,  nonatomic)  double      lng;
@property (copy,    nonatomic)  NSString *  leancloudClientId;
@property (copy,    nonatomic)  NSString *  leancloudPassword;
@property (copy,    nonatomic)  NSString *  leancloudUserName;
@property (copy,    nonatomic)  NSString *  mobile;
@property (assign,  nonatomic)  float       money YG_UNIT_YUAN;              //余额+赠送余额
@property (copy,    nonatomic)  NSString *  name;
@property (copy,    nonatomic)  NSString *  nickName;
@property (copy,    nonatomic)  NSString *  numberAccount;
@property (copy,    nonatomic)  NSString *  phonecode;
@property (copy,    nonatomic)  NSString *  platform;
@property (assign,  nonatomic)  float       preMoney YG_UNIT_YUAN;           //押金
@property (assign,  nonatomic)  float       presentMoney YG_UNIT_YUAN;       //赠送余额
@property (assign,  nonatomic)  NSInteger   presentMoneyTimes;
@property (copy,    nonatomic)  NSString *  pushToken;
@property (copy,    nonatomic)  NSString *  resume;
@property (assign,  nonatomic)  NSInteger   sex;
@property (assign,  nonatomic)  NSInteger   source;
@property (strong,  nonatomic)  id          ticket;
@property (assign,  nonatomic)  NSInteger   tokenType;
@property (copy,    nonatomic)  NSString *  updateTime;
@property (copy,    nonatomic)  NSString *  userName;
@property (assign,  nonatomic)  NSInteger   userType;
@property (copy,    nonatomic)  NSString *  version;
@property (copy,    nonatomic)  NSString *  wxAccessToken;
@property (copy,    nonatomic)  NSString *  wxCode;
@property (copy,    nonatomic)  NSString *  wxRefreshToken;
@property (nonatomic, copy) NSString *wxGZHOpenId;
@property (nonatomic, copy) NSString *wxUnionid;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) BOOL isLoginApp;

// 已使用MD5加密后的密码
@property (copy, nonatomic) NSString *autologin_password;

@end
