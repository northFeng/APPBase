//
//  APPKeyInfo.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/10.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPKeyInfo.h"


#pragma mark - 主机URL
///测试服务器
static NSString *const debugHostUrl = @"https://cxtest.bingex.com/seller/";

///release服务器
static NSString *const releaseHostUrl = @"https://shop.ishansong.com/seller/";


//闪送协议
static NSString * const shansongAgreement = @"http://www.ishansong.com/userAgreement";

//闪送隐私协议
static NSString * const privacyAgreement = @"https://shop.ishansong.com/shansongpp.html";



#pragma mark - key设置
///APPId
static NSString *const APPId = @"1438700286";

#pragma mark - 腾讯bugly注册APPID
///腾讯bugly测试统计
static NSString *const buglyIdDevelopment = @"fa47d6f717";//线上和线下同一个账号（特别要求可以分开）
///腾讯bugly线上统计
static NSString * const buglyIdProduct = @"fa47d6f717";

//百度地图秘钥
static NSString *const baiduAK = @"kwgHEFkZ7UlpFanRZwyBGBFemv4lbXGX";


@implementation APPKeyInfo

///获取APPID
+ (NSString *)getAppId{
    return APPId;
}

///获取App Store商店地址
+ (NSString *)getAppStoreUrlString{
    
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",APPId];//itms-apps://itunes.apple.com/app/id%@
    return urlString;
}

///主机域名
+ (NSString *)hostURL{
    NSString *hostUrl;
    
#if DEBUG
    hostUrl = debugHostUrl;
#else
    hostUrl = releaseHostUrl;
#endif
 
    return hostUrl;
}

//获取bugly注册的APPID
+ (NSString *)getBuglyId{
    NSString *buglyId;
    
#if DEBUG
    buglyId = buglyIdDevelopment;
#else
    buglyId = buglyIdProduct;
#endif
    
    return buglyId;
}


///获取百度地图秘钥
+ (NSString *)getBaiDuAK{
    
    return baiduAK;
}


///获取隐私协议地址
+ (NSString *)getUserAgreement{
    
    return shansongAgreement;
}


///隐私协议
+ (NSString *)getPrivacyAgreement{
    
    return privacyAgreement;
}



@end
