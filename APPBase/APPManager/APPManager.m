//
//  APPManager.m
//  GFAPP
//
//  Created by XinKun on 2018/3/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPManager.h"

#define Current_Login_User @"current_login_user"

#define Current_Default_laocal @"current_default_local"

@implementation APPManager

///获取APP管理者
+ (APPManager *)sharedInstance
{
    static APPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APPManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if ([super init]) {
        //初始化数据
        [self initializeData];
    }
    return self;
}

///初始化信息
- (void)initializeData{
    
    //从本地沙盒获取用户数据（做加密处理）
    // 初始化本地用户信息(也可以指定到某个沙盒文件中去)
    id locaalData = [APPUserDefault objectForKey:Current_Login_User];
    
    NSData *base64Data;
    if ([locaalData isKindOfClass:[NSData class]]) {
        base64Data = (NSData *)locaalData;
    }
    //用户信息
    if (base64Data) {
        
        //转换
        NSData *dataUser = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
        
        self.userInfo = [APPUserInfoModel yy_modelWithJSON:dataUser];
        //判断是否登录
        self.isLogined = YES;
        self.isLoginOverdue = NO;
    }else{
        self.isLogined = NO;
        self.isLoginOverdue = NO;
    }
    
    NSDictionary *dicLocal = (NSDictionary *)[APPUserDefault objectForKey:Current_Default_laocal];
    if (dicLocal) {
        self.isSetDefaulLoacl = YES;
        self.defaultLoacalInfo = [APPDefautlLocalInfo yy_modelWithDictionary:dicLocal];
    }else{
        self.isSetDefaulLoacl = NO;
    }
    
}

///存储用户信息
- (void)storUserInfo:(NSDictionary *)userInfoDic{
    
    APPUserInfoModel *userModel = [[APPUserInfoModel alloc] init];
    [userModel yy_modelSetWithDictionary:userInfoDic];
    
    self.userInfo = userModel;
    self.isLogined = YES;
    self.isLoginOverdue = NO;
    
    //存储用户信息
    NSData *dataUser = [self.userInfo yy_modelToJSONData];
    
    dataUser = [dataUser base64EncodedDataWithOptions:0];
    if (dataUser) {
        [APPUserDefault setObject:dataUser forKey:Current_Login_User];
        [APPUserDefault synchronize];
    }
}

///存储默认地址信息
- (void)storeDefaultLocalInfoWithDic:(NSDictionary *)defaultLocalInfo{
    
    APPDefautlLocalInfo *localInfo = [APPDefautlLocalInfo yy_modelWithDictionary:defaultLocalInfo];
    
    self.defaultLoacalInfo = localInfo;
    self.isSetDefaulLoacl = YES;
    
    if (defaultLocalInfo) {
        
        [APPUserDefault setObject:defaultLocalInfo forKey:Current_Default_laocal];
        [APPUserDefault synchronize];
    }
}

///清除默认地址
- (void)clearDefaultLoacalInfo{
    
    [APPUserDefault removeObjectForKey:Current_Default_laocal];//清除默认地址信息
    [APPUserDefault synchronize];
    
    //清除位置model
    self.defaultLoacalInfo = nil;
    self.isSetDefaulLoacl = NO;
}

///清楚用户信息
- (void)clearUserInfo{
    
    [APPUserDefault removeObjectForKey:Current_Login_User];//清除用户信息
    [APPUserDefault removeObjectForKey:Current_Default_laocal];//清除默认地址信息
    [APPUserDefault removeObjectForKey:_kGlobal_localOrderInfo];//清楚本地订单信息
    [APPUserDefault synchronize];
    
    self.userInfo = nil;
    self.isLogined = NO;
    self.isLoginOverdue = NO;
    
    //清除位置model
    self.defaultLoacalInfo = nil;
    self.isSetDefaulLoacl = NO;
}

///主动退出
- (void)forcedExitUserWithShowControllerItemIndex:(NSInteger)index{
    
    //提示用户登录异常
    
    //清楚本地账户数据
    [self clearUserInfo];
    self.isLoginOverdue = YES;//登录过期
    
    //退出 && 回到指定页面
    UIWindow *mainWindow = ([UIApplication sharedApplication].delegate).window;
    UINavigationController *rootNavi = (UINavigationController *)mainWindow.rootViewController;
    
    //最后弹出
    [rootNavi popToRootViewControllerAnimated:YES];//直接弹到最上层
    
    //进行发送通知刷新所有的界面（利用通知进行刷新根VC）
    [APPNotificationCenter postNotificationName:_kGlobal_LoginStateChange object:nil];
    
}

///清楚URL缓存和web中产生的cookie
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    /**
     向指定URL进行存储cookie
     NSURL *url= [NSURL URLWithString:self.urlStr];
     
     NSString *hostStr= url.host;
     
     //注入Cookie
     
     NSMutableArray *myMuArr=[NSMutableArray array];
     
     NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
     
     [cookieProperties setObject:@"pId" forKey:NSHTTPCookieName];
     
     [cookieProperties setObject:[NSString stringWithFormat:@"%@",pUserID] forKey:NSHTTPCookieValue];
     
     [cookieProperties setObject:hostStr forKey:NSHTTPCookieDomain];
     
     [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
     
     [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
     
     NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookieProperties];
     
     [myMuArr addObject:cookie1];
     
     NSArray *mmmArr=[NSArray arrayWithArray:myMuArr];
     
     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:mmmArr forURL:url mainDocumentURL:url];
     
     NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]];
     
     [self.myWebView loadRequest:request];
     
     */
}


#pragma mark - 订单数量获取
///用get方法
- (NSInteger)loacalOrderCount{
    
    NSArray *arrayInfo = [APPUserDefault objectForKey:_kGlobal_localOrderInfo];
    
    _loacalOrderCount = arrayInfo.count > 0 ? arrayInfo.count : 0;
    
    return _loacalOrderCount;
}




@end
