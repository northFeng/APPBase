//
//  APPLoacalInfo.h
//  FlashSend
//  APP在本机信息汇总
//  Created by gaoyafeng on 2018/10/12.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPLoacalInfo : NSObject

///手机系统版本号
+ (NSString *)phoneIOSVerion;

///app版本号
+ (NSString *)appVerion;


///跳转到苹果商店
+ (void)gotoAppleStore;

/**
///联网权限
+ (void)connectNetAuthorizationWithBlock:(APPBackBlock)block;


///定位权限
+ (BOOL)locationAuthorization;
 */


/**
///打开WIFI
+ (void)openWiFi;

///打开定位授权
+ (void)openLocation;
 */



@end

NS_ASSUME_NONNULL_END
