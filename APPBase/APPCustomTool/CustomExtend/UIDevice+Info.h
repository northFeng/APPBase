//
//  UIDevice+Info.h
//  APPBase
//  设备 信息扩展
//  Created by v_gaoyafeng on 2021/1/19.
//  Copyright © 2021 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <LocalAuthentication/LAError.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Info)


+ (BOOL)isPad;
+ (BOOL)isPhone;

//NEW
+ (BOOL)iPhoneScreen3_5Inch;
+ (BOOL)iPhoneScreen4_0Inch;
+ (BOOL)iPhoneScreen4_7Inch;
+ (BOOL)iPhoneScreen5_5Inch;
+ (BOOL)iPhoneScreen5_8Inch;
+ (BOOL)iPhoneScreen6_1Inch;
+ (BOOL)iPhoneScreen6_5Inch;

/**
 */
+ (CGSize)screenSize;
+ (CGFloat)screenScale;
+ (NSString *)screenResolutionString;

//获取设备编号
+ (NSString *)deviceMachineName;

//机型设备内存
typedef NS_ENUM (NSUInteger, UIDeviceMemoryLevel) {
    UIDeviceMemoryLevel_Low = 1,
    UIDeviceMemoryLevel_Middle = 2,
    UIDeviceMemoryLevel_High = 3
} ;

///获取设备机型
+ (NSString *)iphoneType;

///获取设备内存 单位是MB
+ (NSUInteger)MBMember;

///操作系统版本
+ (NSString *)osVersion;

///获取设备内存级别 -- 用于判断设备性能
+ (UIDeviceMemoryLevel)memoryLever;

///设备是否越狱
+ (BOOL)isJailbroken;

///获取IP地址
+ (NSString *)iPAddress;

///设备是否安装了SIM卡
+ (BOOL)isSIMInstalled;

typedef NS_ENUM (NSUInteger, DevicePolicyType) {
    DevicePolicyType_Biometry = 1,
    DevicePolicyType_Authentication
};
//是否支持指纹
+ (BOOL)supportBiometryWithPolicy:(DevicePolicyType)policy
                            error:(NSError * __autoreleasing *)error;

typedef NS_ENUM (NSInteger, DeviceBiometryType) {
    DeviceBiometryType_Unknown = -1,
    DeviceBiometryType_None = 0,
    DeviceBiometryType_TouchID = 1,
    DeviceBiometryType_FaceID = 2
};
//支持生物识别类型
+ (DeviceBiometryType)supportedBiometryType;

//Error兼容类型
+ (LAError)compatibleBiometryErrorType:(LAError)error;

//获取设备CPU个数
+ (NSUInteger)sysCores;
// 系统内存总量
+ (NSUInteger)sysTotalMemoryInMB;
// 系统内存占用量
+ (NSUInteger)sysMemoryUsageInMB;
// 系统cpu占用率
+ (NSUInteger)sysCpuUsage;
// 应用内存占用量
+ (NSUInteger)appMemoryUsageInMB;
// 应用cpu占用率
+ (NSUInteger)appCpuUsage;
// 获取设备idfa
+ (NSString *)deviceIDFA;

@end

NS_ASSUME_NONNULL_END
