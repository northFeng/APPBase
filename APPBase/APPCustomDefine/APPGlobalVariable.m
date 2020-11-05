//
//  APPGlobalVariable.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/26.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "APPGlobalVariable.h"

#pragma mark - ******************* 全局函数 *******************
// GCD —> 回到主线程执行
void APP_GCD_async_nain_safe(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        if (block) {
            block();
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

///延迟执行函数
void APP_GCD_after(NSTimeInterval seconds, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), queue, ^{
        if (block) {
            block();
        }
    });
}

///安全区域
UIEdgeInsets safeAreaInset(UIView *view) {
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }else{
        return UIEdgeInsetsZero;
    }
}



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
