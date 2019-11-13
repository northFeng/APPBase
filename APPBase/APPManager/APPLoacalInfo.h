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

///获取设备唯一标识
+ (NSString *)getDeviceIDInKeychain;

///手机系统版本号
+ (NSString *)phoneIOSVerion;

///app版本号
+ (NSString *)appVerion;

///APP名称
+ (NSString *)appName;

///app build版本
+ (NSString *)appBuildVersion;


///判断iPhone && iPad
+ (BOOL)iPhoneOrIpad;


///跳转到苹果商店
+ (void)gotoAppleStore;

///App Store商店版本号
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
