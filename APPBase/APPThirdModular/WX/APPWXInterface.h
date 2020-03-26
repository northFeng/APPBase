//
//  APPWXInterface.h
//  APPBase
//
//  Created by 峰 on 2020/1/4.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WXApi.h>

/**
 *  分享类型
 */
typedef NS_ENUM(NSInteger,WXPlatformType) {
    /**
     *  微信好友
     */
    WXPlatformType_WechatSession = 0,
    /**
     *  微信朋友圈
     */
    WXPlatformType_WechatTimeLine = 1,
};

/**
 *  小程序类型
 */
typedef NS_ENUM(NSInteger,WXAPPType) {
    /**
     *  游戏1
     */
    WXAPPType_One = 0,
    /**
     *  游戏2
     */
    WXAPPType_Two = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface APPWXInterface : NSObject <WXApiDelegate>

///回调
@property (nonatomic,copy) APPBackBlock blockWX;

+ (instancetype)shareInstance;

///微信APP是否安装
- (BOOL)wxAPPIsInstalled;

///注册微信
- (void)registerWXAPP;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)continueUserActivity:(NSUserActivity *)userActivity;

///获取微信等信息
- (void)getWxUserInfoWithBlock:(APPBackBlock)blockLogin;

/// 分享接口
/// @param title 分享标题
/// @param descr 分享详细描述
/// @param thumImage 分享图片image & url
/// @param webUrl web链接
/// @param platformType 分享平台类型
/// @param resultBlock 分享后回调
- (void)shareInfoWithTitle:(NSString *)title
                     descr:(NSString *)descr
                 thumImage:(id)thumImage
                    webUrl:(NSString *)webUrl
                 shareType:(WXPlatformType)platformType
               blockResult:(APPBackBlock)resultBlock;


///跳到微信小程序
- (void)gotoWxWebAPPWithAppPath:(NSString *)appPath webAppType:(WXAPPType)appType blockResult:(APPBackBlock)blockResult;


@end

NS_ASSUME_NONNULL_END
