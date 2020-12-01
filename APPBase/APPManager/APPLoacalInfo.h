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

///设备人名字
+ (NSString *)phoneDevicesName;

///获取设备唯一标识
+ (NSString *)getDeviceIDInKeychain;

///存储字符串 到钥匙串本地
+ (void)storekeychain:(NSString *)chain key:(NSString *)key;

///获取钥匙串
+ (NSString *)getKeyChainForKey:(NSString *)key;


///获取UUID
+ (NSString *)UUIDString;

///获取随机UUID
+ (NSString *)UUIDCFString;

///手机系统版本号
+ (NSString *)phoneIOSVerion;

///app版本号
+ (NSString *)appVerion;

///APP名称
+ (NSString *)appName;

///app build版本
+ (NSString *)appBuildVersion;

///获取 设备型号
+ (NSString *)deviceModel;

///判断iPhone && iPad
+ (BOOL)iPhoneOrIpad;

///是否是刘海屏
+ (BOOL)iPhone_X;

+ (BOOL)iPad;

+ (BOOL)iPhone;

///获取设备内存 MB
+ (NSUInteger)DeviceMember;


// 设备是否越狱
+ (BOOL)isJailbroken;

//获取IP地址
+ (NSString *)iPAddress;

///是否按照SIM卡
+ (BOOL)isSIMInstalled;


///跳转到苹果商店
+ (void)gotoAppleStore;

///App Store商店版本号 （苹果商店信息也有不及时这个 ）
+ (NSString *)appStoreVersion;


///判断是否有版本更新
+ (NSString *)judgeIsHaveUpdate;

///比较两个版本 oneVerson > twoVerson——>YES  oneVerson <= twoVerson——>NO
+ (BOOL)compareTheTwoVersionsAPPVerson:(NSString *)storeVerson localVerson:(NSString *)localVerson;

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

#pragma mark - 根据SDWebImage 处理内存呢
///获取缓存路径下文件大小
+ (NSInteger)getSDWebImageFileSize;

///清理缓存路径下的文件
+ (void)clearDiskMemory;



@end

NS_ASSUME_NONNULL_END
