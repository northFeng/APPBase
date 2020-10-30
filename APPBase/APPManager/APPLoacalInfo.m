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

#import <sys/utsname.h>//要导入头文件

//获取IP地址
#import <ifaddrs.h>
#import <arpa/inet.h>

///UUID
NSString * const KEY_UDID_INSTEAD = @"com.appBase.udid";

@implementation APPLoacalInfo

//----------------------------------------------------------------------------------------------

///获取设备唯一标识
+ (NSString *)getDeviceIDInKeychain {
    NSString *getUDIDInKeychain = (NSString *)[self load:KEY_UDID_INSTEAD];
    //NSLog(@"从keychain中获取到的 UDID_INSTEAD %@",getUDIDInKeychain);
    if (!getUDIDInKeychain ||[getUDIDInKeychain isEqualToString:@""]||[getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        //NSLog(@"\n \n \n _____重新存储 UUID _____\n \n \n  %@",result);
        [self save:KEY_UDID_INSTEAD data:result];
        getUDIDInKeychain = (NSString *)[self load:KEY_UDID_INSTEAD];
    }
    //NSLog(@"最终 ———— UDID_INSTEAD %@",getUDIDInKeychain);
    return getUDIDInKeychain;
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            NSError *error;
            ret = [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:(__bridge NSData *)keyData error:&error];
        } @catch (NSException *e) {
            //NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

///存储字符串 到钥匙串本地
+ (void)storekeychain:(NSString *)chain key:(NSString *)key {
    [self save:key data:chain];
}

///获取钥匙串
+ (NSString *)getKeyChainForKey:(NSString *)key {
    
    NSString *chain = [self load:key];
    
    return chain;
}

//----------------------------------------------------------------------------------------------

///获取UUID
+ (NSString *)UUIDString {
    
    NSString *uuid = UIDevice.currentDevice.identifierForVendor.UUIDString;
    return uuid;
}

///获取随机UUID
+ (NSString *)UUIDCFString {
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    
    NSString *CUID = [uuid lowercaseString];
    CUID = [[CUID componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
    return CUID;
}

///设备人名字
+ (NSString *)phoneDevicesName {
    
    NSString *phoneDeviesName = [UIDevice currentDevice].name;
    return phoneDeviesName;
}

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

///APP名称
+ (NSString *)appName {
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return appName;
}

///app build版本
+ (NSString *)appBuildVersion {
    
    NSString *appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return appBuild;
}

//#import <sys/utsname.h>//要导入头文件
/**
 简书：https://www.jianshu.com/p/d0382538049a
 苹果官网 https://links.jianshu.com/go?to=https%3A%2F%2Fwww.theiphonewiki.com%2Fwiki%2FModels
 */
///获取 设备型号
+ (NSString *)deviceModel {
   
    struct utsname systemInfo;
    uname(&systemInfo);
   
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
   
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";

    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";

    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceModel;
}



static NSUInteger DeviceMember;
///获取设备内存 MB
+ (NSUInteger)DeviceMember {
    if (DeviceMember >0) {
        return DeviceMember;
    }
    
    double currentDeviceMemory= [NSProcessInfo processInfo].physicalMemory/1024/1024.f;
    DeviceMember = (NSUInteger)currentDeviceMemory;
    
    return DeviceMember;
}

///手机运营商
+ (NSString *)mobileOperators {
    
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry = [carrier carrierName];
    
    return currentCountry;
}

///获取网络类型
+ (NSString *)getNetWorkInfo{
    NSString *networktype = nil;
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
        case 0:
            networktype = @"无服务";
            break;
            
        case 1:
            networktype = @"2G";
            break;
            
        case 2:
            networktype = @"3G";
            break;
            
        case 3:
            networktype = @"4G";
            break;
            
        case 4:
            networktype = @"LTE";
            break;
            
        case 5:
            networktype = @"Wi-Fi";
            break;
        default:
            break;
    }
    return networktype;
    
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

// 设备是否越狱
+ (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath])
    {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath])
    {
        jailbroken = YES;
    }
    
#if TARGET_IS_IPHONE
    struct stat s;
    if (lstat("/Applications", &s) != 0) {
        if (s.st_mode & S_IFLNK) {
            //设备被感染
            jailbroken = YES;
        }
    }
#endif
    
    return jailbroken;
}

//获取IP地址
+ (NSString *)iPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

///是否按照SIM卡
+ (BOOL)isSIMInstalled {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    if (!carrier.isoCountryCode && !carrier.carrierName) {
        NSLog(@"No sim present Or No cellular coverage or phone is on airplane mode.");
        return NO;
    }
    return YES;
}



///跳转到苹果商店
+ (void)gotoAppleStore{
    
    NSString *appStoreUrl = [APPKeyInfo getAppStoreUrlString];
    [[UIApplication sharedApplication] openURL:kURLString(appStoreUrl)];
}

///App Store商店版本号
+ (NSString *)appStoreVersion{
    //http://itunes.apple.com/lookup?id=%@   //全球
    
    /** https://www.jianshu.com/p/aad031a0bb52
     
     利用 iTunes Search API 获取 app 信息

     其中一种方法是根据 app 的 id 来查找：
     http://itunes.apple.com/lookup?id=appId (appId为应用 id)
     或者
     http://itunes.apple.com/lookup?bundleId=bundleId (bundleId为应用的 BundleId)

     如果你的应用是在全世界范围内销售的话, 用上面的是没问题的
     但是,如果仅仅是在部分地区, 比如只在中国商店提供下载,就需要在路径是加上国家的缩写 cn.
     http://itunes.apple.com/cn/lookup?id=appId (appId为应用 id)
     同理, 利用 bundleId 获取也是一样的, 路径上需要加上地区 cn.
     http://itunes.apple.com/cn/lookup?bundleId=bundleId (bundleId为应用的 BundleId)
     否则你将会得到一个 results : [] 的结果
     */
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
