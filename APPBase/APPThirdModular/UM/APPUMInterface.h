//
//  APPUMInterface.h
//  APPBase
//
//  Created by 峰 on 2020/1/4.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  分享类型
 */
typedef NS_ENUM(NSInteger,UMPlatformType) {
    /**
     *  微信好友
     */
    UMPlatformType_WechatSession = 0,
    /**
     *  微信朋友圈
     */
    UMPlatformType_WechatTimeLine = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface APPUMInterface : NSObject

///初始化友盟SDK
+ (void)initUMSDK;

///是否安装微信
//+ (BOOL)isInstallWX;

///是否安装APP
//+ (BOOL)isInstallAppOfType:(UMSocialPlatformType)type;


///设置系统回调
//+ (BOOL)handOpenUrl:(NSURL *)url options:(NSDictionary *)options;


///获取微信登录信息
//+ (void)getWXUserInfoWithBlockResult:(APPBackBlock)resultBlock;


/// 分享接口
/// @param title 分享标题
/// @param descr 分享详细描述
/// @param thumImage 分享图片image & url
/// @param webUrl web链接
/// @param platformType 分享平台类型
/// @param resultBlock 分享后回调
+ (void)shareInfoWithTitle:(NSString *)title
                     descr:(NSString *)descr
                 thumImage:(id)thumImage
                    webUrl:(NSString *)webUrl
                 shareType:(UMPlatformType)platformType
               blockResult:(APPBackBlock)resultBlock;



//--------------------------------------------- 页面统计 ---------------------------------------------
///统计页面开始
+ (void)logBeginPageViewName:(NSString *)viewName;

///统计页面结束
+ (void)logEndPageViewName:(NSString *)viewName;

///统计页面时长
+ (void)logPageViewName:(NSString *)viewName seconds:(int)seconds;


//--------------------------------------------- 事件统计 ---------------------------------------------

///事件统计
+ (void)logEventId:(NSString *)eventId;


///事件分类统计
+ (void)logEventId:(NSString *)eventId eventMark:(NSString *)eventMark;


///事件统计附带信息
+ (void)logEventId:(NSString *)eventId attachedInfo:(NSDictionary *)info;

///事件统计附带信息&&次数
+ (void)logEventId:(NSString *)eventId attachedInfo:(NSDictionary *)info count:(int)count;


//--------------------------------------------- 事件时长统计 ---------------------------------------------

///事件开始统计
+ (void)logBeginEventId:(NSString *)eventId;

///事件结束统计
+ (void)logEndEventId:(NSString *)eventId;

@end

NS_ASSUME_NONNULL_END
