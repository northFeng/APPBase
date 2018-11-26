//
//  APPKeyInfo.h
//  GFAPP
//  各种key的信息获取
//  Created by gaoyafeng on 2018/5/10.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPKeyInfo : NSObject


///获取APPID
+ (NSString *)getAppId;

///获取App Store商店地址
+ (NSString *)getAppStoreUrlString;

///主机域名
+ (NSString *)hostURL;

//获取bugly注册的APPID
+ (NSString *)getBuglyId;

///获取百度地图秘钥
+ (NSString *)getBaiDuAK;

///获取隐私协议地址
+ (NSString *)getUserAgreement;

///隐私协议
+ (NSString *)getPrivacyAgreement;


@end

NS_ASSUME_NONNULL_END
