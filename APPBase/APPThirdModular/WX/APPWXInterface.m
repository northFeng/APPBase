//
//  APPWXInterface.m
//  APPBase
//
//  Created by 峰 on 2020/1/4.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "APPWXInterface.h"

@implementation APPWXInterface
{
    NSInteger _type;//0登录 1分享 2跳小程序
}

+ (instancetype)shareInstance
{
    static APPWXInterface *wxInter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wxInter = [[self alloc] init];
    });
    return wxInter;
}

- (instancetype)init {
    if (self = [super init]) {
        _type = 0;
    }
    return self;
}

///微信APP是否安装
- (BOOL)wxAPPIsInstalled {
    
    return [WXApi isWXAppInstalled];
}

///注册微信
- (void)registerWXAPP {
    
    //向微信注册
    BOOL sucess = [WXApi registerApp:@"wx55a20fd5bca1e31e" universalLink:@"https://m.wdkid.com/"];
    
    if (sucess) {
        NSLog(@"注册微信成功");
    }
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)continueUserActivity:(NSUserActivity *)userActivity {
    
   return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

///获取微信等信息
- (void)getWxUserInfoWithBlock:(APPBackBlock)blockLogin {
    
    if (blockLogin) {
        self.blockWX = blockLogin;
    }else{
        self.blockWX = ^(BOOL result, id idObject) {
            
        };
    }
    
    _type = 0;
    
    //构造SendAuthReq结构体
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req completion:^(BOOL success) {
        if (!success) {
            self.blockWX(NO, @"微信登录失败");
        }
    }];
}

///分享接口
- (void)shareInfoWithTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage webUrl:(NSString *)webUrl shareType:(WXPlatformType)platformType blockResult:(APPBackBlock)resultBlock {
    
    if (resultBlock) {
        self.blockWX = resultBlock;
    }else{
        self.blockWX = ^(BOOL result, id idObject) {
            
        };
    }
    
    _type = 1;
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = webUrl;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = descr;
    [message setThumbImage:thumImage];
    
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    
    /*! @brief 请求发送场景
     *
     */
    /**
//    enum WXScene {
//        WXSceneSession          = 0,   //< 聊天界面
//        WXSceneTimeline         = 1,   //< 朋友圈
//        WXSceneFavorite         = 2,   //< 收藏
//        WXSceneSpecifiedSession = 3,   //< 指定联系人
//    };
     */

    if (platformType == WXPlatformType_WechatSession) {
        req.scene = WXSceneSession;
    }else{
        req.scene = WXSceneTimeline;
    }
    
    [WXApi sendReq:req completion:^(BOOL success) {
        if (!success) {
            self.blockWX(NO,@"分享失败");
        }
    }];
}

///跳到微信小程序
- (void)gotoWxWebAPPWithAppPath:(NSString *)appPath webAppType:(WXAPPType)appType blockResult:(APPBackBlock)blockResult {
    
    _type = 2;
    
    if (blockResult) {
        self.blockWX = blockResult;
    }else{
        self.blockWX = ^(BOOL result, id idObject) {
            
        };
    }
        
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    
    NSString *appUserName = @"";
    switch (appType) {
        case WXAPPType_One:
            //游戏
            appUserName = @"gh_d0088124fc62";
            break;
        case WXAPPType_Two:
            //鲸打卡
            appUserName = @"gh_e91ddf2f1ccb";
            break;
            
        default:
            break;
    }
    launchMiniProgramReq.userName = appUserName;  //拉起的小程序的username
    launchMiniProgramReq.path = appPath;////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        if (!success) {
            self.blockWX(NO,@"跳转微信小程序失败");
        }
    }];
}


#pragma mark - ************************* WXApiDelegate *************************

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq*)req {
    NSLog(@"");
    
}



/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp*)resp {
    
    switch (_type) {
        case 0:
        {
            SendAuthResp *newResp = (SendAuthResp *)resp;
            NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
            [dicParam gf_setObject:@"wx55a20fd5bca1e31e" withKey:@"appid"];
            [dicParam gf_setObject:@"d2c423dc10095c42a6e47c7013051984" withKey:@"secret"];
            [dicParam gf_setObject:newResp.code withKey:@"code"];
            [dicParam gf_setObject:@"authorization_code" withKey:@"grant_type"];
            
            [APPHttpTool getWithUrl:@"https://api.weixin.qq.com/sns/oauth2/access_token" params:dicParam success:^(id  _Nonnull response, NSInteger code) {
                NSLog(@"微信第一步接口返回授权数据---->%@",[response yy_modelToJSONString]);
                NSDictionary *dicWx = (NSDictionary *)response;
                [self wxUserInfoWithAccess_token:dicWx[@"access_token"] openId:dicWx[@"openid"]];
            } fail:^(NSError * _Nonnull error, NSInteger httpCode) {
                self.blockWX(NO, @"获取微信信息失败");
            }];
        }
            break;
        case 1:
        {
            SendMessageToWXResp *newResp = (SendMessageToWXResp *)resp;
            if (newResp.errCode == 0) {
                self.blockWX(YES, @"");
            }else{
                self.blockWX(NO, @"分享失败");
            }
        }
            break;
        case 2:
        {
            
        }
           break;
            
        default:
            break;
    }
    
}

///微信授权成功——>获取微信用户信息
- (void)wxUserInfoWithAccess_token:(NSString *)access_token openId:(NSString *)openId {
    
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam gf_setObject:access_token withKey:@"access_token"];
    [dicParam gf_setObject:openId withKey:@"openid"];
    
    [APPHttpTool getWithUrl:@"https://api.weixin.qq.com/sns/userinfo" params:dicParam success:^(id  _Nonnull response, NSInteger code) {
        NSLog(@"微信第二步接口返回用户数据---->%@",[response yy_modelToJSONString]);
        self.blockWX(YES, response);//返回数据
    } fail:^(NSError * _Nonnull error, NSInteger httpCode) {
        self.blockWX(NO, @"获取微信信息失败");
    }];
}

@end
