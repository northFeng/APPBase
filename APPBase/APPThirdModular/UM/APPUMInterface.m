//
//  APPUMInterface.m
//  APPBase
//
//  Created by 峰 on 2020/1/4.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "APPUMInterface.h"

#import <UMCommon/UMCommon.h>//友盟公共组件
//#import <UMShare/UMShare.h>//友盟登录分享
#import <UMAnalytics/MobClick.h>//友盟统计

@implementation APPUMInterface

#pragma mark - 初始化友盟
///初始化友盟SDK
+ (void)initUMSDK {
    
    [UMConfigure initWithAppkey:@"UMKey" channel:nil];//初始化友盟
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:YES];//设置打开日志
    
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /* 设置微信的appKey和appSecret */
    //[[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx55a20fd5bca1e31e" appSecret:@"d2c423dc10095c42a6e47c7013051984" redirectURL:@"http://mobile.umeng.com/social"];
    
    //[MobClick setCrashReportEnabled:YES];//开启崩溃收集
    
    //[MobClick setAutoPageEnabled:YES];//设置自动收集
}

///是否安装微信
//+ (BOOL)isInstallWX {
//
//    return [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession];
//}

///是否安装APP
//+ (BOOL)isInstallAppOfType:(UMSocialPlatformType)type {
//
//    return [[UMSocialManager defaultManager] isInstall:type];
//}

///设置系统回调
//+ (BOOL)handOpenUrl:(NSURL *)url options:(NSDictionary *)options {
//
//    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
//    return result;
//}

#pragma mark - ************************* 微信功能 *************************
///登录接口
+ (void)getWXUserInfoWithBlockResult:(APPBackBlock)resultBlock {
    
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:[APPAlertTool topViewControllerOfAPP] completion:^(id result, NSError *error) {
//
//        if (error) {
//            resultBlock(NO,error.description);
//        }else{
//            UMSocialUserInfoResponse *resp = result;
//
//            // 授权信息
//
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat unionid: %@", resp.unionId);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.unionGender);
//
//
//            resultBlock(YES,resp.originalResponse);
//        }
//    }];
}


///分享接口
+ (void)shareInfoWithTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage webUrl:(NSString *)webUrl shareType:(UMPlatformType)platformType blockResult:(APPBackBlock)resultBlock{
    /**(UMSocialPlatformType)platformType
    UMSocialPlatformType_WechatSession      = 1, //微信聊天
    UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
     */
    //创建分享消息对象
    
    /**
    UMShareWebpageObject *shareObjc = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
    shareObjc.webpageUrl = webUrl;
    
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObjc;
    
    UMSocialPlatformType shareType;
    switch (platformType) {
        case UMPlatformType_WechatSession:
            shareType = UMSocialPlatformType_WechatSession;//微信好友圈
            break;
        case UMPlatformType_WechatTimeLine:
            shareType = UMSocialPlatformType_WechatTimeLine;//微信朋友圈
            break;
            
        default:
            shareType = UMSocialPlatformType_WechatSession;//默认好友圈
            break;
    }

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:[APPAlertTool topViewControllerOfAPP] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            resultBlock(NO,error.description);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            resultBlock(YES,@"分享成功");
        }
    }];
     */
}



#pragma mark - ************************* 统计接口 *************************

//--------------------------------------------- 页面统计 ---------------------------------------------
///统计页面开始
+ (void)logBeginPageViewName:(NSString *)viewName {
    
    [MobClick beginLogPageView:viewName];
}

///统计页面结束
+ (void)logEndPageViewName:(NSString *)viewName {
    
    [MobClick endLogPageView:viewName];
}

///统计页面时长
+ (void)logPageViewName:(NSString *)viewName seconds:(int)seconds {
    
    [MobClick logPageView:viewName seconds:seconds];
}

//--------------------------------------------- 事件统计 ---------------------------------------------

///事件统计
+ (void)logEventId:(NSString *)eventId {
    
    [MobClick event:eventId];
}

///事件分类统计
+ (void)logEventId:(NSString *)eventId eventMark:(NSString *)eventMark {
    
    [MobClick event:eventId label:eventMark];
}

///事件统计附带信息
+ (void)logEventId:(NSString *)eventId attachedInfo:(NSDictionary *)info {
    
    [MobClick event:eventId attributes:info];
}

///事件统计附带信息&&次数
+ (void)logEventId:(NSString *)eventId attachedInfo:(NSDictionary *)info count:(int)count {
    
    [MobClick event:eventId attributes:info counter:count];
}


//--------------------------------------------- 事件时长统计 ---------------------------------------------

///事件开始统计
+ (void)logBeginEventId:(NSString *)eventId {
    
    [MobClick beginEvent:eventId];
}

///事件结束统计
+ (void)logEndEventId:(NSString *)eventId {
    
    [MobClick endEvent:eventId];
}


@end
