//
//  APPLoginApi.m
//  APPBase
//
//  Created by 峰 on 2020/8/31.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "APPLoginApi.h"

///Apple 登录框架
#import <AuthenticationServices/AuthenticationServices.h>

@interface APPLoginApi () <ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic,strong) ASAuthorizationController *authorizationController API_AVAILABLE(ios(13.0));

@end

@implementation APPLoginApi

static APPLoginApi *login;

///苹果登录
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = [[self alloc] init];
    });
    return login;
}

+ (instancetype)alloc {
    return [self allocWithZone:NULL];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = [super allocWithZone:zone];
    });
    return login;
}

///获取苹果登录系统按钮
+ (UIControl *)getAppleIdButton  API_AVAILABLE(ios(13.0)) {
    
    ASAuthorizationAppleIDButton *appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleBlack];
    
    return appleIDBtn;
}


///苹果登录
- (void)appleLogin API_AVAILABLE(ios(13.0)) {
    
    if (!_authorizationController) {
        //基于用户的Apple ID 授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        
        //创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *authAppleIDRequest = [appleIDProvider createRequest];
        
        //在用户授权期间请求的联系信息
        authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeEmail,ASAuthorizationScopeFullName];
        
        //由ASAuthorizationAppleIDProvider 创建的授权请求  管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[authAppleIDRequest]];
        
        //设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        //设置提供 展示上下文的代理 ，在这个上下文中  系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        
        //在控制器初始化期间启动授权流
        //[authorizationController performRequests];
        
        
        /**
         ASAuthorizationPasswordRequest *passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init] createRequest];
         
         NSMutableArray <ASAuthorizationRequest *>*array = [NSMutableArray arrayWithCapacity:2];
         if (authAppleIDRequest) {
             [array addObject:authAppleIDRequest];
         }
         if (passwordRequest) {
             [array addObject:passwordRequest];
         }
         
         NSArray <ASAuthorizationRequest *>*requests = [array copy];
         
         ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
         authorizationController.delegate = self;
         authorizationController.presentationContextProvider = self;
         //[authorizationController performRequests];
         */
        
        _authorizationController = authorizationController;
    }
    
    [_authorizationController performRequests];//开始请求
}

#pragma mark- ASAuthorizationControllerDelegate
// 授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        
        // 苹果用户唯一标识符，该值在  「同一个开发者账号下的所有 App」 下是一样的，开发者可以用该  「唯一标识符」  与自己后台系统的账号体系绑定起来。
        NSString *userID = credential.user;
        
        //苹果用户信息 如果授权过，可能无法再次获取该信息
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *email = credential.email;
        
        // 服务器验证需要使用的参数
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        
        //用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported、unknown、likelyReal
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
        
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential * passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString *password = passwordCredential.password;
        NSLog(@"userID: %@", user);
        NSLog(@"password: %@", password);
    } else {
        NSLog(@"授权信息不符");
    }
}
// 授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"%@", errorMsg);
}

///告诉 ASAuthorizationController 在哪个 window 上显示。
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    return APPAlertTool.topViewControllerOfAPP.view.window;
}


///1—用户注销 AppleId 或 停止使用 Apple ID 的状态处理
- (void)checkAppleLoginState_1 API_AVAILABLE(ios(13.0)) {
    
    // 注意 存储用户标识信息需要使用钥匙串来存储 这里使用NSUserDefaults 做的简单示例
    NSString *userIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"appleID"];
    
    if (userIdentifier) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        [appleIDProvider getCredentialStateForUserID:userIdentifier
                                          completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            switch (credentialState) {
                case ASAuthorizationAppleIDProviderCredentialAuthorized:
                    //授权状态有效
                    break;
                case ASAuthorizationAppleIDProviderCredentialRevoked:
                    //苹果账号登录的凭据已被移除，需解除绑定并重新引导用户使用苹果登录
                    
                    break;
                case ASAuthorizationAppleIDProviderCredentialNotFound:
                    // 未登录授权，直接弹出登录页面，引导用户登录
                    
                    break;
                case ASAuthorizationAppleIDProviderCredentialTransferred:
                    // 授权AppleID提供者凭据转移
                    
                    break;
            }
        }];
    }
    
}


///2—用户注销 AppleId 或 停止使用 Apple ID 的状态处理
- (void)checkAppleLoginState_2:(NSNotification *)noti API_AVAILABLE(ios(13.0)) {
    
    //监听 ASAuthorizationAppleIDProviderCredentialRevokedNotification 通知
    // 注册通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    
    NSString *userIdentifier = (NSString *)noti.object;//noti.userInfo
    
    if (userIdentifier) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        [appleIDProvider getCredentialStateForUserID:userIdentifier
                                          completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            switch (credentialState) {
                case ASAuthorizationAppleIDProviderCredentialAuthorized:
                    //授权状态有效
                    break;
                case ASAuthorizationAppleIDProviderCredentialRevoked:
                    //苹果账号登录的凭据已被移除，需解除绑定并重新引导用户使用苹果登录
                    
                    break;
                case ASAuthorizationAppleIDProviderCredentialNotFound:
                    // 未登录授权，直接弹出登录页面，引导用户登录
                    
                    break;
                case ASAuthorizationAppleIDProviderCredentialTransferred:
                    // 授权AppleID提供者凭据转移
                    
                    break;
            }
        }];
    }
    
}

@end
