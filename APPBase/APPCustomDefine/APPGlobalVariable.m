//
//  APPGlobalVariable.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "APPGlobalVariable.h"

#pragma mark - 全局常量

NSString * const _kGlobal_LightOrDarkModelChange = @"APPLightOrDarkModelChange";

/** 网络状态变化key */
NSString * const _kGlobal_NetworkingReachabilityChangeNotification = @"GFNetworkingReachabilityDidChangeNotification";

/** 登录变化通知 */
NSString * const _kGlobal_LoginStateChange = @"APPLoginStateChangeNotice";

NSString * const _kGlobal_OrderDetailBtnEvent = @"APPOrderDetailBtnEvent";

///是否第一次打开
NSString * const _kGlobal_IsFirstOpen = @"isFirstOpen";

///版本信息存储字段
NSString * const _kGlobal_versionInfo = @"versionInformation";

///本地保存订单信息
NSString * const _kGlobal_localOrderInfo = @"APPLocalOrderInfo";


#pragma mark - 接口宏变量


///版本检测
NSString * const _kNet_version_check = @"version/latest?platform=1";
