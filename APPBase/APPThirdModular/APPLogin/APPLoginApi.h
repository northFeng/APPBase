//
//  APPLoginApi.h
//  APPBase
//  苹果登录接口
//  Created by 峰 on 2020/8/31.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPLoginApi : NSObject

///苹果登录
+ (instancetype)shareInstance;

///获取苹果登录系统按钮
+ (UIControl *)getAppleIdButton  API_AVAILABLE(ios(13.0));

///苹果登录
- (void)appleLogin API_AVAILABLE(ios(13.0));

///1—用户注销 AppleId 或 停止使用 Apple ID 的状态处理
- (void)checkAppleLoginState_1 API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
