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

+ (BOOL)iPhoneOrIpad {
    
    BOOL isIphone = NO;
    
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
        case UIUserInterfaceIdiomPhone:
            isIphone = YES;
            break;
        case UIUserInterfaceIdiomPad:
            isIphone = NO;
            break;
        case UIUserInterfaceIdiomTV:
            isIphone = NO;
            break;
        case UIUserInterfaceIdiomCarPlay:
            isIphone = NO;
            break;
            
        default:
            break;
    }
    return isIphone;
}

///跳转到苹果商店
+ (void)gotoAppleStore{
    
    NSString *appStoreUrl = [APPKeyInfo getAppStoreUrlString];
    [[UIApplication sharedApplication] openURL:kURLString(appStoreUrl)];
}

///App Store商店版本号
+ (NSString *)appStoreVersion{
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",[APPKeyInfo getAppId]];//中国
    
    NSString *appStoreVersion = @"";
    /**
     {
     "resultCount" : 1,
     "results" : [{
     "artistId" : "开发者 ID",
     "artistName" : "开发者名称",
     "trackCensoredName" : "审查名称",
     "trackContentRating" : "评级",
     "trackId" : "应用程序 ID",
     "trackName" = "应用程序名称",
     "trackViewUrl" = "应用程序下载网址",
     "userRatingCount" = "用户评论数量",
     "userRatingCountForCurrentVersion" = "当前版本的用户评论数量",
     "version" = "版本号"
     }]
     }
     */
    NSString *appInfoString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    NSData *appInfoData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    if (appInfoData && appInfoData.length > 0) {
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:appInfoData options:NSJSONReadingMutableLeaves error:&error];
        
        if (!error && appInfoDic) {
            
            NSArray *arrayInfo = appInfoDic[@"results"];
            
            NSDictionary *resultDic = arrayInfo.firstObject;
            
            //版本号
            NSString *version = resultDic[@"version"];
            
            //应用程序名称
            //NSString *trackName = resultDic[@"trackName"];
            appStoreVersion = version;
        }
    }
    
    return appStoreVersion;
}

///判断是否有版本更新
+ (NSString *)judgeIsHaveUpdate{
    
    NSString *appStoreVerson = [self appStoreVersion];
    
    [APPManager sharedInstance].appstoreVersion = appStoreVerson;
    
    NSString *appLocalVerson = [self appVerion];
    
    BOOL isHaveUpdate = [self compareTheTwoVersionsAPPVerson:appStoreVerson localVerson:appLocalVerson];
    
    if (isHaveUpdate) {
        //新版本
        return appStoreVerson;
    }else{
        return @"";
    }
}

///比较两个版本 oneVerson > twoVerson——>YES  oneVerson <= twoVerson——>NO
+ (BOOL)compareTheTwoVersionsAPPVerson:(NSString *)storeVerson localVerson:(NSString *)localVerson{
    
    BOOL isHaveUpdate = NO;
    
    if (storeVerson.length > 0 && localVerson.length > 0 && ![storeVerson isEqualToString:localVerson]) {
        
        NSArray *arrayOne = [storeVerson componentsSeparatedByString:@"."];
        
        NSArray *arrayTwo = [localVerson componentsSeparatedByString:@"."];
        
        for (int i = 0; i < arrayOne.count ; i++) {
            
            NSString *numStrOne = [arrayOne gf_getItemWithIndex:i];
            
            NSString *numStrTwo = [arrayTwo gf_getItemWithIndex:i];
            
            if (numStrOne.length > 0 && numStrTwo.length > 0) {
                
                //进行比较
                NSInteger numStore = [numStrOne integerValue];
                
                NSInteger numLocal = [numStrTwo integerValue];
                
                if (numStore > numLocal) {
                    
                    isHaveUpdate = YES;
                    
                    break;
                }else if (numStore < numLocal){
                    //本地版本大于商店版本 ——> 这种情况只有未上线版本会出现
                    
                    break;
                }else{
                    //相等 继续循环
                }
                
            }else{
                if (numStrOne.length == 0 && numStrTwo.length > 0) {
                    //本地版本提前更新 && 本地版本号 长度变长
                    
                    break;
                }else if (numStrOne.length > 0 && numStrTwo.length == 0){
                    //线上版本出现新版本
                    isHaveUpdate = YES;
                    
                    break;
                }
            }
        }
    }
    
    return isHaveUpdate;
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

#pragma mark - 根据SDWebImage 处理内存呢
///获取缓存路径下文件大小
+ (NSInteger)getSDWebImageFileSize{
    
    //缓存
    SDImageCache *saImage = [SDImageCache sharedImageCache];
    
    return saImage.getSize;
}

///清理缓存路径下的文件
+ (void)clearDiskMemory{
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}




@end
