//
//  APPLoacalInfo.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/10/12.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "APPLoacalInfo.h"

//联网权限
@import CoreTelephony;

//定位权限
@import CoreLocation;

@implementation APPLoacalInfo

///手机系统版本号
+ (NSString *)phoneIOSVerion{
    NSString *phoneIOSVerion = [UIDevice currentDevice].systemVersion;
    return phoneIOSVerion;
}

///app版本号
+ (NSString *)appVerion{
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appVerion;
}

///跳转到苹果商店
+ (void)gotoAppleStore{
    
    NSString *appStoreUrl = [APPKeyInfo getAppStoreUrlString];
    [[UIApplication sharedApplication] openURL:kURLString(appStoreUrl)];
}


/**
///联网权限
+ (void)connectNetAuthorizationWithBlock:(APPBackBlock)block{
    
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted:
                NSLog(@"Restricrted");
                block(NO,nil);
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"Not Restricted");
                block(YES,nil);
                break;
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"Unknown");
                block(NO,nil);
                break;
            default:
                break;
        };
    };
}
 */


/**
///定位权限
+ (BOOL)locationAuthorization{
    
    //    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    //    if (!isLocation) {
    //        NSLog(@"not turn on the location");
    //    }
    
    
//     由于iOS8.0之后定位方法的改变，需要在info.plist中进行配置；
//     NSLocationWhenUseUsageDescription :使用时获取定位信息
//     NSLocationAlwaysUsageDescription：一直获取定位信息
    
    
    BOOL isAuthor = NO;
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    switch (CLstatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Always Authorized");
            isAuthor = YES;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"AuthorizedWhenInUse");
            isAuthor = YES;
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    
    return isAuthor;
}
 
 */

/**
///打开WIFI
+ (void)openWiFi{
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

///打开定位授权
+ (void)openLocation{
    //定位服务设置界面
    //NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}
 */





@end
